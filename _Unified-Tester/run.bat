@echo off
:init
SET testFiles=%1

:varcheck
IF [%testFiles%]==[] GOTO default_testFiles
GOTO main

:default_testFiles
SET testFiles="all"
GOTO varcheck

:main
CLS
pwsh ".\Compile.ps1" -suite %testFiles%
IF %compileResults%=="true" (
    compile.bat
)
PAUSE


CLS

PAUSE
