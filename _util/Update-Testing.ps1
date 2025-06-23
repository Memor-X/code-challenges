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

    "Powershell-Tester" = @{
        "version" = "1.0.3"
        "loc" = "$($PSScriptRoot)\..\powershell\_Testing"
    }
    "Ruby-Tester" = @{
        "version" = "1.0.1"
        "loc" = "$($PSScriptRoot)\..\ruby\_Testing"
    }
    "Python-Tester" = @{
        "version" = "1.0.1"
        "loc" = "$($PSScriptRoot)\..\python\_Testing"
    }
}

foreach ($package in $packages.Keys)
{
    Write-Host "Updating $($package) with version $($packages."$($package)".version)"
    $PKGname = "$($package)-$($packages."$($package)".version).zip"
    $PKGsrc = "$($packageDir)\$($PKGname)"
    $PKGdest = "$($packages."$($package)".loc)"
    Expand-Archive -Path $PKGsrc -DestinationPath $PKGdest -Force
    Write-Host "------------------------------------"
}

Write-Host "Copying compile-settings.xml"
Copy-Item  -Path "$($PSScriptRoot)\compile-settings.xml" -Destination "$($packages."Unified-Tester".loc)" -force