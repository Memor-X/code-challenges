########################################
#
# File Name:	LocalLib.ps1
# Date Created:	03/11/2025
# Description:	
#	Local Functions for Unit Testing
#
########################################

# File Imports
. "$($PSScriptRoot)\..\..\..\..\lib\Common.ps1"
#=======================================

# Global Variables

#=======================================

function Test-Array-Single-Value($arr, $val)
{
    $newArr = $arr | Select-Object -Unique

    if($newArr.length -eq 1)
    {
        if($newArr[0] -eq $val)
        {
            return $true
        }
    }

    return $false
}

function Calculate-Dataset($data)
{
    $splitData = @($data.split(" "))
    $dataSets = New-Object System.Collections.Generic.List[Array]
    $lastIndex = 0
    $datasets.Add(@($splitData))

    if($splitData.Length -gt 1)
    {
        $terminator = $false
        while($terminator -eq $false)
        {
            Write-Log "Working Out Dataset $($lastIndex)"
            $lastSet = @($dataSets[$lastIndex])
            $newSet = @()
            for($i = 0; $i -lt ($lastSet.Length - 1); $i += 1)
            {
                $val = [int]$lastSet[$i + 1] - [int]$lastSet[$i]
                $newSet += @("$($val)")
            }

            $lastIndex += 1
            $dataSets.Add($newSet)

            Write-Log "Testing - $($dataSets[$lastIndex])"
            if($dataSets[$lastIndex].length -lt 2)
            {
                Write-Log "Only 1 value left, terminating loop"
                $terminator = $true
            }
            elseif((Test-Array-Single-Value -arr ($dataSets[$lastIndex]) -val "0") -eq $true)
            {
                Write-Log "Last dataset all 0's, terminating loop"
                $terminator = $true
            }
        }
    }

    return $dataSets
}

function Predict-Dataset($dataset)
{
    if($dataset.Length -gt 1)
    {
        Write-Log "Calculating dataset prediction"
        $dataset[$dataset.Length - 1] += @(0)
        for($i = $dataset.Length - 2; $i -gt -1; $i -= 1)
        {
            Write-Log "Dataset $($i)"
            $curDatasetEnd = $dataset[$i].length - 1
            $nextDatasetEnd = $dataset[$i + 1].length - 1
            $val = [int]$dataset[$i][$curDatasetEnd] + [int]$dataset[$i + 1][$nextDatasetEnd]
            Write-Debug "dataset[$($i)][$($curDatasetEnd)] ($($dataset[$i][$curDatasetEnd])) + dataset[$($i+1)][$($nextDatasetEnd)] ($($dataset[$i+1][$nextDatasetEnd])) = $($val)"
            $dataset[$i] += @($val)
        }
    }
    else
    {
        Write-Warning "Dataset only has 1 value"
    }

    return $dataset
}