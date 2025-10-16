@echo off
:init
SET testFiles=%1
SET compileResults=%2

:varcheck
IF [%testFiles%]==[] GOTO default_testFiles
IF [%compileResults%]==[] GOTO default_compileResults
GOTO main

:default_testFiles
SET testFiles="all"
GOTO varcheck

:default_compileResults
SET compileResults="true"
GOTO varcheck

:main
CLS
IF %compileResults%=="true" (
    pwsh ".\Compile.ps1" -suite %testFiles%
)
PAUSE