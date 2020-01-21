@echo off

SET APP=pianism
SET basedir=%~dp0
SET curdir=%CD%
SET srcdir=%basedir%\src\
SET outdir=%basedir%\out\
SET bindir=%basedir%\bin\

REM go to src dir
CD /D %srcdir%

REM parse asm app to obj
"%bindir%\nasm.exe" -f win32 "%srcdir%\%APP%.asm" -o "%outdir%\%APP%.obj"

IF EXIST "%outdir%\%APP%.obj" (
	
	REM link dependecies to app
	"%bindir%\GoLink.exe" /console /entry _start /ni "%outdir%\%APP%.obj" "%bindir%\libw.obj" kernel32.dll ucrtbase.dll 

	REM [UN]COMMENT TO delete .obj file
	DEL "%outdir%\%APP%.obj"

	REM run the app
	"%outdir%\%APP%.exe"
	
	REM [UN]COMMENT TO delete exe file
	REM DEL "%outdir%\%APP%.exe"
)

REM back to caller dir
CD /D %curdir%

