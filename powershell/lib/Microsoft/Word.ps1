########################################
#
# File Name:	Word.ps1
# Date Created:	09/04/2024
# Description:	
#	Function library for Miscoroft Word functionality
#
########################################

# file imports
. "$($PSScriptRoot)\..\Common.ps1"

# Global Variables
if($null -eq $global:document)
{
    $global:document = $false
}

########################################
#
# Name:		Get-Sentance-Block
# Input:	$sentances <DataType>
#           $header <String>
#           $otherHeaders <Array>
#           $pruneEmptyLines <Boolean> [Optional: false]
# Output:	$returnStr <String>
# Description:	
#	Gets Sentances starting after $header
#
########################################
function Get-Sentance-Block($sentances, $header, $otherHeaders, $pruneEmptyLines=$false)
{
    Write-Log "Collecting Sentance Block"
    $returnStr = ""
    $addMode = $false

    foreach($sentance in $sentances)
    {
        $repairedSentance = Repair-Trim $sentance.Text.Trim()
        Write-Debug "Checking Sentance - $($repairedSentance)"
        if($repairedSentance -eq $header)
        {
            Write-Log "Add mode activated"
            $addMode = $true
        }
        else
        {
            if($addMode -eq $true -and $otherHeaders.Contains($repairedSentance))
            {
                Write-Log "Add mode deactivated"
                $addMode = $false
                break
            }
        }

        if($addMode -eq $true -and $otherHeaders.Contains($repairedSentance) -eq $false)
        {
            if($pruneEmptyLines -eq $false -or ($pruneEmptyLines -eq $true -and $repairedSentance.Length -gt 0))
            {
                Write-Log "Adding '$($repairedSentance)'"
                $returnStr += "$($repairedSentance)`n"
            }
        }
    }

    return $returnStr
}