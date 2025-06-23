########################################
#
# File Name:	LocalLib.ps1
# Date Created:	17/09/2024
# Description:	
#	Local Functions for Unit Testing
#
########################################

# File Imports
. "$($PSScriptRoot)\Common.ps1"
#=======================================

# Global Variables

#=======================================

########################################
#
# Name:		Sort-Filelist
# Input:	$filelist <Array>
# Output:	$sortedFiles <Hash>
# Description:	
#	Sorts the passed file list into a hash object of arrays with the keys being the extensions of the files
#
########################################
function Sort-Filelist($filelist)
{
    $sortedFiles = @{}

    foreach ($file in $filelist)
    {
        $ext = [IO.Path]::GetExtension($file)
        if ($sortedFiles.ContainsKey($ext) -eq $false)
        {
            $sortedFiles."$($ext)" = @()
        }

        $sortedFiles."$($ext)" += @($file)
    }

    return $sortedFiles
}

