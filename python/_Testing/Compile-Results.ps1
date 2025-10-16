# File Imports
. "$($PSScriptRoot)\..\..\Powershell\lib\Common.ps1"
. "$($PSScriptRoot)\..\..\Powershell\lib\XML.ps1"

$global:logSetting.showDebug = $false

Write-Log "Compiling Inital Test Result Object"
$durationCol = @()
$testResultsObj = @{
    "system" = @{
        "program" = "pytest"
        "runtime" = "$($testResultsNode.date) $($testResultsNode.time)"
        "language" = "Python"
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
foreach ($testCase in $testCases)
{
    Write-Log "setting up `"$($testCase.classname)`" for processing"
    $classSplit = $testCase.classname -split ".describe_"
    $testedFile, $classSplit = $classSplit
    $testedFile += ".py"
    if ($testHash.ContainsKey($testedFile) -eq $false)
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

    if ($hash.ContainsKey("type") -eq $true)
    {
        $testCase.type = "test-case"
        $testCase."success" = $hash.result
        if ($hash.result -ne "True")
        {
            $testCase."result" = "Failure"
        }
        $testCase.time = $hash.time 
    }
    else
    {
        $testCase.type = "test-suite"
        $testCase."tests" = @()
        foreach ($test in $hash.Keys)
        {
            $testCaseAdd = Process-Test-Case $test $hash."$($test)"
            $testCase."tests" += @($testCaseAdd)
            if ($testCaseAdd.result -ne "Success")
            {
                $testCase."result" = "Failure"
            }

            $testCase."time" += $testCaseAdd.time
        }
    }
    return $testCase
}

Write-Log "Compiling sorted Test Results"
foreach ($key in $testHash.Keys)
{
    Write-Log "Compiling $($key)"
    $testSuite = @{
        "test-case-count" = "0"
        "executed" = "True"
        "file" = $key.Replace(".Test", "")
        "test-file" = $key
        "result" = "Success"
        "success" = "True"
        "time" = 0.00
        "test-cases" = @()
    }

    $testCases = @()

    foreach ($testName in $testHash."$($key)".Keys)
    {
        Write-Debug "`"$($key)`".`"$($testName)`""
        $testCase = Process-Test-Case $testName $testHash."$($key)"."$($testName)"
        if ($testCase.result -ne "Success")
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

function Get-Coverage($coverageJSON)
{
    $returnArr = @()
    $compileHash = @{}
    $files = ($coverageJSON."files").GetType().GetProperty('Keys').GetValue($coverageJSON."files")

    foreach ($file in $files)
    {
        Write-Debug $file
        $correctedSourceName = "$($file.Replace("\","/"))"

        $compileHash."$($correctedSourceName)" = @{
            "lines" = @()
            "functions" = @()
        }

        Write-Log "Processing Methods"
        $methods = ($coverageJSON."files"."$($file)"."functions").GetType().GetProperty('Keys').GetValue($coverageJSON."files"."$($file)"."functions")
        foreach ($method in $methods)
        {
            $fixMethod = $method
            if ($fixMethod.length -eq "")
            {
                $fixMethod = "<script>"
            }
            Write-Log "Processing $($fixMethod)"
            $allLines = @($coverageJSON."files"."$($file)"."functions"."$($method)"."missing_lines") + @($coverageJSON."files"."$($file)"."functions"."$($method)"."executed_lines") + @($coverageJSON."files"."$($file)"."functions"."$($method)"."excluded_lines")
            $allLines = $allLines | Sort-Object

            $missedLines = $coverageJSON."files"."$($file)"."functions"."$($method)"."missing_lines".length + $coverageJSON."files"."$($file)"."functions"."$($method)"."excluded_lines".length
            $coveredLines = $coverageJSON."files"."$($file)"."functions"."$($method)"."executed_lines".length

            $functionHash = @{
                "name" = "$($fixMethod)"
                "line no" = $allLines[0]
                "lines" = @{
                    "covered" = $coveredLines
                    "missed" = $missedLines
                }
                "methods" = @{
                    "covered" = $coveredLines
                    "missed" = $missedLines
                }
                "instructions" = @{
                    "covered" = $coveredLines
                    "missed" = $missedLines
                }
            }

            $compileHash."$($correctedSourceName)"."functions" += @($functionHash)
        }

        Write-Log "Processing Lines"
        $allLines = @($coverageJSON."files"."$($file)"."missing_lines") + @($coverageJSON."files"."$($file)"."executed_lines") + @($coverageJSON."files"."$($file)"."excluded_lines")
        $allLines = ($allLines | Sort-Object)
        Write-Debug "$($allLines)"
        $lastLine = $allLines[$allLines.length - 1]

        for ($i = 0; $i -lt $lastLine; $i++)
        {
            $linesCovered = 0
            $linesMissed = 0
            $emptyLine = $true
            if ($coverageJSON."files"."$($file)"."executed_lines" -contains ($i + 1))
            {
                Write-Debug "Line $($i + 1) covered"
                $linesCovered = 1
                $emptyLine = $false
            }
            elseif (($coverageJSON."files"."$($file)"."missing_lines" -contains ($i + 1)) -or ($coverageJSON."files"."$($file)"."excluded_lines" -contains ($i + 1)))
            {
                Write-Debug "Line $($i + 1) missed"
                $linesMissed = 1
                $emptyLine = $false
            }

            if ($linesCovered -ge 0 -and $linesMissed -ge 0)
            {
                $lineData = @{
                    "line number" = $i + 1
                    "instructions" = @{
                        "missed" = $linesMissed
                        "covered" = $linesCovered
                    }
                    "branches" = @{
                        "missed" = 0
                        "covered" = 0
                    }
                }

                $compileHash."$($correctedSourceName)"."lines" += @($lineData)
            }
            else
            {
                Write-Warning "Line $($i + 1) not scanned"
            }
        }
    }

    foreach ($result in $compileHash.GetEnumerator())
    {
        $returnArr += @(@{
                "name" = $result.Name
                "lines" = $result.Value.lines
                "functions" = $result.Value.functions
            })
    }

    return $returnArr
}

Write-Log "Getting Code Coverage Data"
$coverage = "$($PSScriptRoot)\results\coverage.json"
$coverageJSON = ConvertFrom-Json $(Get-Content $coverage -Raw) -AsHashtable
$coverageObj = @{
    "system" = $testResultsObj.system
    "environment" = $testResultsObj.environment
}
$coverageObj."test-suites" = @(Get-Coverage $coverageJSON)
Write-File "$($PSScriptRoot)\results\Compiled-Coverage_data.js" "var coverageData = JSON.parse('$(($coverageObj | ConvertTo-Json -Compress -EscapeHandling 'EscapeHtml' -Depth 100))')"

