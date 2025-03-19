########################################
#
# File Name:	Camel.ps1
# Date Created:	
# Description:	
#	
#
########################################

# File Imports
. "$($PSScriptRoot)\..\..\..\lib\AdventOfCode.ps1"
. "$($PSScriptRoot)\lib\LocalLib.ps1"

# Global Variable Setting
$global:AoC.puzzle = "7-2"
$global:AoC.testInputMode = $false

$global:logSetting.fileOutput = $true
$global:logSetting.showDebug = $false
#=======================================

Write-Start
$data = Load-Input

Write-Log "format input data into hash"
$cardHands = @{}
for($i = 0; $i -lt $data.length; $i++)
{
    $dataSplit = $data[$i] -split ' '
    $cardHands[$dataSplit[0]] = [int]$dataSplit[1]
}

Write-Log "sort hands into hand types"
$hands = @{
    'H' = @()
    '1P' = @()
    '2P' = @()
    '3K' = @()
    'FH' = @()
    '4K' = @()
    '5K' = @()
}
foreach($hand in $cardHands.Keys)
{
    $handType = (Get-Hand-Type (CardStr-to-IntArr $hand))
    Write-Debug "$($hand) = $($handType)"
    $hands[$handType] += @($hand)
}

Write-Debug "unsorted hands"
$hands
Write-Debug "----------------------"

Write-Log "Reorder hands in each type from worst to best"
$handTypes = @($hands.Keys)
foreach($handType in $handTypes)
{
    if($hands[$handType].length -gt 1)
    {
        Write-Debug "Sorting $($handType) (Hand Count = $($hands[$handType].length))"
        $sortedArr = @()
        $unsortedHands = $hands[$handType]
        foreach($hand in $unsortedHands)
        {
            Write-Debug "checking hand $($hand)"
            $handVal = Hand-to-Int $hand
            $sortTerminator = $sortedArr.length
            if($sortedArr.length -lt 1)
            {
                $sortedArr = @($hand)
            }
            else
            {
                Write-Debug "sorting into array of size $($sortedArr.length)"
                for($i = 0; $i -lt $sortTerminator; $i++)
                {
                    if($handVal -lt (Hand-to-Int $sortedArr[$i]))
                    {
                        $sortedArr = Add-Into-Array $sortedArr $hand $i
                        $i = $sortTerminator
                    }
                    Write-Debug $i
                }
            }
            if($sortedArr.length -ne $sortTerminator+1)
            {
                $sortedArr += @($hand)
            }
        }

        $hands[$handType] = $sortedArr
    }
}

Write-Debug "sorted hands"
$hands
Write-Debug "----------------------"

Write-Log "Calculating Winnings"
$winningsOrder = @($hands['H'] + $hands['1P'] + $hands['2P'] + $hands['3K'] + $hands['FH'] + $hands['4K'] + $hands['5K'])

$winningsOrder

$winnings = @()
for($i = 0; $i -lt $winningsOrder.Length; $i += 1)
{
    Write-Debug "Adding $($winningsOrder[$i])'s winnings of $($cardHands[$winningsOrder[$i]]) | multiplayer $($i+1)"
    $winning = $cardHands[$winningsOrder[$i]]*($i+1)
    Write-Debug "Winnings = $($winning)"
    $winnings += @($winning)
}


Get-Answer $winnings

Write-End
