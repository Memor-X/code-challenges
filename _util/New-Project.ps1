Clear-Host
$data = @{
    "title" = "Median of Two Sorted Arrays"
    "mainfile" = ""

#    "challange" = "advent-of-code"
#    "challange" = "codewars"
    "challange" = "leetcode"

#    "language" = "powershell"
#    "language" = "python"
    "language" = "ruby"

    "aoc-year" = "2023"
}

$paths = @{
    "projectGen" = "C:\_Work\_git\script-library\powershell\Gen Project"
    "dest" = "$($PSScriptRoot)\.."
}
$ext = @{
    "powershell" = "ps1"
    "python" = "py"
    "ruby" = "rb"
}

$projectIds = ConvertFrom-Json -InputObject (Get-Content -Path "project-ids.txt" -Raw)
$dest = "$($paths.dest)\$($data.language)\$($data.challange)"

Write-Host "Code Challange = $($data.challange)"
if($data.challange -eq "advent-of-code")
{
    Write-Host "getting Advent of Code Folders for $($data.'aoc-year')"
    $dest = "$($dest)\$($data.'aoc-year')"
    $folders = Get-ChildItem -Path $dest
    [int]$highestID = 0

    Write-Host "Getting Highest"
    Foreach($folder in $folders)
    {
        $folderSplit = $folder.BaseName -split '-'
        [int]$currID = [int]$folderSplit[0]
        if($currID -ge $highestID)
        {
            $highestID = $currID
        }
    }

    Write-Host "Determining Puzzle No."
    $projectID = '{0:D2}' -f $highestID

    if((Test-Path -Path "$($dest)\$($projectID)-Puzzle1") -eq $true)
    {
        $projectID = '{0:D2}' -f ($highestID+1)
        $dest = $dest = "$($dest)\$($projectID)-Puzzle1"
    }
    else
    {
        $dest = $dest = "$($dest)\$($projectID)-Puzzle2"
    }
}
else
{
    Write-Host "Converting Title to Directory Safe"
    $TextInfo = (Get-Culture).TextInfo
    $data.title = $data.title.Split([IO.Path]::GetInvalidFileNameChars()) -join '-'
    $data.title = $data.title.Replace(" ","-")
    $data.title = $TextInfo.ToTitleCase($data.title)

    if($data.mainfile.Length -lt 1)
    {
        Write-Host "mainfile empty, using title"
        $data.mainfile = $data.title
    }

    Write-Host "generating Folder Path"
    $projectIds."$($data.challange)" += 1
    $projectID = '{0:D3}' -f $projectIds."$($data.challange)"
    $dest = "$($dest)\$($projectID)-$($data.title)"
}

$cmd = "`".\gen-$($data.language)`" `"$($dest)`" `"$($data.mainfile).$($ext."$($data.language)")`" `"folder`""
Write-Host "Command Generated = $($cmd)"
Invoke-Expression -Command "& cd `"$($paths.projectGen)`""
Invoke-Expression -Command "& $($cmd)"
Set-Content -Path "$($PSScriptRoot)\project-ids.txt" -Value (ConvertTo-Json -InputObject $projectIds -Compress)
Invoke-Expression -Command "& cd `"$($PSScriptRoot)`""