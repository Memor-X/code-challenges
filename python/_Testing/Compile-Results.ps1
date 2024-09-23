# File Imports
. "$($PSScriptRoot)\..\..\Powershell\lib\Common.ps1"

$global:logSetting.showDebug = $true

Write-Log "Compiling Inital Test Result Object"
$durationCol = @()
$testResultsObj = @{
    "system" = @{
        "program" = "minitess"
        "runtime" = "$($testResultsNode.date) $($testResultsNode.time)"
        "language" = "Ruby"
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

Write-Log "Sorting Test Results"
$testHash = @{}
$file = Get-ChildItem -Path "./results/testResults.xml"

[XML]$testResultsXML = Get-Content $file
$testCases = @(Fetch-XMLVal $testResultsXML "testsuites.testsuite.testcase")
#$testedFile = ($testCases[0].classname -split ".describe_")[0]
#$testHash."$($testedFile)" = @{}
foreach($testCase in $testCases)
{
    $classSplit = $testCase.classname -split ".describe_"
    $testedFile, $classSplit = $classSplit
    $testedFile += ".py"
    if($testHash.ContainsKey($testedFile) -eq $false)
    {
        $testHash."$($testedFile)" = @{}
    }
    $testName = $testCase.name
    $classSplit = @($classSplit, $testName)
    Write-Log "Sorting $($testName)"
    $testHash."$($testedFile)" = Initalize-Hash-Branch $testHash."$($testedFile)" $classSplit
    $addedTestCase = @{
        "asserts" = $testCase.assertions
        "executed" = "True"
        "name" = $testName[2]
        "result" = ($null -eq $testCase.failure)
        "time" = [decimal]$testCase.time
        "type" = "test-case"
    }
    #Write-Debug (Gen-Block "addedTestCase Hash" (Gen-Hash-Block $addedTestCase))
    $testHash."$($testedFile)" = Populate-Hash-Branch $testHash."$($testedFile)" $classSplit $addedTestCase
    #Write-Debug (Gen-Block "classplit Array" $classSplit)
    #Write-Debug (Gen-Block "testHash.`"$($testedFile)`" Hash" (Gen-Hash-Block $testHash."$($testedFile)"))
}


function Process-Test-Case($key, $hash)
{
    Write-Log "Processing $($key)"
    $testCase = @{
        "asserts" = "0"
        "executed" = "True"
        "name" = $key
        "result" = "Success"
        "time" = 0.00
        "type" = ""
    }

    if($hash.ContainsKey("type") -eq $true)
    {
        $testCase.type = "test-case"
        $testCase."success" = $hash.result
        if($hash.result -ne "True")
        {
            $testCase."result" = "Failure"
        }
        $testCase.time = $hash.time 
    }
    else
    {
        $testCase.type = "test-suite"
        $testCase."tests" = @()
        foreach($test in $hash.Keys)
        {
            $testCaseAdd = Process-Test-Case $test $hash."$($test)"
            $testCase."tests" += @($testCaseAdd)
            if($testCaseAdd.result -ne "Success")
            {
                $testCase."result" = "Failure"
            }

            $testCase."time" += $testCaseAdd.time
        }
    }
    return $testCase
}

Write-Log "Compiling sorted Test Results"
foreach($key in $testHash.Keys)
{
    Write-Log "Compiling $($key)"
    $testSuite = @{
        "test-case-count" = "0"
        "executed" = "True"
        "file" = $key.Replace(".Test","")
        "test-file" = $key
        "result" = "Success"
        "success" = "True"
        "time" = 0.00
        "test-cases" = @()
    }

    $testCases = @()

    foreach($testName in $testHash."$($key)".Keys)
    {
        Write-Debug "`"$($key)`".`"$($testName)`""
        $testCase = Process-Test-Case $testName $testHash."$($key)"."$($testName)"
        if($testCase.result -ne "Success")
        {
            $testSuite.result = "Failure"
        }

        $testSuite.time += $testCase.time

        $testCases += @($testCase)
    }

    $testSuite."test-cases" = @($testCases)
    $testResultsObj."test-suites" += @($testSuite)
}

Write-Log "Outputting Tests data"
Write-File "$($PSScriptRoot)\results\Compiled-Test_data.js" "var testData = JSON.parse('$(($testResultsObj | ConvertTo-Json -Compress -EscapeHandling 'EscapeHtml' -Depth 100))')"