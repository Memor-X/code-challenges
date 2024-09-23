########################################
#
# File Name:	Kanri.ps1
# Date Created:	27/09/2023
# Description:	
#	Kanri Kanban Board Task Library
#
########################################

# file imports
. "$($PSScriptRoot)\..\Common.ps1"

$api_data = @{}

########################################
# Custom Functions
########################################

function Get-Board-Pos()
{
    Write-Log "Getting Board"

    $api_data["dataFile"] = Fetch-XMLVal $settings "settings.task_lib_data.dat_loc"
    $api_data["boardTitle"] = Fetch-XMLVal $settings "settings.task_lib_data.board_title"
    $api_data["boardPos"] = 0

    Write-Log "Loading Kanri Data from $($api_data["dataFile"])"
    $jsonObject = Get-Content -Raw $api_data["dataFile"] | ConvertFrom-Json

    Write-Log "Beging Board Loop"
    foreach($board in $jsonObject.boards)
    {
        Write-Debug "Board Title - $($board.title)"
        if($board.title -eq $api_data["boardTitle"])
        {
            Write-Success "Found Board - $($board.title) | Pos = $($api_data["boardPos"])"
            return $true
        }
        $api_data["boardPos"] += 1
    }

    # returns error string to be picked up
    Write-Error "Board not found with ID '$($api_data["boardTitle"])'"
    return $false
}

function Get-Task($id)
{
    $boardPos = Get-Board-Pos

    Write-Log "Getting Task with ID = ${id}"
    $jsonObject = Get-Content -Raw $api_data["dataFile"] | ConvertFrom-Json

    $api_data["colPos"] = 0

    Write-Log "Starting Search Loop"
    foreach($column in $jsonObject.boards[$api_data["boardPos"]].columns)
    {
        $api_data["cardPos"] = 0
        Write-Log "Checking Column - $($column.title)"
        foreach($card in $column.cards)
        {
            Write-Log "Checking Card - $($card.name)"
            $cardID = $card.name -split ' - '
            if($cardID[0] -eq $id)
            {
                Write-Success "Found card - $($card.name) | Pos = $($api_data["colPos"]) / $($api_data["cardPos"] )"
                return $true
            }
            $api_data["cardPos"] += 1
        }
        $api_data["colPos"] += 1
    }

    # returns error string to be picked up
    Write-Error "Card not found with ID '${id}'"
    return $false
}

########################################
# Common Functions
########################################

function Get-Task-Title($id)
{
    Write-Log "Getting Task Title"
    $api_data["task_title"] = "Kanri Task Title"


    return $api_data["task_title"]
}

function Get-Task-Url($id)
{
    Write-Log "Getting Task Title"
    $api_data["task_url"] = "http://www.google.com"


    return $api_data["task_url"]
}

function Add-Comment($id, $comment)
{
    if($id.length -gt 0)
    {
        Write-Log "Writting Comment - ${comment}"

        # fetching task
        $taskFound = Get-Task $id

        Write-Log "generating Comment Line"
        $commentLine = "$(Get-Date -Format "dd/MM/yyyy HH:mm") - [AUTO] ${comment}"
        $jsonObject = Get-Content -Raw $api_data["dataFile"] | ConvertFrom-Json

        $jsonObject.boards[$api_data["boardPos"]].columns[$api_data["colPos"]].cards[$api_data["cardPos"]].description += "`n`n$commentLine"

        Write-Log "Updating Kenri .dat file"
        Write-File $api_data["dataFile"] ($jsonObject| ConvertTo-Json -Depth 100 -Compress)
    }
    else
    {
        Write-Warning "ID is blank, not adding comment"
    }
}