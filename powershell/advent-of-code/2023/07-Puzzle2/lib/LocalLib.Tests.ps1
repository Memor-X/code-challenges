BeforeAll {
    # Dynamic Link to file to test
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
   <#  Mock Write-Host {
        $outputBuffer."screen" += @(@{
            "msg" = (Out-String -InputObject $PesterBoundParameters.Object).Trim()
            "color" = (Out-String -InputObject $PesterBoundParameters.ForegroundColor).Trim()
        })
    } #>
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
                $returnVal = New-Object DateTime 2000, 1, 1, 11, 10, 0
                break
            }
        }
        return $returnVal
    }
}

# Tests
Describe 'Get-Card-Int' {
    BeforeEach {
            $global:outputBuffer = @{}
            $outputBuffer."screen" = @()
        }

    It 'Card <card> should be of value <cardInt>' -TestCases @(
        @{card = 'J'; cardInt = 1;}
        @{card = 'Q'; cardInt = 12;}
        @{card = 'K'; cardInt = 13;}
        @{card = 'A'; cardInt = 14;}
        @{card = 'T'; cardInt = 10;}
        @{card = '6'; cardInt = 6;}
        @{card = '2'; cardInt = 2;}
    ){
        $rtnData = (Get-Card-Int $card)
        Write-Debug $rtnData.GetType()
        $rtnData | Should -be $cardInt
    }
}

Describe 'CardStr-to-IntArr' {
    BeforeEach {
            $global:outputBuffer = @{}
            $outputBuffer."screen" = @()
        }

    It 'String of <cards> should be of length <cardArrSize>' -TestCases @(
        @{cards = '23456'; cardArrSize = 5;}
        @{cards = '22334'; cardArrSize = 5;}
        @{cards = 'K2587'; cardArrSize = 5;}
        @{cards = '5'; cardArrSize = 1;}
        @{cards = '22222'; cardArrSize = 5;}
    ){
        $rtnData = (CardStr-to-IntArr $cards)
        $rtnData.count | Should -be $cardArrSize
    }

    It 'String of <cards> should be of <cardArrStr>' -TestCases @(
        @{cards = '23456'; cardArr = @(2,3,4,5,6); cardArrStr = '2,3,4,5,6'}
        @{cards = '22334'; cardArr = @(2,2,3,3,4); cardArrStr = '2,2,3,3,4'}
        @{cards = 'K2587'; cardArr = @(13,2,5,8,7); cardArrStr = '13,2,5,8,7'}
        @{cards = '5'; cardArr = @(5); cardArrStr = '5'}
        @{cards = '22222'; cardArr = @(2,2,2,2,2); cardArrStr = '2,2,2,2,2'}
    ){
        $rtnData = (CardStr-to-IntArr $cards)
        for($i = 0; $i -lt $cardArr.length; $i += 1)
        {
            Write-Debug "rtnData[$($i)] $($rtnData[$i].GetType())"
            Write-Debug "cardArr[$($i)] $($cardArr[$i].GetType())"
            $rtnData[$i] | Should -be $cardArr[$i]
        }
    }
}

Describe 'Get-Hand-Type' {
    BeforeEach {
            $global:outputBuffer = @{}
            $outputBuffer."screen" = @()
        }

    It 'String of <cards> should be be of hand type <handStr> (<handCode>)' -TestCases @(
        @{cards = '23465'; handCode = 'H'; handStr = 'High Card';}
        @{cards = '22456'; handCode = '1P'; handStr = 'One Pair';}
        @{cards = '22446'; handCode = '2P'; handStr = 'Two Pair';}
        @{cards = '23336'; handCode = '3K'; handStr = 'Three of a Kind';}
        @{cards = '22333'; handCode = 'FH'; handStr = 'Full House';}
        @{cards = '44445'; handCode = '4K'; handStr = 'Four of a Kind';}
        @{cards = '23256'; handCode = '1P'; handStr = 'One Pair';}
        @{cards = '64246'; handCode = '2P'; handStr = 'Two Pair';}
        @{cards = '23252'; handCode = '3K'; handStr = 'Three of a Kind';}
        @{cards = '23323'; handCode = 'FH'; handStr = 'Full House';}
        @{cards = '44544'; handCode = '4K'; handStr = 'Four of a Kind';}
        @{cards = '55555'; handCode = '5K'; handStr = 'Five of a Kind';}

        @{cards = 'KTJJT'; handCode = '4K'; handStr = 'Four of a Kind';}

        @{cards = '2J456'; handCode = '1P'; handStr = 'One Pair';}
        @{cards = '282J5'; handCode = '3K'; handStr = 'Three of a Kind';}
        @{cards = '23J36'; handCode = '3K'; handStr = 'Three of a Kind';}
        @{cards = '2233J'; handCode = 'FH'; handStr = 'Full House';}
        @{cards = '444J5'; handCode = '4K'; handStr = 'Four of a Kind';}
        @{cards = '5J555'; handCode = '5K'; handStr = 'Five of a Kind';}
        @{cards = '5J5J5'; handCode = '5K'; handStr = 'Five of a Kind';}
        @{cards = 'JJJJJ'; handCode = '5K'; handStr = 'Five of a Kind';}
    ){
        $cardArr = CardStr-to-IntArr $cards
        $rtnData = (Get-Hand-Type $cardArr)
        $rtnData | Should -be $handCode
    }
}

Describe 'Hand-to-Int' {
    BeforeEach {
            $global:outputBuffer = @{}
            $outputBuffer."screen" = @()
        }

    It 'Hand of <hand> should be be of value <handVal>' -TestCases @(
        @{hand = '22222'; handVal = 202020202;}
        @{hand = 'K2222'; handVal = 1302020202;}
        @{hand = '22QQ2'; handVal = 202121202;}
        @{hand = 'T2QQ2'; handVal = 1002121202;}
    ){
        $rtnData = (Hand-to-Int $hand)
        $rtnData | Should -be $handVal
    }
}