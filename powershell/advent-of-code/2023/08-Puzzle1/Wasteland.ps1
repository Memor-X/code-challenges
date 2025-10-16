########################################
#
# File Name:	Wasteland.ps1
# Date Created:	21/03/2025
# Description:
#
#
########################################

# File Imports
. "$($PSScriptRoot)\..\..\..\lib\AdventOfCode.ps1"
. "$($PSScriptRoot)\lib\LocalLib.ps1"
#=======================================

# Global Variables

# Global Variable Setting
$global:AoC.puzzle = "8-1"
$global:AoC.testInputMode = $false

$global:logSetting.fileOutput = $true
$global:logSetting.showDebug = $false
#=======================================

Write-Start
$data = Load-Input

Write-Log "Formatting Data"
$path = $data[0]
$nodes = @{}

for($i = 2; $i -lt $data.length; $i += 1)
{
    $split = $data[$i] -split " = "
    $nodeKey = $split[0]
    $split = ($split[1].replace("(", "").replace(")", "")) -split ", "
    $nodes[$nodeKey] = @($split[0], $split[1])
}

Write-Log "Beginning Pathing"
$steps = 0
$stepPos = 0
$currentNode = "AAA"
while($currentNode -ne "ZZZ")
{
    if($stepPos -ge $path.length)
    {
        $stepPos = 0
    }
    $step = $path[$stepPos]

    $dir = 0
    if($step -eq "R")
    {
        $dir = 1
    }
    $steps += 1
    $stepPos += 1
    $currentNode = $nodes[$currentNode][$dir]
    Write-Debug "Stepping $($step) to $($currentNode)"
}

Get-Answer $steps 'static'

Write-End
