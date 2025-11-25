########################################
#
# File Name:	Mirage.ps1
# Date Created:	03/11/2025
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
$global:AoC.puzzle = "9-2"
$global:AoC.testInputMode = $false

$global:logSetting.fileOutput = $true
$global:logSetting.showDebug = $true
#=======================================

Write-Start
$data = Load-Input
$predictions = @()

foreach($line in $data)
{
    Write-Log "Processing Line - $($line)"
    $dataset = Calculate-Dataset $line
    $predictedDataset = Predict-Dataset $dataset 'l'
    $predictedVal = $predictedDataset[0][0]
    $predictions += @($predictedVal)
    Write-Log "----------------------------"
}


Get-Answer $predictions 'sum'

Write-End
