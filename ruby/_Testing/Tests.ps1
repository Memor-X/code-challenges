########################################
#
# File Name:	Tests.ps1
# Date Created:	27/08/2024
# Description:	
#	Test Runner for pytest Ruby Unit Tests
#
########################################

# File Arguments
param (
    $suite = "*"
)

function Write-Test-Log($str)
{
    Write-Host "$($str)" -Foregroundcolor Magenta
}

#------------------------------------------------------------------
Write-Test-Log "Setting Up minitest and simplecov"

$coveragePercentTarget = 90

#------------------------------------------------------------------

Write-Test-Log "Compiling Suite"
$fullSuiteVals = @(
    "*",
    "all",
    "full"
)
$testSuite = @()

if ($fullSuiteVals.Contains($suite) -eq $true)
{
    Write-Test-Log "Collecting all Tests for Suite"
    $files = Get-ChildItem -Path ".." -Filter "*.Tests.rb" -Recurse
    foreach ($file in $files)
    {
        Write-Test-Log "`tAdding Test - $($file.FullName)"
        $testSuite += @($file.FullName)
    }
}
else
{
    Write-Test-Log "Splitting string for Suite"
    $testSplit = $suite.split("<|>")
    foreach ($file in $testSplit)
    {
        if ((Test-Path $file -PathType Leaf) -eq $true)
        {
            Write-Test-Log "Adding Single File - $($file)"
            $testSuite += @($file)
        }
        elseif ((Test-Path $file -PathType Container) -eq $true)
        {
            Write-Test-Log "Adding Folder - $($file)"
            $files = Get-ChildItem -Path $file -Filter "*.Tests.rb" -Recurse
            foreach ($subfile in $files)
            {
                Write-Test-Log "`tAdding Test from folder Folder - $($subfile.FullName)"
                $testSuite += @($subfile.FullName)
            }
        }
        else
        {
            Write-Test-Log "Can not find test file $($file)"
        }
    }
}


Write-Test-Log ""

Write-Test-Log "Clearing previous results"
Remove-Item -Path "results\*testResults.xml"

Write-Test-Log "populating test suite file"
$fileList = ""
for ($i = 0; $i -lt $testSuite.Length; $i++)
{
    $file = (Split-Path $testSuite[$i] -leaf).split(".")[0]
    $fileList += "require '$($testSuite[$i])'`n"
}
$testsuiteFile = "$($PSScriptRoot)\test-files.suite.rb"
Set-Content -Path $testsuiteFile -Value  $fileList 

$cmd = "ruby -Ilib:test `"testRunner.rb`" --verbose --junit --junit-filename=`"results\Suite-testResults.xml`""
Write-Test-Log "Command = $($cmd)"
Invoke-Expression -Command "& $($cmd)"