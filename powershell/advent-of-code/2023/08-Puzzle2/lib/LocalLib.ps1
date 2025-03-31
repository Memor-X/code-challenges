########################################
#
# File Name:	LocalLib.ps1
# Date Created:	21/03/2025
# Description:	
#	Local Functions for Unit Testing
#
########################################

# File Imports
. "$($PSScriptRoot)\..\..\..\..\lib\Common.ps1"
#=======================================

# Global Variables

#=======================================
function Test-End-Nodes($nodes)
{
    $zNodes = 0
    $expectedCount = $nodes.length
    $rtnVal = $false
    foreach($node in $nodes)
    {
        if("$($node[$node.length-1])" -eq "Z")
        {
            $zNodes += 1
        }
    }

    if($zNodes -eq $expectedCount)
    {
        $rtnVal = $true
    }

    return $rtnVal
}

function Get-Start-Nodes($nodes)
{
    $rtnVal = @()
    foreach($node in $nodes)
    {
        if("$($node[$node.length-1])" -eq "A")
        {
            $rtnVal += @($node)
        }
    }

    return $rtnVal
}

function Find-LCM($multiples)
{
    $returnVal = 0

    $sortedMults = ($multiples | Sort-Object)

    $gcd = Find-GCD @($sortedMults[0], $sortedMults[1])
    $lcm = (($sortedMults[0] * $sortedMults[1])/$gcd)

    for($i = 2; $i -lt $sortedMults.length; $i += 1)
    {
        Write-Debug "Getting LCM of $($lcm) and $($sortedMults[$i]) (Index $($i))"
        $gcd = Find-GCD @($lcm, $sortedMults[$i])
        $lcm = (($lcm * $sortedMults[$i])/$gcd)
    }

    $returnVal = $lcm

    return $returnVal
}

function Find-GCD($numbers)
{
    $returnVal = 0

    $sortedDividers = ($numbers | Sort-Object)
    $gcd = 0
    $remainder = $sortedDividers[1]
    $largeNum = $sortedDividers[1]
    $smallNum = $sortedDividers[0]

    while($remainder -gt 0)
    {
        $gcd = $smallNum
        $remainder = $largeNum % $smallNum
        $answer = ($largeNum - $remainder) / $smallNum
        Write-Debug "$($largeNum) / $($smallNum) = $($answer) R $($remainder) (GCD = $($gcd))"

        $largeNum = $smallNum
        $smallNum = $remainder
    }

    $returnVal = $gcd

   <#  $sortedDividers = ($numbers | Sort-Object)
    $dividersGreater = Find-Dividers $sortedDividers[1]
    $dividersSmaller = Find-Dividers $sortedDividers[0]

    foreach($divider in $dividersGreater)
    {
        if($dividersSmaller-contains $divider)
        {
            $returnVal = $divider
        }
    } #>

    return $returnVal
}

function Find-Dividers($number)
{
    $dividers = @(1, $number)
    for($i = 2; $i -lt (($number / 2)+1); $i++)
    {
        if (($number / $i).GetType() -ne  [System.Double])
        {
            $dividers += @($i)
        }
    }

    $dividers = ($dividers | Sort-Object)
    return $dividers
}