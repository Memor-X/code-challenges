$packageDir = "C:\_Work\_Packages"
$packages = @{
    "Unified-Tester" = @{
        "version" = "1.0.0"
        "loc" = "$($PSScriptRoot)\..\_Unified-Tester"
    }
    "Unit-Test-Display" = @{
        "version" = "1.0.2"
        "loc" = "$($PSScriptRoot)\..\_Unified-Tester"
    }
}

foreach($package in $packages.Keys)
{
    Write-Host "Updating $($package) with version $($packages."$($package)".version)"
    $PKGname = "$($package)-$($packages."$($package)".version).zip"
    $PKGsrc = "$($packageDir)\$($PKGname)"
    $PKGdest = "$($packages."$($package)".loc)"
    Expand-Archive -Path $PKGsrc -DestinationPath $PKGdest
}
