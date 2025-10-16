$externalLibs = @{
    "..\lib\LocalLib.ps1" = @{
        "`$(`$PSScriptRoot)\..\..\lib\Common.ps1" = "`$(`$PSScriptRoot)\lib\Common.ps1"
    }
}

foreach($library in $externalLibs.GetEnumerator())
{
    $libraryFile = "$($PSScriptRoot)\$($library.Name)"
    Write-Host "Updating $($libraryFile)"
    $libraryFileData = Get-Content $libraryFile -Raw
    Write-Host $libraryFileData 
    foreach($val in $library.Value.GetEnumerator())
    {
        Write-Host "Replacing '$($val.Name)' with '$($val.Value)'"
        $libraryFileData = $libraryFileData.Replace($val.Name,$val.Value)
    }

    Set-Content -Path $libraryFile -Value $libraryFileData
}