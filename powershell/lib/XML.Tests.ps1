BeforeAll {
    # Dynamic Link to file to test
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

    # Variables
    $global:outputBuffer = @{}
    $outputBuffer."screen" = @()

    # Function Mocking
    Mock Add-Content {
        $file = (Out-String -InputObject $PesterBoundParameters.Path).Trim()
        if ($outputBuffer.ContainsKey($file) -eq $false)
        {
            $outputBuffer.$file = @()
        }
        $outputBuffer.$file += @($PesterBoundParameters.Value)
    }
    Mock Set-Content {
        $file = (Out-String -InputObject $PesterBoundParameters.Path).Trim()
        $outputBuffer.$file = @($PesterBoundParameters.Value)
    }
    Mock Write-Host {
        $outputBuffer."screen" += @(@{
                "msg" = (Out-String -InputObject $PesterBoundParameters.Object).Trim()
                "color" = (Out-String -InputObject $PesterBoundParameters.ForegroundColor).Trim()
            })
    }
    Mock Get-Date {
        $returnVal = ""
        switch ($PesterBoundParameters.UFormat)
        {
            "%m-%d-%Y"
            {
                $returnVal = "01-01-2000"
                break
            }
            "%R"
            {
                $returnVal = "11:10"
                break
            }
            "%m/%d/%Y %R"
            {
                $returnVal = "01/01/2000 11:10"
                break
            }
            default
            {
                $returnVal = New-Object DateTime 2000, 1, 1, 11, 10, 0
                break
            }
        }
        return $returnVal
    }
}

# Tests
Describe 'Load-XML' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()

        Mock Get-Content {
            return '<?xml version="1.0" encoding="UTF-8" ?><test>	<testChild1>Test Data 1</testChild1>	<general>		<testChild2>Test Data 2</testChild2>	</general>	<attrib>		<testChild3 childAttrib1="Atrib1" childAttrib2="Atrib2">Test 3</testChild3>		<testChild1>Test Data 4</testChild1>	</attrib></test>'
        }

        $testData = "$($PSScriptRoot)\Tests.Data\XML\test.xml"
        $testXML = Load-XML -file $testData
    }

    It 'Get Lv 1 Value' {
        $expected = "Test Data 1"
        $testXML.test.testChild1 | Should -Be $expected
    }

    It 'Get Lv 2 Value' {
        $expected = "Test Data 2"
        $testXML.test.general.testChild2 | Should -Be $expected
    }

    It 'Get Attribute' {
        $expected = "Atrib1"
        $testXML.test.attrib.testChild3.childAttrib1 | Should -Be $expected
    }
}

Describe 'Fetch-XMLVal' {
    BeforeEach {
        [XML]$testXML = '<?xml version="1.0" encoding="UTF-8" ?><test><test1>val1</test1><test2><child>val 2</child></test2><test3><child>child 1</child><child>child 2</child></test3><test4><child1>child named 1</child1><child>child named 2</child></test4><test5 testAttrib="valAttrib">valText</test5></test>'
    }
    It 'Return 1st Level value' {
        $testVal = Fetch-XMLVal $testXML "test.test1"
        $expected = "val1"
        $testVal | Should -Be $expected
    }

    It 'return 2nd Level value' {
        $testVal = Fetch-XMLVal $testXML "test.test2.child"
        $expected = "val 2"
        $testVal | Should -Be $expected
    }

    It 'return 2nd Level value from identical children' {
        $testVal = Fetch-XMLVal $testXML "test.test3.child"
        $expected = "child 2"
        $testVal[1] | Should -Be $expected
    }

    It 'return 2nd Level value from same child name' {
        $testVal = Fetch-XMLVal $testXML "test.test4.child"
        $expected = "child named 2"
        $testVal | Should -Be $expected
    }

    It 'return attribute' {
        $testVal = Fetch-XMLVal $testXML "test.test5"
        $expected = "valAttrib"
        $testVal.testAttrib | Should -Be $expected
    }
}

Describe 'Load-Formatted-XML' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()

        Mock Get-Content {
            return '<?xml version="1.0" encoding="UTF-8" ?><test>	<testChild1>Test Data 1</testChild1>	<general>		<testChild2>{childAttrib1}</testChild2>	</general>	<attrib>		<testChild3 childAttrib1="Atrib1" childAttrib2="{testChild1}">Test 3</testChild3>		<testChild1>Test {data} Data 4</testChild1>	</attrib></test>'
        }

        $testData = "$($PSScriptRoot)\Tests.Data\XML\test-param.xml"
        $formattedVals = @{
            "{childAttrib1}" = "val 1"
            "{testChild1}" = "val2"
            "{data}" = "{val val 3}"
        }
        [XML]$testXML = Load-Formatted-XML -file $testData -mapping $formattedVals
    }

    It 'Get node value that has been updated' {
        $expected = "val 1"
        $testXML.test.general.testChild2 | Should -Be $expected
    }

    It 'Get attribute value that has been updated' {
        $expected = "val2"
        $testXML.test.attrib.testChild3.childAttrib2 | Should -Be $expected
    }

    It 'Get attribute value that has been updated in middle of string' {
        $expected = "Test {val val 3} Data 4"
        $testXML.test.attrib.testChild1 | Should -Be $expected
    }
}