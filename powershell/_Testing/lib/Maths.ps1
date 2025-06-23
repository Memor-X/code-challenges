########################################
#
# File Name:	Maths.ps1
# Date Created: 20/02/2024
# Description:
#	Function library for Mathematics functions
#
########################################

# file imports
. "$($PSScriptRoot)\Logging.ps1"

########################################
#
# Name:		Sum
# Input:	$vals <Array>
# Output:	$sum <Integer>
# Description:
#	loops though values in the provided array to determine the sum of all values
#
########################################
function Sum($vals)
{
    $sum = 0
    foreach($val in $vals)
    {
        $sum += $val
    }
    return $sum
}

########################################
#
# Name:		Min
# Input:	$vals <Array>
# Output:	$min <Integer>
# Description:
#	loops though values in the provided array to determine the minimum value
#
########################################
function Min($vals)
{
    $min = $vals[0]
    for($i = 1; $i -lt $vals.length; $i += 1)
    {
        if($vals[$i] -lt $min)
        {
            $min = $vals[$i]
        }
    }
    return $min
}

########################################
#
# Name:		Max
# Input:	$vals <Array>
# Output:	$max <Integer>
# Description:
#	loops though values in the provided array to determine the maximin value
#
########################################
function Max($vals)
{
    $max = $vals[0]
    for($i = 1; $i -lt $vals.length; $i += 1)
    {
        if($vals[$i] -gt $max)
        {
            $max = $vals[$i]
        }
    }
    return $max
}

########################################
#
# Name:		Product
# Input:	$vals <Array>
# Output:	$prod <Integer>
# Description:
#	loops though values in the provided array and multiples each number
#
########################################
function Product($vals)
{
    $prod = [int]$vals[0]
    for($i = 1; $i -lt $vals.length; $i += 1)
    {
        $prod *= [int]$vals[$i]
    }
    return $prod
}

########################################
#
# Name:		Find-LCM
# Input:	$multiples <Array>
# Output:	$returnVal <Integer>
# Description:
#	Finds the Lowest Common Multiple using calls of Find-GCD
#
########################################
function Find-LCM($multiples)
{
    $returnVal = 0

    $sortedMultiples = ($multiples | Sort-Object)

    $gcd = Find-GCD @($sortedMultiples[0], $sortedMultiples[1])
    $lcm = (([int]$sortedMultiples[0] * [int]$sortedMultiples[1])/$gcd)

    for($i = 2; $i -lt $sortedMultiples.length; $i += 1)
    {
        Write-Debug "Getting LCM of $($lcm) and $($sortedMultiples[$i]) (Index $($i))"
        $gcd = Find-GCD @($lcm, $sortedMultiples[$i])
        $lcm = (($lcm * [int]$sortedMultiples[$i])/$gcd)
    }

    $returnVal = $lcm

    return $returnVal
}

########################################
#
# Name:		Find-GCD
# Input:	$numbers <Array>
# Output:	$returnVal <Integer>
# Description:
#	Finds the Greatest Common Divider using the Euclidean algorithm
#
########################################
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

        $largeNum = $smallNum
        $smallNum = $remainder
    }

    $returnVal = $gcd

    return $returnVal
}