BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')

    # Variables
    $global:outputBuffer = @{}
    $outputBuffer."screen" = @()

    # Function Mocking
    Mock Add-Content {
        $file = (Out-String -InputObject $PesterBoundParameters.Path).Trim()
        if($outputBuffer.ContainsKey($file) -eq $false)
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
        switch($PesterBoundParameters.UFormat)
        {
            "%m-%d-%Y" {
                $returnVal = "01-01-2000"
                break
            }
            "%R"{
                $returnVal = "11:10"
                break
            }
            "%m/%d/%Y %R"{
                $returnVal = "01/01/2000 11:10"
                break
            }
            default {
                $returnVal = New-Object DateTime 2000, 2, 1, 11, 10, 0
                break
            }
        }
        return $returnVal
    }
}

Describe 'Run-Command' {
    BeforeEach{
        Mock Invoke-Expression {return $PesterBoundParameters.Command}
        Mock Get-Date {
            $returnVal = ""
            switch($PesterBoundParameters.UFormat)
            {
                "%m-%d-%Y" {
                    $returnVal = "01-01-2000"
                    break
                }
                "%R"{
                    $returnVal = "11:10"
                    break
                }
            }
            return $returnVal
        }
        $global:outputBuffer = @{}
    }
    It 'Check that Log entry was made' {
        Run-Command "dir"
        $outputBuffer['.\_log\commands_01-01-2000.txt'][0] | Should -Be "[11:10] | dir"
    }
    It 'Check that command output is returned' {
        $returnData = Run-Command "dir"
        $returnData | Should -Be "& dir"
    }
}

Describe 'Initalize-Hash-Branch' {
    Context 'Empty Hash' {
        Context 'Child element' {
            BeforeEach{
                $hash = @{}
                $path = @("first-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should only have 1 child' {
                $initalizedHash.Keys.Count | Should -Be 1
            }
            It 'child should be first-child' {
                $initalizedHash.Keys[0] | Should -Be $path[0]
            }
            It 'child should be empty' {
                $initalizedHash."$($path[0])".Count | Should -Be 0
            }
        }

        Context 'Granndchild element' {
            BeforeEach{
                $hash = @{}
                $path = @("first-child","grand-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should only have 1 child' {
                $initalizedHash.Keys.Count | Should -Be 1
            }
            It 'child should be first-child' {
                $initalizedHash.Keys[0] | Should -Be $path[0]
            }
            It 'child should have 1 child' {
                $initalizedHash."$($path[0])".Keys.Count | Should -Be 1
            }
            It 'grandchild should be grand-child' {
                $initalizedHash."$($path[0])".Keys[0] | Should -Be $path[1]
            }
            It 'grandchild should be empty' {
                $initalizedHash."$($path[0])"."$($path[1])".Count | Should -Be 0
            }
        }

        Context 'Great Grandchild element' {
            BeforeEach{
                $hash = @{}
                $path = @("first-child","grand-child","great-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should only have 1 child' {
                $initalizedHash.Keys.Count | Should -Be 1
            }
            It 'child should be first-child' {
                $initalizedHash.Keys[0] | Should -Be $path[0]
            }
            It 'child should have 1 child' {
                $initalizedHash."$($path[0])".Keys.Count | Should -Be 1
            }
            It 'grandchild should be grand-child' {
                $initalizedHash."$($path[0])".Keys[0] | Should -Be $path[1]
            }
            It 'grandchild should have 1 child' {
                $initalizedHash."$($path[0])"."$($path[1])".Count | Should -Be 1
            }
            It 'great grandchild should be great-child' {
                $initalizedHash."$($path[0])"."$($path[1])".Keys[0] | Should -Be $path[2]
            }
            It 'great grandchild should be empty' {
                $initalizedHash."$($path[0])"."$($path[1])"."$($path[2])".Count | Should -Be 0
            }
        }
    }

    Context 'Existing Hash' {
        Context 'Child element' {
            BeforeEach{
                $hash = @{
                    "first" = 6
                    "second" = "two"
                    "third" = @(4,6,"twelove")
                    "4" = @{
                        "hellow" = "world"
                    }
                }
                $path = @("first-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should have 5 children' {
                $initalizedHash.Keys.Count | Should -Be 5
            }
            It 'one should be first-child' {
                $initalizedHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'child should be empty' {
                $initalizedHash."$($path[0])".Count | Should -Be 0
            }
        }

        Context 'Granndchild element' {
            BeforeEach{
                $hash = @{
                    "first" = 6
                    "second" = "two"
                    "third" = @(4,6,"twelove")
                    "4" = @{
                        "hellow" = "world"
                    }
                }
                $path = @("first-child","grand-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should have 5 children' {
                $initalizedHash.Keys.Count | Should -Be 5
            }
            It 'child should be first-child' {
                $initalizedHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'child should have 1 child' {
                $initalizedHash."$($path[0])".Keys.Count | Should -Be 1
            }
            It 'grandchild should be grand-child' {
                $initalizedHash."$($path[0])".Keys[0] | Should -Be $path[1]
            }
            It 'grandchild should be empty' {
                $initalizedHash."$($path[0])"."$($path[1])".Count | Should -Be 0
            }
        }

        Context 'Great Grandchild element' {
            BeforeEach{
                $hash = @{
                    "first" = 6
                    "second" = "two"
                    "third" = @(4,6,"twelove")
                    "4" = @{
                        "hellow" = "world"
                    }
                }
                $path = @("first-child","grand-child","great-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should have 5 children' {
                $initalizedHash.Keys.Count | Should -Be 5
            }
            It 'child should be first-child' {
                $initalizedHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'child should have 1 child' {
                $initalizedHash."$($path[0])".Keys.Count | Should -Be 1
            }
            It 'grandchild should be grand-child' {
                $initalizedHash."$($path[0])".Keys[0] | Should -Be $path[1]
            }
            It 'grandchild should have 1 child' {
                $initalizedHash."$($path[0])"."$($path[1])".Count | Should -Be 1
            }
            It 'great grandchild should be great-child' {
                $initalizedHash."$($path[0])"."$($path[1])".Keys[0] | Should -Be $path[2]
            }
            It 'great grandchild should be empty' {
                $initalizedHash."$($path[0])"."$($path[1])"."$($path[2])".Count | Should -Be 0
            }
        }
    }

    Context 'Existing Key in Hash' {
        Context 'first-child hash element' {
            BeforeEach{
                $hash = @{
                    "first" = 6
                    "second" = "two"
                    "third" = @(4,6,"twelove")
                    "first-child" = @{
                        "hellow" = "world"
                    }
                }
                $path = @("first-child","grand-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should only have 4 children' {
                $initalizedHash.Keys.Count | Should -Be 4
            }
            It 'one child should be first-child' {
                $initalizedHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'first-child should have 2 children' {
                $initalizedHash."$($path[0])".Keys.Count | Should -Be 2
            }
            It 'one grandchild should be grand-child' {
                $initalizedHash."$($path[0])".ContainsKey($path[1]) | Should -Be $true
            }
            It 'grand-child should be empty' {
                $initalizedHash."$($path[0])"."$($path[1])".Count | Should -Be 0
            }
        }

        Context 'grand-child non hash element' {
            BeforeEach{
                $global:outputBuffer = @{}
                $outputBuffer."screen" = @()
                $hash = @{
                    "first" = 6
                    "second" = "two"
                    "third" = @(4,6,"twelove")
                    "first-child" = @{
                        "hellow" = "world"
                        "grand-child" = "helo"
                        "54" = "8765"
                    }
                }
                $path = @("first-child","grand-child","great-child")
                $initalizedHash = Initalize-Hash-Branch $hash $path
            }

            It 'Should only have 4 children' {
                $initalizedHash.Keys.Count | Should -Be 4
            }
            It 'one child should be first-child' {
                $initalizedHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'first-child should have 2 children' {
                $initalizedHash."$($path[0])".Keys.Count | Should -Be 3
            }
            It 'one grandchild should be grand-child' {
                $initalizedHash."$($path[0])".ContainsKey($path[1]) | Should -Be $true
            }
            It 'grand-child should not be a hash' {
                $initalizedHash."$($path[0])"."$($path[1])".GetType().Name | Should -Not -Be "HashTable"
            }
            It 'have warning about datatype' {
                $outputBuffer."screen"[0].msg | Should -Be "[WARNING] 01/01/2000 11:10 | element $($path[1]) is not a Hash Object"
                $outputBuffer."screen"[0].color | Should -Be "Yellow"
            }
        }
    }
}

Describe 'Populate-Hash-Branch' {
    BeforeEach{
        $hash = @{
            "first" = 6
            "second" = "two"
            "third" = @(4,6,"twelove")
            "first-child" = @{
                "hellow" = "world"
                "grand-child" = "helo"
                "54" = "8765"
            }
            "existchild" = @{
                "hello" = "world"
                "existgarnd" = @{}
            }
        }
    }

    Context 'Adding new values' {
        Context 'creates string for child forth' {
            BeforeEach{
                $path = @("forth")
                $val = "test"
                $newHash = Populate-Hash-Branch $hash $path $val
            }
            It 'key forth exists as direct child' {
                
                $newHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'value set should be test' {
                
                $newHash."$($path[0])" | Should -Be $val
            }
        }

        Context 'creates string for new child-grandchild' {
            BeforeEach{
                $path = @("forth","child")
                $val = "test"
                $newHash = Populate-Hash-Branch $hash $path $val
            }
            It 'key forth exists as direct child' {
                
                $newHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'key child exists as grand child to forth' {
                
                $newHash."$($path[0])".ContainsKey($path[1]) | Should -Be $true
            }
            It 'value set should be test' {
                
                $newHash."$($path[0])"."$($path[1])" | Should -Be $val
            }
        }

        Context 'creates string for new child-grandchild-greatgrandchild' {
            BeforeEach{
                $path = @("forth","child","world")
                $val = "test"
                $newHash = Populate-Hash-Branch $hash $path $val
            }
            It 'key forth exists as direct child' {
                
                $newHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'key child exists as grand child to forth' {
                
                $newHash."$($path[0])".ContainsKey($path[1]) | Should -Be $true
            }
            It 'key child exists as grand child to forth' {
                
                $newHash."$($path[0])"."$($path[1])".ContainsKey($path[2]) | Should -Be $true
            }
            It 'value set should be test' {
                
                $newHash."$($path[0])"."$($path[1])"."$($path[2])" | Should -Be $val
            }
        }
    }

    Context 'Adding new values to existing keys' {
        Context 'creates string for new grandchild' {
            BeforeEach{
                $path = @("first-child","child")
                $val = "test"
                $newHash = Populate-Hash-Branch $hash $path $val
            }
            It 'existing child key exists' {
                
                $newHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'new grand child key is created for child key' {
                
                $newHash."$($path[0])".ContainsKey($path[1]) | Should -Be $true
            }
            It 'value set should be test' {
                
                $newHash."$($path[0])"."$($path[1])" | Should -Be $val
            }
        }

        Context 'creates string for new child-grandchild-greatgrandchild' {
            BeforeEach{
                $path = @("existchild","existgarnd","greatgrandchild")
                $val = "test"
                $newHash = Populate-Hash-Branch $hash $path $val
            }
            It 'existing child key exists' {
                $newHash.ContainsKey($path[0]) | Should -Be $true
            }
            It 'existing grand child exists' {
                $newHash."$($path[0])".ContainsKey($path[1]) | Should -Be $true
            }
            It 'new great grand child key is created for grand child key' {
                $newHash."$($path[0])"."$($path[1])".ContainsKey($path[2]) | Should -Be $true
            }
            It 'value set should be test' { 
                $newHash."$($path[0])"."$($path[1])"."$($path[2])" | Should -Be $val
            }
        }
    }

    Context 'Overwriting values' {
        It 'Overrite direct child' {
            $path = @("first")
            $val = 999
            $newHash = Populate-Hash-Branch $hash $path $val
            $newHash."$($path[0])" | Should -Be $val
        }

        It 'Overrite grand child' {
            $path = @("first-child","hellow")
            $val = 999
            $newHash = Populate-Hash-Branch $hash $path $val
            $newHash."$($path[0])"."$($path[1])" | Should -Be $val
        }

        It 'Overrite grand child with new great grand child' {
            $path = @("first-child","hellow","new-element")
            $val = 999
            $newHash = Populate-Hash-Branch $hash $path $val
            $newHash."$($path[0])"."$($path[1])"."$($path[2])" | Should -Be $val
        }
    }
}

Describe 'Fetch-XMLVal' {
    BeforeEach{
        [XML]$testXML = '<?xml version="1.0" encoding="UTF-8" ?><test><test1>val1</test1><test2><child>val 2</child></test2><test3><child>child 1</child><child>child 2</child></test3><test4><child1>child named 1</child1><child>child named 2</child></test4><test5 testAttrib="valAttrib">valText</test5></test>'
    }
    It 'Return 1st Level value' {
        $testVal = Fetch-XMLVal $testXML "test.test1"
        $testVal | Should -Be "val1"
    }

    It 'return 2nd Level value' {
        $testVal = Fetch-XMLVal $testXML "test.test2.child"
        $testVal | Should -Be "val 2"
    }

    It 'return 2nd Level value from identical children' {
        $testVal = Fetch-XMLVal $testXML "test.test3.child"
        $testVal[1] | Should -Be "child 2"
    }

    It 'return 2nd Level value from same child name' {
        $testVal = Fetch-XMLVal $testXML "test.test4.child"
        $testVal | Should -Be "child named 2"
    }

    It 'return attribue' {
        $testVal = Fetch-XMLVal $testXML "test.test5"
        $testVal.testAttrib | Should -Be "valAttrib"
    }
}

Describe 'Bulk-Replace' {
    It 'Bulk Replace just 1 value' {
        $string = "[REPLACE1] World"
        $values = @{
            "[REPLACE1]" = "Hello"
        }
        $string = Bulk-Replace $string $values
        $string | Should -Be "Hello World"
    }

    It 'Bulk Replace with 2 values' {
        $string = "[REPLACE1] World [REPLACE2]"
        $values = @{
            "[REPLACE1]" = "Hello"
            "[REPLACE2]" = "Two"
        }
        $string = Bulk-Replace $string $values
        $string | Should -Be "Hello World Two"
    }

    It 'Bulk Replace with 2 identical values' {
        $string = "[REPLACE1] World [REPLACE1]"
        $values = @{
            "[REPLACE1]" = "Echo"
            "[REPLACE2]" = "Two"
        }
        $string = Bulk-Replace $string $values
        $string | Should -Be "Echo World Echo"
    }

    It 'Bulk Replace with 2 no values' {
        $string = "Hello World"
        $values = @{
            "[REPLACE1]" = "Echo"
            "[REPLACE2]" = "Two"
        }
        $string = Bulk-Replace $string $values
        $string | Should -Be "Hello World"
    }
}

Describe 'FirstIndexOfAnyStr'{
    It 'Find match from Array' {
        $string = "one two three four five sex seven eight nine ten eleven twelve thirteen fourteen"
        $values = @(
            "eight",
            "bob",
            "two",
            "twelve"
        )
        $index = FirstIndexOfAnyStr $string $values
        $index | Should -Be 2
    }

    It 'Find no match' {
        $string = "one twso three four five sex seven eighst nine ten eleven twelvse thirteen fourteen"
        $values = @(
            "eight",
            "bob",
            "two",
            "twelve"
        )
        $index = FirstIndexOfAnyStr $string $values
        $index | Should -Be -1
    }
}

Describe 'LastIndexOfAnyStr'{
    It 'Find match from Array' {
        $string = "one two three four five ten eleven twelve sex seven eight nine thirteen fourteen"
        $values = @(
            "eight",
            "bob",
            "two",
            "twelve"
        )
        $index = LastIndexOfAnyStr $string $values
        $index | Should -Be 0
    }

    It 'Find no match' {
        $string = "one twso three four five ten eleven twelvse sex seven eighst nine thirteen fourteen"
        $values = @(
            "eight",
            "bob",
            "two",
            "twelve"
        )
        $index = LastIndexOfAnyStr $string $values
        $index | Should -Be -1
    }
}

Describe 'Find-Bell' {
    It 'Returns Bell Character position' {
        $string = "test$([char]7)string"
        $index = Find-Bell $string
        $index | Should -Be 4
    }

    It 'Returns 1st Bell Character position' {
        $string = "test$([char]7)stri$([char]7)ng"
        $index = Find-Bell $string
        $index | Should -Be 4
    }

    It 'Returns -1 when no bell is found' {
        $string = "test string"
        $index = Find-Bell $string
        $index | Should -Be -1
    }

    It 'Returns 2nd Bell Character position when first is removed' {
        $string = "test$([char]7)stri$([char]7)ng"
        $string = $string.Remove(4,1)
        $index = Find-Bell $string
        $index | Should -Be 8
    }
}

Describe 'Repair-Trim' {
    It 'Does a regular Trim when no specialized characters' {
        $string = " Test "
        $testStr = Repair-Trim $string
        $testStr | Should -Be "Test"
        $testStr.Length | Should -be 4
    }

    Context "Special Characters" {
        It 'Trims <name> Character from String' -TestCases @(
            @{Name = "Bell"; Char = ([char]7)}
        ){
            $string = "$($char)Test$($char)"
            $testStr = Repair-Trim $string
            $testStr | Should -Be "Test"
            $testStr.Length | Should -be 4
        }

        It 'Trims <name> Character from String with touching instances in the String' -TestCases @(
            @{Name = "Bell"; Char = ([char]7)}
        ){
            $string = "$($char)Te$($char)st$($char)"
            $testStr = Repair-Trim $string
            $testStr | Should -Be "Te$($char)st"
            $testStr.Length | Should -be 5
        }

        It 'Trims <name> Character from String with Spaces' -TestCases @(
            @{Name = "Bell"; Char = ([char]7)}
        ){
            $string = "$($char) $($char)Test$($char) "
            $testStr = Repair-Trim $string
            $testStr | Should -Be "Test"
            $testStr.Length | Should -be 4
        }
    }
}

Describe 'Test-Function-Exists'{
    BeforeEach{
        Mock Write-Success {}
        Mock Write-Error {}
    }
    It 'Find Command that exists' {
        Test-Function-Exists "Should" $false
        Should -Invoke -CommandName Write-Success -Times 1
    }

    It 'Unable to find Command' {
        Test-Function-Exists "Shoulds" $false
        Should -Invoke -CommandName Write-Error -Times 1
    }
}

Describe 'Test-Function-Loop'{
    BeforeEach{
        Mock Write-Success {}
        Mock Write-Error {}
    }
    It 'Find All Command that exists' {
        $commands = @(
            "Should",
            "Describe",
            "It"
        )
        Test-Function-Loop $commands $false
        Should -Invoke -CommandName Write-Success -Times 3
    }

    It 'Unable to find 1 Command out of 3' {
        $commands = @(
            "Should",
            "Describes",
            "It"
        )
        Test-Function-Loop $commands $false
        Should -Invoke -CommandName Write-Success -Times 2
        Should -Invoke -CommandName Write-Error -Times 1
    }

    It 'Unable to any Commands' {
        $commands = @(
            "Shoulds",
            "Describes",
            "Its"
        )
        Test-Function-Loop $commands $false
        Should -Invoke -CommandName Write-Error -Times 3
    }
}

Describe 'Count-Array-Matches'{
    BeforeEach{
        $collection = @("Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "Lorem", "adipiscing", "elit", "Aliquam", "metus", "Lorem", "nunc", "venenatis", "eu", "fermentum", "at")
    }
    It 'Find 1 match' {
        $toFind = @("sit")
        $matches = Count-Array-Matches $collection $toFind
        $matches | Should -Be 1
    }

    It 'Find 3 matches' {
        $toFind = @("sit", "dolor", "nunc")
        $matches = Count-Array-Matches $collection $toFind
        $matches | Should -Be 3
    }

    It 'Find 0 matches' {
        $toFind = @("hello", "world")
        $matches = Count-Array-Matches $collection $toFind
        $matches | Should -Be 0
    }

    It 'Find 1 match in to find array while match is duplicated in collection array' {
        $toFind = @("Lorem")
        $matches = Count-Array-Matches $collection $toFind
        $matches | Should -Be 1
    }
}

Describe 'Initalize-Array'{
    It 'New Array with no paramaters passed defaulting to 1 null value' {
        $newArray = @(Initalize-Array)
        $newArray.Length | Should -Be 1
        $newArray[0] | Should -Be $null
    }

    It 'New 1-size array' {
        $newArray = @(Initalize-Array 1)
        $newArray.Length | Should -Be 1
    }

    It 'New 2-size array' {
        $newArray = Initalize-Array 2
        $newArray.Length | Should -Be 2
    }

    It 'New 2-size array with hello as default' {
        $newArray = Initalize-Array 2 @("hello")
        $newArray.Length | Should -Be 2
        $newArray[0] | Should -Be "hello"
        $newArray[1] | Should -Be "hello"
    }

    It 'New 10-size array with hello as default' {
        $newArray = Initalize-Array 10 @("hello")
        $newArray.Length | Should -Be 10
        $newArray[0] | Should -Be "hello"
        $newArray[1] | Should -Be "hello"
        $newArray[8] | Should -Be "hello"
        $newArray[9] | Should -Be "hello"
    }

    It 'New 2-size array with defaults hello and world' {
        $newArray = Initalize-Array 2 @("hello", "world")
        $newArray.Length | Should -Be 2
        $newArray[0] | Should -Be "hello"
        $newArray[1] | Should -Be "world"
    }

    It 'New 10-size array with uneven default array' {
        $newArray = Initalize-Array 10 @("hello","all","worlds")
        $newArray.Length | Should -Be 10
        $newArray[0] | Should -Be "hello"
        $newArray[1] | Should -Be "all"
        $newArray[2] | Should -Be "worlds"
        $newArray[6] | Should -Be "hello"
        $newArray[7] | Should -Be "all"
        $newArray[8] | Should -Be "worlds"
        $newArray[9] | Should -Be "hello"
    }
}

Describe 'Add-Into-Array'{
    BeforeEach{
        Mock New-Item {}
        Mock Split-Path {
            $split = $PesterBoundParameters.Path -Split "/"

            return $split[0..($split.Length-1)] -Join "/"
        }
    }

    It 'Inserting value <addVal> into index <injectingPos> of array <initArrStr>' -TestCases @(
        @{initArr = @("a", "b", "c"); injectingPos = 1; addVal = "d"; initArrStr = "(a, b, c)"}
        @{initArr = @("a", "b", "c"); injectingPos = 2; addVal = "d"; initArrStr = "(a, b, c)"}
        @{initArr = @("a", "b", "c"); injectingPos = 0; addVal = "d"; initArrStr = "(a, b, c)"}
        @{initArr = @("a"); injectingPos = 0; addVal = "d"; initArrStr = "(a)"}
        @{initArr = @("a"); injectingPos = 1; addVal = "d"; initArrStr = "(a)"}
    ){
        $newArray = Add-Into-Array $initArr $addVal $injectingPos
        $expectedLength = $initArr.length+1

        $newArray.Length | Should -Be $expectedLength
        for($i = 0; $i -lt $newArray.length; $i++)
        {
            $testval = "NOVAL"
            if($i -lt $injectingPos)
            {
                $testval = $initArr[$i]
            }
            elseif($i -gt $injectingPos)
            {
                $testval = $initArr[$i-1]
            }
            else
            {
                $testval = $addVal
            }

            $newArray[$i] | Should -Be $testval
        }
    }
}

Describe 'Create-Path'{
    BeforeEach{
        Mock New-Item {}
        Mock Split-Path {
            $split = $PesterBoundParameters.Path -Split "/"

            return $split[0..($split.Length-1)] -Join "/"
        }
    }
    It 'New Directory would be created' {
        Create-Path "c:\test\path"
        Should -Invoke -CommandName New-Item -Times 1
    }

    It 'New Directory would be created from file path' {
        Create-Path "c:\test\path\tesfile.txt"
        Should -Invoke -CommandName Split-Path -Times 1
        Should -Invoke -CommandName New-Item -Times 1
    }
}

Describe 'Group-Replace'{
    It 'Change String with Find Array of size 1' {
        $string = "Hello World"
        $findArr = @("Hell")
        $replaceStr = "DING"
        $string = (Group-Replace $string $findArr $replaceStr )
        $string  | Should -Be "DINGo World"
    }

    It 'Change String with Find Array of size 3 with 1 value match' {
        $string = "Hello World"
        $findArr = @("Hell", "Heav", "lol")
        $replaceStr = "DING"
        $string = (Group-Replace $string $findArr $replaceStr )
        $string  | Should -Be "DINGo World"
    }

    It 'String remains the same when theres no match' {
        $string = "Hecko World"
        $findArr = @("Hell")
        $replaceStr = "DING"
        $string = (Group-Replace $string $findArr $replaceStr )
        $string  | Should -Be "Hecko World"
    }

    It 'Change String with Find Array of size 1 with 1 value matched multiple times' {
        $string = "Hello Hell World"
        $findArr = @("Hell")
        $replaceStr = "DING"
        $string = (Group-Replace $string $findArr $replaceStr )
        $string  | Should -Be "DINGo DING World"
    }

    It 'Change String with Find Array of size 3 with 2 single matches' {
        $string = "Hello Heavy World"
        $findArr = @("Hell", "Heav", "lol")
        $replaceStr = "DING"
        $string = (Group-Replace $string $findArr $replaceStr )
        $string  | Should -Be "DINGo DINGy World"
    }

    It 'Change String with Find Array of size 3 with 1 single match and 1 multiple times' {
        $string = "Hello Heavy Hell World"
        $findArr = @("Hell", "Heav", "lol")
        $replaceStr = "DING"
        $string = (Group-Replace $string $findArr $replaceStr)
        $string | Should -Be "DINGo DINGy DING World"
    }
}


Describe 'Get-Version'{
    BeforeEach{
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It 'should split into major, minor and bug numbers' {
        $versionStr = "1.2.3"
        $version = Get-Version $versionStr
        $version."major" | Should -Be 1
        $version."minor" | Should -Be 2
        $version."bug" | Should -Be 3
    }

    It 'should split into major, minor and bug numbers with - as delimiter' {
        $versionStr = "1-2-3"
        $delimiter = "-"
        $version = Get-Version $versionStr $delimiter
        $version."major" | Should -Be 1
        $version."minor" | Should -Be 2
        $version."bug" | Should -Be 3
    }

}

Describe 'Merge-Hash'{
    BeforeEach{
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It 'merges 2 hash objects with different keys' {
        $hash1 = @{"key 1" = "val 1"}
        $hash2 = @{"key 2" = "val 2"}
        $mergedHash = Merge-Hash $hash1 $hash2
        $mergedHash."key 1" | Should -Be "val 1"
        $mergedHash."key 2" | Should -Be "val 2"
    }
    It 'merges 2 hash objects with identical keys' {
        $hash1 = @{"key 1" = "val 1"}
        $hash2 = @{"key 1" = "val 2"}
        $mergedHash = Merge-Hash $hash1 $hash2
        $mergedHash."key 1"[0] | Should -Be "val 1"
        $mergedHash."key 1"[1] | Should -Be "val 2"
    }
    It 'merges 2 hash objects with identical keys with one array value' {
        $hash1 = @{"key 1" = "val 1"}
        $hash2 = @{"key 1" = @("val 2", "val 3")}
        $mergedHash = Merge-Hash $hash1 $hash2
        $mergedHash."key 1"[0] | Should -Be "val 1"
        $mergedHash."key 1"[1] | Should -Be "val 2"
        $mergedHash."key 1"[2] | Should -Be "val 3"
    }
    It 'merges 2 hash objects with identical keys with two array values' {
        $hash1 = @{"key 1" = @("val 1", "val 4")}
        $hash2 = @{"key 1" = @("val 2", "val 3")}
        $mergedHash = Merge-Hash $hash1 $hash2
        $mergedHash."key 1"[0] | Should -Be "val 1"
        $mergedHash."key 1"[1] | Should -Be "val 4"
        $mergedHash."key 1"[2] | Should -Be "val 2"
        $mergedHash."key 1"[3] | Should -Be "val 3"
    }
    It 'merges 2 hash objects with identical keys with one hash value' {
        $hash1 = @{"key 1" = "val 1"}
        $hash2 = @{"key 1" = @{"subkey1" = "val 2"; "subkey2" = "val 3"}}
        $mergedHash = Merge-Hash $hash1 $hash2
        $mergedHash."key 1"[0] | Should -Be "val 1"
        $mergedHash."key 1"[1]."subkey1" | Should -Be "val 2"
        $mergedHash."key 1"[1]."subkey2" | Should -Be "val 3"
    }
    It 'merges 2 hash objects with identical keys with two hash values' {
        $hash1 = @{"key 1" = @{"subkey3" = "val 1"; "subkey4" = "val 4"}}
        $hash2 = @{"key 1" = @{"subkey1" = "val 2"; "subkey2" = "val 3"}}
        $mergedHash = Merge-Hash $hash1 $hash2
        $mergedHash."key 1"[0]."subkey3" | Should -Be "val 1"
        $mergedHash."key 1"[0]."subkey4" | Should -Be "val 4"
        $mergedHash."key 1"[1]."subkey1" | Should -Be "val 2"
        $mergedHash."key 1"[1]."subkey2" | Should -Be "val 3"
    }

}

Describe 'Compress-Spaces'{
    BeforeEach{
        Mock Create-Path {}
        $global:fileOutputBuffer = @{}
    }

    It 'Compresses 1 instance of 2 spaces' {
        $str = Compress-Spaces "Hello  World"
        $str  | Should -Be "Hello World"
    }

    It 'Compresses 1 instance of 3 spaces' {
        $str = Compress-Spaces "Hello  World"
        $str  | Should -Be "Hello World"
    }

    It 'Compresses multiple instances of multis spaces' {
        $str = Compress-Spaces "Hello   Big   Wide    World"
        $str  | Should -Be "Hello Big Wide World"
    }
}

Describe 'Append-File'{
    BeforeEach{
        Mock Create-Path {}
        $global:outputBuffer = @{}
    }

    It 'Create File and insert 1 line' {
        Append-File "c:\test\path\tesfile.txt" "Test"
        $outputBuffer['c:\test\path\tesfile.txt'][0] | Should -Be "Test"
    }

    It 'Create File and insert 3 lines using new line characters' {
        Append-File "c:\test\path\tesfile.txt" "Test"
        $outputBuffer['c:\test\path\tesfile.txt'][0] | Should -Be "Test"
    }

    It 'Create File and insert 3 line' {
        Append-File "c:\test\path\tesfile.txt" "Test Line 1"
        Append-File "c:\test\path\tesfile.txt" "Test Line 2"
        Append-File "c:\test\path\tesfile.txt" "Test Line 3"
        $outputBuffer['c:\test\path\tesfile.txt'][0] | Should -Be "Test Line 1"
        $outputBuffer['c:\test\path\tesfile.txt'][1] | Should -Be "Test Line 2"
        $outputBuffer['c:\test\path\tesfile.txt'][2] | Should -Be "Test Line 3"
    }
}

Describe 'Write-File'{
    BeforeEach{
        Mock Create-Path {}
        $global:outputBuffer = @{}
    }

    It 'Create File and insert 1 line' {
        Write-File "c:\test\path\tesfile.txt" "Test"
        $outputBuffer['c:\test\path\tesfile.txt'][0] | Should -Be "Test"
    }

    It 'Create File with only 1 line' {
        Write-File "c:\test\path\tesfile.txt" "Test Line 1"
        Write-File "c:\test\path\tesfile.txt" "Test Line 2"
        Write-File "c:\test\path\tesfile.txt" "Test Line 3"
        $outputBuffer['c:\test\path\tesfile.txt'][0] | Should -Be "Test Line 3"
    }
}