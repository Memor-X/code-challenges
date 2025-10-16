########################################
#
# File Name:	Test.ps1
# Date Created:	26/09/2023
# Description:	
#	Test Task Library that forces Debug messages
#
########################################

# file imports
. "$($PSScriptRoot)\..\Common.ps1"

$api_data = @{}

########################################
# Custom Functions
########################################

########################################
# Common Functions
########################################

function Get-Task-Title($id)
{
    $retainedDebugSetting = $global:logSetting.showDebug
    $global:logSetting.showDebug = $true
    Write-Debug "Debug Logging forced on"

    $msg_block = @(
        "id = ${id}"
    )
    #Gen-Block "Arguments", $msg_block

    $api_data."task_title" = "Test Task Title"
    Write-Debug "Getting Task Title. Value: $($api_data."task_title")"

    Write-Debug "Restoring Debugging Setting"
    $global:logSetting.showDebug = $retainedDebugSetting

    return $api_data."task_title"
}

function Get-Task-Url($id)
{
    $retainedDebugSetting = $global:logSetting.showDebug
    $global:logSetting.showDebug = $true
    Write-Debug "Debug Logging forced on"

    $msg_block = @(
        "id = ${id}"
    )
    Gen-Block "Arguments", $msg_block

    $api_data["task_url"] = "http://www.google.com"
    Write-Debug "Getting Task Title. Value: $($api_data["task_url"])"

    Write-Debug "Restoring Debugging Setting"
    $global:logSetting.showDebug = $retainedDebugSetting

    return $api_data["task_url"]
}

function Add-Comment($id,$comment)
{
    $retainedDebugSetting = $global:logSetting.showDebug
    $global:logSetting.showDebug = $true
    Write-Debug "Debug Logging forced on"

    $msg_block = @(
        "id = ${id}",
        "comment = ${comment}"
    )
    Gen-Block "Arguments", $msg_block

    if($id.length -gt 0)
    {
        Write-Debug "Writting Comment: ${comment}"
    }
    else
    {
        Write-Debug "ID is blank, not adding comment"
    }

    Write-Debug "Restoring Debugging Setting"
    $global:logSetting.showDebug = $retainedDebugSetting
}