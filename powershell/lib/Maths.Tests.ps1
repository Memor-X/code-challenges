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

Describe 'Sum' {
    It "Summing '<nums>' should be <val>" -TestCases @(
        @{nums = @(5); val = 5;}
        @{nums = @(5, 6); val = 11;}
        @{nums = @(1,2,3,4,5,6,7,8,9,10); val = 55;}
    ){
        Sum $nums | Should -Be $val
    }

    Context "Other Datatypes" {
        Context "String" {
            It 'Summing 2 string numbers' {
                $nums = @("5", "6")
                Sum $nums | Should -Be 11
            }
        }
    }
}

Describe 'Min' {
    It "Min of '<nums>' should be <val>" -TestCases @(
        @{nums = @(5); val = 5;}
        @{nums = @(5, 6); val = 5;}
        @{nums = @(5,6,7,1,2,3,4,8,9,10); val = 1;}
    ){
        Min $nums | Should -Be $val
    }

    Context "Other Datatypes" {
        Context "String" {
            It 'Getting Min from 2 string numbers' {
                $nums = @("5", "6")
                Min $nums | Should -Be 5
            }
        }
    }
}

Describe 'Max' {
    It "Max of '<nums>' should be <val>" -TestCases @(
        @{nums = @(5); val = 5;}
        @{nums = @(5, 6); val = 6;}
        @{nums = @(5,6,8,9,10,7,1,2,3,4); val = 10;}
    ){
        Max $nums | Should -Be $val
    }

    Context "Other Datatypes" {
        Context "String" {
            It 'Getting Max from 2 string numbers' {
                $nums = @("5", "6")
                Max $nums | Should -Be 6
            }
        }
    }
}

Describe 'Product (Multiplication)' {
    It "Prodding '<nums>' should be <val>" -TestCases @(
        @{nums = @(5); val = 5;}
        @{nums = @(5, 6); val = 30;}
        @{nums = @(1,2,3,4,5,6,7,8,9,10); val = 3628800;}
    ){
        Product $nums | Should -Be $val
    }

    Context "Prodding with 0 should always be 0" {
        It "Prodding '<nums>'" -TestCases @(
            @{nums = @(0);}
            @{nums = @(5, 0);}
            @{nums = @(1,2,3,4,5,0,7,8,9,10);}
        ){
            Product $nums | Should -Be 0
        }
    }

    Context "Other Datatypes" {
        Context "String" {
            It 'Multiplying 2 string numbers' {
                $nums = @("5", "6")
                Product $nums | Should -Be 30
            }

            It 'Multiplying 5 string numbers' {
                $nums = @("5", "6", "7", "8", "9")
                Product $nums | Should -Be 15120
            }
        }
    }
}

Describe 'Find-GCD' {
    BeforeEach {
            $global:outputBuffer = @{}
            $outputBuffer."screen" = @()
        }

    It "Greatest Common Divisors for '<nums>' should be <val>" -TestCases @(
        @{nums = @(48, 84); val = 12;}
        @{nums = @(16, 5); val = 1;}
        @{nums = @(8946, 2548); val = 14;}
    ){
        $rtnData = Find-GCD $nums
        $rtnData | Should -be $val
    }

    Context "Other Datatypes" {
        Context "String" {
            It "Greatest Common Divisors for string array '48, 84' should be 12" {
                $nums = @('48', '84')
                $val = 12
                $rtnData = Find-GCD $nums
                $rtnData | Should -be $val
            }
        }
    }
}

Describe 'Find-LCM' {
    BeforeEach {
            $global:outputBuffer = @{}
            $outputBuffer."screen" = @()
        }

    It "Lowest Common Multiple for '<mults>' should be <val>" -TestCases @(
        @{mults = @(1,2,3,4,5); val = 60;}
        @{mults = @(6,12,84,23,7); val = 1932;}
        @{mults = @(312,84,786,48,925); val = 529292400;}
    ){
        $rtnData = Find-LCM $mults
        $rtnData | Should -be $val
    }

    Context "Other Datatypes" {
        Context "String" {
            It "Least Common Multiple for string array '312, 84, 786, 48,9 25' should be 12" {
                $nums = @('312','84','786','48','925');
                $val = 529292400
                $rtnData = Find-LCM $nums
                $rtnData | Should -be $val
            }
        }
    }
}