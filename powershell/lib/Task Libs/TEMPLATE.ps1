########################################
#
# File Name:	
# Date Created:	
# Description:	
#	
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
    Write-Log "Getting Task Title"
    $api_data["task_title"] = "NA Task Title"


    return $api_data["task_title"]
}

function Get-Task-Url($id)
{
    Write-Log "Getting Task Title"
    $api_data["task_url"] = "http://www.google.com"


    return $api_data["task_url"]
}

function Add-Comment($id,$comment)
{
    if($id.length -gt 0)
    {
        Write-Log "Writting Comment - ${comment}"
    }
    else
    {
        Write-Warning "ID is blank, not adding comment"
    }
}