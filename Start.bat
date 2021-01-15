@echo off
set "ThisDir=%~dp0"
set "ThisDir=%ThisDir:~0,-1%"
set "ScriptName=%~n0.bat"
pushd "%ThisDir%"
for %%* in (.) do (set "UpperDir=%%~nx*")
title Installing %UpperDir%

if %processor_architecture% == x86 (set "FileName=nircmd.exe") && (set "exist=yes")
if %processor_architecture% == AMD64 (set "FileName=nircmd_x64.exe") && (set "exist=yes")
if not defined exist (
	echo Error: No detected processor architecture. Software not installed.
	pause
	exit
)

"%ThisDir%\Bin\Tools\%FileName%" elevatecmd exec hide "%ThisDir%\Bin\Run.cmd"

exit