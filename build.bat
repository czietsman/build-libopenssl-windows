@echo off
setlocal EnableDelayedExpansion 

set PROGFILES=%ProgramFiles%
if not "%ProgramFiles(x86)%" == "" set PROGFILES=%ProgramFiles(x86)%

REM Check if Visual Studio 2013 is installed
set MSVCDIR="%PROGFILES%\Microsoft Visual Studio 12.0"
if exist %MSVCDIR% (
    set COMPILER_VER="2013"
	goto begin
)

REM Check if Visual Studio 2012 is installed
set MSVCDIR="%PROGFILES%\Microsoft Visual Studio 11.0"
if exist %MSVCDIR% (
    set COMPILER_VER="2012"
	goto begin
)

REM Check if Visual Studio 2010 is installed
set MSVCDIR="%PROGFILES%\Microsoft Visual Studio 10.0"
if exist %MSVCDIR% (
    set COMPILER_VER="2010"
	goto begin
)

REM Check if Visual Studio 2008 is installed
set MSVCDIR="%PROGFILES%\Microsoft Visual Studio 9.0"
if exist %MSVCDIR% (
    set COMPILER_VER="2008"
	goto begin
)

REM Check if Visual Studio 2005 is installed
set MSVCDIR="%PROGFILES%\Microsoft Visual Studio 8"
if exist %MSVCDIR% (
	set COMPILER_VER="2005"
	goto begin
) 

echo No compiler : Microsoft Visual Studio (2005, 2008, 2010, 2012 or 2013) is not installed.
goto end

:begin
REM Setup path to helper bin
set ROOT_DIR="%CD%"
set RM="%CD%\bin\unxutils\rm.exe"
set CP="%CD%\bin\unxutils\cp.exe"
set MKDIR="%CD%\bin\unxutils\mkdir.exe"
set SEVEN_ZIP="%CD%\bin\7-zip\7za.exe"
set WGET="%CD%\bin\unxutils\wget.exe"
set XIDEL="%CD%\bin\xidel\xidel.exe"
path %path%;%CD%\bin\perl\perl\bin\;%CD%\bin\nasm

REM Housekeeping
%RM% -rf tmp_*
%RM% -rf third-party
%RM% -rf openssl.tar*
%RM% -rf build_*.txt

REM Get download url .
echo Get download url...
%XIDEL% http://www.openssl.org/source/ -e "//pre/font/a/font" > tmp_url
set /p url=<tmp_url

REM Download latest openssl and rename to openssl.tar.gz
echo Downloading latest openssl...
%WGET% "http://www.openssl.org/source/%url%" -O openssl.tar.gz

REM Extract downloaded zip file to tmp_openssl
%SEVEN_ZIP% x openssl.tar.gz -y | FIND /V "Igor Pavlov"

goto build_all

:build
set TARGET=%1
set CONFIG=%2
set FORMAT=%3
set BITS=%4

%SEVEN_ZIP% x openssl.tar -y -otmp_openssl | FIND /V "ing  " | FIND /V "Igor Pavlov"

REM Static Release version
cd tmp_openssl\openssl*

if "%FORMAT%" == "dll" (
	perl Configure %TARGET% enable-static-engine --prefix=openssl-%CONFIG%-%FORMAT%
	if "%TARGET%" == "VC-WIN32" (
		call ms\do_ms.bat
	) 
	if "%TARGET%" == "VC-WIN64A" (
		call ms\do_win64a.bat
	)
	nmake -f ms/ntdll.mak
	nmake -f ms/ntdll.mak install	
) else (
	perl Configure %TARGET% --prefix=openssl-%CONFIG%-%FORMAT%
	if "%TARGET%" == "VC-WIN32" (
		call ms\do_ms.bat
	) 
	if "%TARGET%" == "VC-WIN64A" (
		call ms\do_win64a.bat
	)
	nmake -f ms/nt.mak
	nmake -f ms/nt.mak install
)

%MKDIR% -p %ROOT_DIR%\third-party\libopenssl\%CONFIG%-%FORMAT%-%BITS%\lib
%CP% -rf openssl-%CONFIG%-%FORMAT%\include %ROOT_DIR%\third-party\libopenssl\%CONFIG%-%FORMAT%-%BITS%
%CP% openssl-%CONFIG%-%FORMAT%\lib\*.lib %ROOT_DIR%\third-party\libopenssl\%CONFIG%-%FORMAT%-%BITS%\lib
if "%FORMAT%" == "dll" (
	%CP% openssl-%CONFIG%-%FORMAT%\bin\*.dll %ROOT_DIR%\third-party\libopenssl\%CONFIG%-%FORMAT%-%BITS%\lib
)

cd %ROOT_DIR%
%RM% -rf tmp_openssl

goto end

:build_target
set TARGET=%1
if "%TARGET%"=="VC-WIN32" (
	set BITS=32
	call %MSVCDIR%\VC\vcvarsall.bat x86
	goto build
)

if "%TARGET%"=="VC-WIN64A" (
	set BITS=64
	call %MSVCDIR%\VC\vcvarsall.bat x64
	goto build
)

echo Unsupported target : Only VC-WIN32 and VC-WIN64A supported.
goto end

:build
call :build %TARGET% release static %BITS%
call :build %TARGET% release dll %BITS%
call :build debug-%TARGET% debug static %BITS%
call :build debug-%TARGET% debug dll %BITS%

goto end

:build_all
call :build_target VC-WIN32
call :build_target VC-WIN64A

:cleanup
%RM% -rf tmp_*
%RM% -rf openssl.tar*
%RM% -rf build_*.txt

:end
exit /b
 