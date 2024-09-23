@echo off
:init
SET testFiles=%1
SET compileResults=%2
SET unitester=%3
GOTO varcheck

:varcheck
IF [%testFiles%]==[] GOTO default_testFiles
IF [%compileResults%]==[] GOTO default_compileResults
IF [%unitester%]==[] GOTO default_unitester
GOTO main

:default_testFiles
SET testFiles="all"
GOTO varcheck

:default_compileResults
SET compileResults="true"
GOTO varcheck

:default_unitester
SET unitester="false"
GOTO varcheck

:main
IF %unitester%=="false" (
    CLS
)
pwsh ".\Tests.ps1" -suite %testFiles%
IF %compileResults%=="true" (
    compile.bat
)
IF %unitester%=="false" (
    PAUSE
)