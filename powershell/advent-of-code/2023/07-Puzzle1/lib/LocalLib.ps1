########################################
#
# File Name:	LocalLib.ps1
# Date Created:
# Description:
#	Local Functions for Unit Testing
#
########################################

# File Imports
. "$($PSScriptRoot)\..\..\..\..\lib\Common.ps1"
#=======================================

# Global Variables

function Get-Card-Int($card)
{
    [int]$cardVal = 0
    switch($card)
    {
        "T"
        {
            $cardVal = 10
            break
        }

        "J"
        {
            $cardVal = 11
            break
        }

        "Q"
        {
            $cardVal = 12
            break
        }

        "K"
        {
            $cardVal = 13
            break
        }

        "A"
        {
            $cardVal = 14
            break
        }

        default
        {
            $cardVal = [int]$card
            break
        }
    }

    return $cardVal
}

function CardStr-to-IntArr($cardStr)
{
    $cardArr = @()
    for($i = 0; $i -lt $cardStr.length; $i++)
    {
        $card = Get-Card-Int "$($cardStr[$i])"
        $cardArr += @($card)
    }

    return $cardArr
}

function Get-Hand-Type($cardArr)
{
    $handType = "H"
    $uniqCards = ($cardArr | Sort-Object | Get-Unique)
    $grouping = ($cardArr | Group-Object | ForEach-Object { $h = @{} } { $h[$_.Name] = $_.Count } { $h })

    switch($uniqCards.count)
    {
        1
        {
            $handType = "5K"
            break
        }

        2
        {
            $cardsCounts = @($grouping."$($uniqCards[0])", $grouping."$($uniqCards[1])")

            if($cardsCounts.Contains(4))
            {
                $handType = "4K"
            }
            else
            {
                $handType = "FH"
            }
            break
        }

        3
        {
            $cardsCounts = @($grouping."$($uniqCards[0])", $grouping."$($uniqCards[1])", $grouping."$($uniqCards[2])")

            if($cardsCounts.Contains(3))
            {
                $handType = "3K"
            }
            else
            {
                $handType = "2P"
            }
            break
        }

        4
        {
            $handType = "1P"
            break
        }
    }

    return $handType
}

function Hand-to-Int($hand)
{
    $handIntArr = CardStr-to-IntArr $hand
    #Write-Debug $hand
    #Write-Debug $handIntArr

    $handIntStr = ''
    foreach($card in $handIntArr)
    {
        $cardIntStr = "$('{0:d2}' -f $card)"
        $handIntStr += "$($cardIntStr)"
        #Write-Debug "Card '$($card)' = $($cardIntStr)"
    }

    [int]$handInt = $handIntStr
    return $handInt
}

#=======================================
