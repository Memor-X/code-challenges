########################################
#
# File Name:	Wasteland.ps1
# Date Created:	24/03/2025
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
$global:AoC.puzzle = "8-2"
$global:AoC.testInputMode = $false

$global:logSetting.fileOutput = $true
$global:logSetting.showDebug = $true
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
    $split = ($split[1].replace("(","").replace(")","")) -split ", "
    $nodes[$nodeKey] = @($split[0], $split[1])
}

Write-Log "Finding initial paths lengths"
$currentNodes = Get-Start-Nodes ($nodes.Keys)
$mults = @()
foreach($startNode in $currentNodes)
{
    Write-Debug "Calculating Path $($startNode)"
    $currentNode = $startNode
    $steps = 0
    $stepPos = 0
    while("$($currentNode[2])" -ne "Z")
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
        #Write-Debug "Stepping $($step) to $($currentNode)"
    }
    Write-Log "Path for start node '$($startNode)' = $($steps)"
    $mults += $($steps)
}

Write-Log "finding common multiple value"
$commSteps = Find-LCM $mults

Get-Answer $commSteps 'static'

Write-End
