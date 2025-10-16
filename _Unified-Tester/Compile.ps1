########################################
#
# File Name:	Compile.ps1
# Date Created:	17/09/2024
# Description:	
#	Runs the various Unit Testers and compiles the results into a single one
#
########################################

# File Arguments
param (
    $suite = "*"
    #$suite="C:\_Work\_git\script-library\powershell<|>C:\_Work\_git\script-library\ruby" # Debug
)

# File Imports
. "$($PSScriptRoot)\lib\LocalLib.ps1"
#=======================================

# Global Variables
$global:logSetting.showDebug = $false

#=======================================

Write-Start

# loads xml
$xmlFile = "$($PSScriptRoot)\compile-settings.xml"
[XML]$settings = Get-Content $xmlFile

$testers = @{}
foreach ($testerXML in $settings.settings.unittester)
{
    $tester = @{
        "language" = $testerXML.language
        "tester_loc" = $testerXML.directories.tester
        "results_loc" = $testerXML.directories.results
        "test_key" = $testerXML."testkey"
        "cmd" = $testerXML.command
    }

    # resetting unit test results for unit tester incase if it doesn't run
    Set-Content -Path "$($testerXML.directories.results)\Compiled-Test_data.js" -Value "var testData = JSON.parse('{}')"

    foreach ($ext in $testerXML.extensions.ext)
    {
        Write-Log "Adding tester for $($ext)"
        Write-Debug (Gen-Block "tester Obj" (Gen-Hash-Block $tester))
        $testers."$($ext)" = $tester
    }
}
Write-Log "--------------------"

#------------------------------------------------------------------
function Get-Files($path, $testKey, $ext)
{
    $fileCol = @()
    $filter = "*$($testKey)$($ext)"

    Write-Log "Getting files from $($path) with filter $($filter)"

    $files = Get-ChildItem -Path $path -Filter $filter -Recurse
    foreach ($file in $files)
    {
        Write-Log "`tAdding Test - $($file.FullName)"
        $fileCol += @($file.FullName)
    }
    return $fileCol
}
#------------------------------------------------------------------

Write-Log "Compiling Suite"
$fullSuiteVals = @(
    "*",
    "all",
    "full"
)
$testSuite = @()

if ($fullSuiteVals.Contains($suite) -eq $true)
{
    Write-Log "Collecting all Tests for Suite"

    foreach ($ext in $testers.Keys)
    {
        $testSuite += @((Get-Files ".." $testers."$($ext)"."test_key" $ext))
    }
}
else
{
    Write-Log "Splitting string for Suite"
    $testSplit = $suite.split("<|>")
    foreach ($file in $testSplit)
    {
        if ((Test-Path $file -PathType Leaf) -eq $true)
        {
            Write-Log "Adding Single File - $($file)"
            $testSuite += @($file)
        }
        elseif ((Test-Path $file -PathType Container) -eq $true)
        {
            Write-Log "Adding Folder - $($file)"
            foreach ($ext in $testers.Keys)
            {
                $testSuite += @((Get-Files $file $testers."$($ext)"."test_key" $ext))
            }
        }
        else
        {
            Write-Log "Can not find test file $($file)"
        }
    }
}
Write-Log "--------------------"
#------------------------------------------------------------------

$testfiles = Sort-Filelist($testSuite)

Write-Log "Running Unit Testers"
foreach ($unittestExt in $testers.Keys)
{
    if ($testfiles.ContainsKey($unittestExt))
    {
        Write-Log "Running Unit Tester for $($unittestExt)"
        $files = $testfiles."$($unittestExt)" -join "<|>"
        Run-Command "cd `"$($testers."$($unittestExt)"."tester_loc")`""
        $cmd = "$($testers."$($unittestExt)".cmd.Replace("[FILES]",$files))"
        Run-Command "cmd.exe /c '$($cmd)'"
        #Write-Debug $cmd
    }
}
Write-Log "--------------------"
#------------------------------------------------------------------

Write-Log "Combining Unit Tester Results"
$combinedTestResultObj = @{
    "system" = @{
        "program" = "Unified Tester"
        "runtime" = "$($global:startTime)"
        "language" = ""
        "time" = ""
    }
    "test-results-summary" = @{
        "total" = 0
        "errors" = 0
        "failures" = 0
        "not-run" = 0
        "inconclusive" = 0
        "ignored" = 0
        "skipped" = 0
        "invalid" = 0
    }
    "environment" = @{
        "machine-name" = $env:computername
        "os-version" = (([environment]::OSVersion.Version) -join '.')
        "platform" = $PSVersionTable.Platform
        "nunit-version" = ""
    }
    "test-suites" = @()
}
foreach ($testerXML in $settings.settings.unittester)
{
    Write-Log "Adding $($testerXML.language) Unit Tests to collection"
    $combinedTestResultObj.system.language += "$($testerXML.language)|"

    # loading JSON and stripping Javascript
    $JSONObjStr = Get-Content "$($testerXML.directories.results)\Compiled-Test_data.js"
    $JSONObjStr = $JSONObjStr.Replace("var testData = JSON.parse('", "").Replace("')", "")
    $JSONObj = ConvertFrom-Json -InputObject $JSONObjStr -AsHashtable

    # adding incoming test-suites array to collection
    $combinedTestResultObj."test-suites" += @($JSONObj."test-suites")

    # adding test-results-summary values to collection
    foreach ($totalKey in $JSONObj."test-results-summary".Keys)
    {
        $combinedTestResultObj."test-results-summary"."$($totalKey)" += String-To-Int $JSONObj."test-results-summary"."$($totalKey)"
    }
}

#Run-Command "cd `"$($PSScriptRoot)`""
Write-File "$($PSScriptRoot)\results\Compiled-Test_data.js" "var testData = JSON.parse('$(($combinedTestResultObj | ConvertTo-Json -Compress -EscapeHandling 'EscapeHtml' -Depth 100))')"

Write-Log "Combining Code Coverage Results"
$combinedCoverageObj = @{
    "system" = $combinedTestResultObj.system
    "environment" = $combinedTestResultObj.environment
    "test-suites" = @()
}
foreach ($testerXML in $settings.settings.unittester)
{
    $coverageFile = "$($testerXML.directories.results)\Compiled-Coverage_data.js"
    Write-Log "looking for Code Coverage Support of $($testerXML.language) - $($coverageFile)"
    if ([System.IO.File]::Exists($coverageFile) -eq $true)
    {
        Write-Log "Adding $($testerXML.language) Code Coverage to collection"
        $combinedTestResultObj.system.language += "$($testerXML.language)|"

        # loading JSON and stripping Javascript
        $JSONObjStr = Get-Content $coverageFile
        $JSONObjStr = $JSONObjStr.Replace("var coverageData = JSON.parse('", "").Replace("')", "")
        $JSONObj = ConvertFrom-Json -InputObject $JSONObjStr -AsHashtable

        # adding incoming test-suites array to collection
        $combinedCoverageObj."test-suites" += @($JSONObj."test-suites")
    }

}

Write-File "$($PSScriptRoot)\results\Compiled-Coverage_data.js" "var coverageData = JSON.parse('$(($combinedCoverageObj | ConvertTo-Json -Compress -EscapeHandling 'EscapeHtml' -Depth 100))')"

Write-End
