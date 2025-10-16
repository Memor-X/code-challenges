########################################
#
# File Name:	XML.ps1
# Date Created:	24/06/2025
# Description:	
#	Function library for functions used for working with XML Files
#
########################################

# File Imports
. "$($PSScriptRoot)\Common.ps1"

# Global Variables

########################################
#
# Name:		Load-XML
# Input:	$file <String>
# Output:	$xmlObj <XML>
# Description:
#	Loads XML into object variable
#
########################################
function Load-XML($file)
{
    Write-Log "Importing XML Data $($file)"
    [XML]$xmlObj = Get-Content -Path $file

    return $xmlObj
}

########################################
#
# Name:		Fetch-XMLVal
# Input:	$iniObj <XML Object>
#			$path <String>
# Output:	$val <Various>
# Description:
#	returns the XML Element specified by the passed dot separated path
#
########################################
function Fetch-XMLVal($xmlObj, $path)
{
    $pathParts = $path.Split(".")
    $val = $xmlObj
    $lv = 0

    foreach ($pathPart in $pathParts)
    {
        Write-Log "Getting Child '$($pathPart)' from Level $($lv)"
        $val = $val.$pathPart
        $lv += 1
    }

    Write-Log "${path}: ${val}"
    return $val
}

########################################
#
# Name:		Load-Formatted-XML
# Input:	$file <String>
#           $mapping <Object>
# Output:	$xmlObj <XML>
# Description:
#	Loads XML into object variable making sure to replace parameterized values in the xml file
#
########################################
function Load-Formatted-XML($file, $mapping)
{
    Write-Log "Importing XML Data $($file)"
    $xmlStr = Get-Content -Path $file
    $xmlStr = Bulk-Replace -string $xmlStr -values $mapping

    [XML]$xmlObj = $xmlStr

    return $xmlObj
}