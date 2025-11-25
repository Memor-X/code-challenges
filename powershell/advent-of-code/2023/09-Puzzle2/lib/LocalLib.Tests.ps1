BeforeAll {
    # Dyanmic Link to file to test
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

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
Describe 'Test-Array-Single-Value' {
    BeforeEach {
        $global:outputBuffer = @{}
        $outputBuffer."screen" = @()
    }

    It 'should return true when array of all 0' {
        $testValArr = @("0", "0", "0")
        $testVal = "0"
        $expectedVal = $true
        $result = Test-Array-Single-Value -arr $testValArr -val $testVal
        $result | Should -Be $expectedVal
    }

    It 'should return true when array not all 0' {
        $testValArr = @("0", "1", "0")
        $testVal = "0"
        $expectedVal = $false
        $result = Test-Array-Single-Value -arr $testValArr -val $testVal
        $result | Should -Be $expectedVal
    }

    It 'should return true when single index array but not same as test value' {
        $testValArr = @("0", "0", "0")
        $testVal = "1"
        $expectedVal = $false
        $result = Test-Array-Single-Value -arr $testValArr -val $testVal
        $result | Should -Be $expectedVal
    }

    It 'should return false when array of all 0 string but test val is int' {
        $testValArr = @("0", "0", "0")
        $testVal = 0
        $expectedVal = $false
        $result = Test-Array-Single-Value -arr $testValArr -val $testVal
        $result | Should -Be $expectedVal
    }

    It 'should return true when array was just 1 length from the start' {
        $testValArr = @("0")
        $testVal = "0"
        $expectedVal = $true
        $result = Test-Array-Single-Value -arr $testValArr -val $testVal
        $result | Should -Be $expectedVal
    }

    It 'should return false when array was just 1 length from the start but doesnt match test value' {
        $testValArr = @("1")
        $testVal = "0"
        $expectedVal = $false
        $result = Test-Array-Single-Value -arr $testValArr -val $testVal
        $result | Should -Be $expectedVal
    }
}

Describe 'Calculate-Dataset' {
    Context '6 value dataset (0 3 6 9 12 15)' {
        BeforeEach {
            $testVal = "0 3 6 9 12 15"
            $result = Calculate-Dataset $testVal
        }

        It 'results have 3 datasets' {
            $expectedVal = 3
            $result.Length | Should -Be $expectedVal
        }

        It '1st dataset should be original data but as array' {
            $expectedVal = $testVal.split(" ")
            $result[0] | Should -Be $expectedVal
        }
        It '2nd dataset should contain 5 values' {
            $expectedVal = 5
            $result[1].Length | Should -Be $expectedVal
        }
        It '2nd dataset should be all 3' {
            $expectedVal = @(3, 3, 3, 3, 3)
            $result[1] | Should -Be $expectedVal
        }
        It '3rd dataset should contain 4 values' {
            $expectedVal = 4
            $result[2].Length | Should -Be $expectedVal
        }
        It '3rd dataset should be all 0' {
            $expectedVal = @(0, 0, 0, 0)
            $result[2] | Should -Be $expectedVal
        }
    }

    Context '4 value dataset (0 3 6 9)' {
        BeforeEach {
            $testVal = "0 3 6 9"
            $result = Calculate-Dataset $testVal
        }

        It 'results have 3 datasets' {
            $expectedVal = 3
            $result.Length | Should -Be $expectedVal
        }

        It '1st dataset should be original data but as array' {
            $expectedVal = $testVal.split(" ")
            $result[0] | Should -Be $expectedVal
        }
        It '2nd dataset should contain 3 values' {
            $expectedVal = 3
            $result[1].Length | Should -Be $expectedVal
        }
        It '2nd dataset should be all 3' {
            $expectedVal = @(3, 3, 3)
            $result[1] | Should -Be $expectedVal
        }
        It '3rd dataset should contain 2 values' {
            $expectedVal = 2
            $result[2].Length | Should -Be $expectedVal
        }
        It '3rd dataset should be all 0' {
            $expectedVal = @(0, 0)
            $result[2] | Should -Be $expectedVal
        }
    }

    Context '3 value dataset (0 3 6)' {
        BeforeEach {
            $testVal = "0 3 6"
            $result = Calculate-Dataset $testVal
        }

        It 'results have 3 datasets' {
            $expectedVal = 3
            $result.Length | Should -Be $expectedVal
        }

        It '1st dataset should be original data but as array' {
            $expectedVal = $testVal.split(" ")
            $result[0] | Should -Be $expectedVal
        }
        It '2nd dataset should contain 2 values' {
            $expectedVal = 2
            $result[1].Length | Should -Be $expectedVal
        }
        It '2nd dataset should be all 3' {
            $expectedVal = @(3, 3)
            $result[1] | Should -Be $expectedVal
        }
        It '3rd dataset should contain 1 values' {
            $expectedVal = 1
            $result[2].Length | Should -Be $expectedVal
        }
        It '3rd dataset should be 0' {
            $expectedVal = @(0)
            $result[2] | Should -Be $expectedVal
        }
    }

    Context '2 value dataset (0 3)' {
        BeforeEach {
            $testVal = "0 3"
            $result = Calculate-Dataset $testVal
        }

        It 'results have 2 datasets' {
            $expectedVal = 2
            $result.Length | Should -Be $expectedVal
        }

        It '1st dataset should be original data but as array' {
            $expectedVal = $testVal.split(" ")
            $result[0] | Should -Be $expectedVal
        }
        It '2nd dataset should contain 1 values' {
            $expectedVal = 1
            $result[1].Length | Should -Be $expectedVal
        }
        It '2nd dataset should be 3' {
            $expectedVal = @(3)
            $result[1] | Should -Be $expectedVal
        }
    }

    Context '1 value dataset (3)' {
        BeforeEach {
            $testVal = "3"
            $result = Calculate-Dataset $testVal
        }

        It 'results have 1 datasets' {
            $expectedVal = 1
            $result.Length | Should -Be $expectedVal
        }

        It '1st dataset should be original data but as array' {
            $expectedVal = $testVal.split(" ")
            $result[0] | Should -Be $expectedVal
        }
    }

    Context '1 value dataset (0)' {
        BeforeEach {
            $testVal = "0"
            $result = Calculate-Dataset $testVal
        }

        It 'results have 1 datasets' {
            $expectedVal = 1
            $result.Length | Should -Be $expectedVal
        }

        It '1st dataset should be original data but as array' {
            $expectedVal = $testVal.split(" ")
            $result[0] | Should -Be $expectedVal
        }
    }
}

Describe 'Predict-Dataset' {
    Context 'from 6 value dataset (0 3 6 9 12 15)' {
        BeforeEach {
            $testVal = @(
                @(0, 3, 6, 9, 12, 15),
                @(3, 3, 3, 3, 3),
                @(0, 0, 0, 0)
            )
            $result = Predict-Dataset $testVal
        }

        It 'Dataset 2 has 6 values' {
            $expectedVal = 6
            $result[1].Length | Should -Be $expectedVal
        }
        It 'New value for data 2 is 3' {
            $expectedVal = 3
            $result[1][$result[1].Length - 1] | Should -Be $expectedVal
        }

        It 'Dataset 1 has 7 values' {
            $expectedVal = 7
            $result[0].Length | Should -Be $expectedVal
        }
        It 'New value for data 1 is 18' {
            $expectedVal = 18
            $result[0][$result[0].Length - 1] | Should -Be $expectedVal
        }
    }

    Context 'from 4 value dataset (0 3 6 9)' {
        BeforeEach {
            $testVal = @(
                @(0, 3, 6, 9),
                @(3, 3, 3),
                @(0, 0)
            )
            $result = Predict-Dataset $testVal
        }

        It 'Dataset 2 has 4 values' {
            $expectedVal = 4
            $result[1].Length | Should -Be $expectedVal
        }
        It 'New value for data 2 is 3' {
            $expectedVal = 3
            $result[1][$result[1].Length - 1] | Should -Be $expectedVal
        }

        It 'Dataset 1 has 5 values' {
            $expectedVal = 5
            $result[0].Length | Should -Be $expectedVal
        }
        It 'New value for data 1 is 12' {
            $expectedVal = 12
            $result[0][$result[0].Length - 1] | Should -Be $expectedVal
        }
    }

    Context '3 value dataset (0 3 6)' {
        BeforeEach {
            $testVal = @(
                @(0, 3, 6),
                @(3, 3),
                @(0)
            )
            $result = Predict-Dataset $testVal
        }

        It 'Dataset 2 has 3 values' {
            $expectedVal = 3
            $result[1].Length | Should -Be $expectedVal
        }
        It 'New value for data 2 is 3' {
            $expectedVal = 3
            $result[1][$result[1].Length - 1] | Should -Be $expectedVal
        }

        It 'Dataset 1 has 4 values' {
            $expectedVal = 4
            $result[0].Length | Should -Be $expectedVal
        }
        It 'New value for data 1 is 9' {
            $expectedVal = 9
            $result[0][$result[0].Length - 1] | Should -Be $expectedVal
        }
    }

    Context '2 value dataset (0 3)' {
        BeforeEach {
            $testVal = @(
                @(0, 3),
                @(3)
            )
            $result = Predict-Dataset $testVal
        }

        It 'Dataset 1 has 3 values' {
            $expectedVal = 3
            $result[0].Length | Should -Be $expectedVal
        }
        It 'New value for data 1 is 3' {
            $expectedVal = 3
            $result[0][$result[0].Length - 1] | Should -Be $expectedVal
        }
    }

    Context '1 value dataset (3)' {
        BeforeEach {
            $testVal = @(
                @(3)
            )
            $result = Predict-Dataset $testVal
        }

        It 'Dataset 1 has 1 values' {
            $expectedVal = 1
            $result[0].Length | Should -Be $expectedVal
        }
        It 'New value for data 1 is 3' {
            $expectedVal = 3
            $result[0][$result[0].Length - 1] | Should -Be $expectedVal
        }
    }

    Context '1 value dataset (0)' {
        BeforeEach {
            $testVal = @(
                @(0)
            )
            $result = Predict-Dataset $testVal
        }

        It 'Dataset 1 has 1 values' {
            $expectedVal = 1
            $result[0].Length | Should -Be $expectedVal
        }
        It 'New value for data 1 is 0' {
            $expectedVal = 0
            $result[0][$result[0].Length - 1] | Should -Be $expectedVal
        }
    }

    Context 'from 6 value dataset (10 13 16 21 30 45) calculating the left side' {
        BeforeEach {
            $testVal = @(
                @(10, 13, 16, 21, 30, 40), # 5
                @(3, 3, 5, 9, 15), # 5
                @(0, 2, 4, 6), # -2
                @(2, 2, 2), # 2
                @(0, 0) # 0
            )
            $result = Predict-Dataset $testVal "l"
        }

        It 'Dataset 4 has 4 values' {
            $expectedVal = 4
            $result[3].Length | Should -Be $expectedVal
        }
        It 'New value for dataset 4 is 2' {
            $expectedVal = 2
            $result[3][0] | Should -Be $expectedVal
        }

        It 'Dataset 3 has 5 values' {
            $expectedVal = 5
            $result[2].Length | Should -Be $expectedVal
        }
        It 'New value for dataset 3 is -2' {
            $expectedVal = -2
            $result[2][0] | Should -Be $expectedVal
        }

        It 'Dataset 2 has 6 values' {
            $expectedVal = 6
            $result[1].Length | Should -Be $expectedVal
        }
        It 'New value for dataset 2 is 5' {
            $expectedVal = 5
            $result[1][0] | Should -Be $expectedVal
        }

        It 'Dataset 1 has 7 values' {
            $expectedVal = 7
            $result[0].Length | Should -Be $expectedVal
        }
        It 'New value for dataset 1 is 5' {
            $expectedVal = 5
            $result[0][0] | Should -Be $expectedVal
        }
    }
}