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
Describe 'Test-End-Nodes' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It "Node list '<nodes>' should return <expected>" -TestCases @(
        @{nodes = @('XXZ'); expected = $true; }
        @{nodes = @('XXB'); expected = $false; }
        @{nodes = @('XZB'); expected = $false; }
        @{nodes = @('XAZ', 'XBZ'); expected = $true; }
        @{nodes = @('XAZ', 'XBA'); expected = $false; }
        @{nodes = @('XAA', 'XBA'); expected = $false; }
    ) {
        $rtnData = Test-End-Nodes $nodes
        $rtnData | Should -be $expected
    }
}

Describe 'Get-Start-Nodes' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It "Node list '<nodes>' should be of length <length>" -TestCases @(
        @{nodes = @('XXZ'); length = 0; }
        @{nodes = @('XXA'); length = 1; }
        @{nodes = @('XAX'); length = 0; }
        @{nodes = @('XXA', 'XXB'); length = 1; }
        @{nodes = @('XXA', 'XBA'); length = 2; }
        @{nodes = @('ABX', 'XAB'); length = 0; }
    ) {
        $rtnData = @(Get-Start-Nodes $nodes)
        $rtnData.length | Should -be $length
    }

    It "Node list '<nodes>' should have returned '<rtnNodes>'" -TestCases @(
        @{nodes = @('XXA'); rtnNodes = @('XXA'); }
        @{nodes = @('XXA', 'XXB'); rtnNodes = @('XXA'); }
        @{nodes = @('XXA', 'XBA'); rtnNodes = @('XXA', 'XBA'); }
    ) {
        $rtnData = @(Get-Start-Nodes $nodes)
        foreach ($node in $rtnData)
        {
            $rtnNodes.Contains($node) | Should -be $true
        }
    }
}

Describe 'Find-Dividers' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It "Dividers for <val> should be '<dividers>'" -TestCases @(
        @{val = 12; dividers = @(1, 2, 3, 4, 6, 12); }
        @{val = 33; dividers = @(1, 3, 11, 33); }
        @{val = 56465; dividers = @(1, 5, 23, 115, 491, 2455, 11293, 56465); }
        @{val = 23248; dividers = @(1, 2, 4, 8, 16, 1453, 2906, 5812, 11624, 23248); }
    ) {
        $rtnData = Find-Dividers $val
        $rtnData | Should -be $dividers
    }
}

Describe 'Find-GCD' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It "Greatest Common Divisors  for '<nums>' should be <val>" -TestCases @(
        @{nums = @(48, 84); val = 12; }
        @{nums = @(16, 5); val = 1; }
        @{nums = @(8946, 2548); val = 14; }
    ) {
        $rtnData = Find-GCD $nums
        $rtnData | Should -be $val
    }
}

Describe 'Find-LCM' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It "Lowest Common Multiple for '<mults>' should be <val>" -TestCases @(
        @{mults = @(1, 2, 3, 4, 5); val = 60; }
        @{mults = @(6, 12, 84, 23, 7); val = 1932; }
        @{mults = @(312, 84, 786, 48, 925); val = 529292400; }
    ) {
        $rtnData = Find-LCM $mults
        $rtnData | Should -be $val
    }
}