@echo off
setlocal EnableExtensions
rem ============================================================
rem  Start_With_GPIO  -  Keil build + STM32CubeProgrammer flash
rem ------------------------------------------------------------
rem  USAGE
rem    double-click this file          -^> build + flash
rem    build_and_flash.bat rebuild     -^> full rebuild + flash
rem
rem  WHY THIS SCRIPT EXISTS
rem    Keil MDK 5.38 and newer refuse NON-GENUINE ("clone")
rem    ST-Link dongles.  The Download button then fails with
rem    "ST-LINK USB communication error" or
rem    "No ST-LINK detected".
rem    STM32CubeProgrammer has NO such genuine-device check,
rem    so we let Keil do the COMPILING and let CubeProgrammer
rem    do the FLASHING.
rem
rem  WHAT MUST BE INSTALLED ON THE PC THAT RUNS THIS
rem    1) Keil MDK (uVision) 5.x  +  Arm Compiler 5 (AC5)
rem    2) Device pack  Keil.STM32F1xx_DFP   (for STM32F103C8)
rem    3) STM32CubeProgrammer  - only needed to flash
rem
rem  All paths below are AUTO-DETECTED, so this file can be
rem  copied to another PC as-is.  If detection fails on your
rem  machine, just hard-code the paths in the OVERRIDE block.
rem
rem  NOTE: CubeMX writes the build output into a SUB-FOLDER:
rem        MDK-ARM\Start_With_GPIO\Start_With_GPIO.hex
rem
rem  (This file is plain ASCII on purpose - non-ASCII text in
rem   a .bat can turn into mojibake on a GBK console.)
rem ============================================================

setlocal
cd /d "%~dp0"

rem ---- OVERRIDE (optional) -----------------------------------
rem  Uncomment + edit these two lines if auto-detect fails:
rem set "KEIL=D:\Keil_v5\UV4\UV4.exe"
rem set "CLI=D:\ST\STM32CubeCLT\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
rem ------------------------------------------------------------

set "MODE=-b"
if /i "%~1"=="rebuild" set "MODE=-r"

rem ---- 0) find the Keil project next to this script ---------
set "PROJ="
for %%F in ("%~dp0*.uvprojx") do if not defined PROJ if exist "%%~fF" set "PROJ=%%~fF"
if not defined PROJ goto :noproj
for %%F in ("%PROJ%") do set "PROJNAME=%%~nF"
echo [INFO] project = %PROJ%

rem ---- 0b) is it pinned to Arm Compiler 5? -----------------
findstr /c:"uAC6>0<" "%PROJ%" >nul 2>nul
if errorlevel 1 goto :skipac5

rem ---- 1) locate Keil UV4.exe ------------------------------
if not defined KEIL call :findkeil
if not defined KEIL goto :nokeil

rem normalise to a full path (guards against "\Keil_v5\..." style)
for %%K in ("%KEIL%") do set "KEIL=%%~fK"
for %%K in ("%KEIL%\..\..") do set "KEILROOT=%%~fK"
echo [INFO] keil    = %KEIL%

set "AC5="
if exist "%KEILROOT%\ARM\ARMCC\bin\armcc.exe" set "AC5=%KEILROOT%\ARM\ARMCC\bin\armcc.exe"
if not defined AC5 for /d %%A in ("%KEILROOT%\ARM\ARM_Compiler*") do if not defined AC5 if exist "%%~fA\bin\armcc.exe" set "AC5=%%~fA\bin\armcc.exe"
if not defined AC5 for /d %%A in ("%KEILROOT%\ARM\ARMCC*") do if not defined AC5 if exist "%%~fA\bin\armcc.exe" set "AC5=%%~fA\bin\armcc.exe"
if defined AC5 goto :skipac5
echo.
echo [WARN] project is pinned to Arm Compiler 5  ^(^<uAC6^>0^</uAC6^>^)
echo        but no armcc.exe was found under:
echo          %KEILROOT%\ARM\
echo        Build would fail with
echo          "Cannot find compiler 'ArmCC'".
echo        Fix: install the legacy AC5 support, or switch the
echo        project to AC6 in Options for Target -^> Target.
echo.
:skipac5

rem ---- 2) locate STM32CubeProgrammer CLI -------------------
if not defined CLI call :findcli
if defined CLI for %%C in ("%CLI%") do set "CLI=%%~fC"
if defined CLI echo [INFO] cli     = %CLI%

echo.
echo ============================================
echo  1/3  Building with Keil  (mode=%MODE%) ...
echo ============================================
"%KEIL%" %MODE% "%PROJ%" -j0 -o "%~dp0build_check.log"
set "RC=%ERRORLEVEL%"
echo ---- build_check.log ------------------------------
type "%~dp0build_check.log"
echo ---------------------------------------------------
findstr /c:"0 Error(s)" "%~dp0build_check.log" >nul 2>nul
if errorlevel 1 goto :buildfail
if not "%RC%"=="0" echo [WARN] Keil exit code %RC% - warnings present, continuing.
echo [OK]  0 error(s).

echo.
echo ============================================
echo  2/3  Locating the .hex output ...
echo ============================================
set "HEX="
if exist "%~dp0%PROJNAME%.hex"             set "HEX=%~dp0%PROJNAME%.hex"
if defined HEX goto :hexfound
if exist "%~dp0%PROJNAME%\%PROJNAME%.hex"  set "HEX=%~dp0%PROJNAME%\%PROJNAME%.hex"
if defined HEX goto :hexfound
for /f "delims=" %%H in ('dir /s /b "%~dp0*.hex" 2^>nul') do if not defined HEX set "HEX=%%H"
if defined HEX goto :hexfound

echo [ERROR] no .hex found under:
echo         %~dp0
echo         Check Options for Target -^> Output -^> Create HEX File
pause
exit /b 1

:hexfound
echo [OK]  hex = %HEX%

if not defined CLI goto :nocli

echo.
echo ============================================
echo  3/3  Flashing with STM32CubeProgrammer ...
echo ============================================
"%CLI%" -c port=SWD -w "%HEX%" -v -rst
if errorlevel 1 goto :flashfail

echo.
echo ============================================
echo  [DONE] compiled + flashed + verified + reset
echo ============================================
pause
exit /b 0


rem ===========================================================
rem  helpers - path auto-detection
rem ===========================================================

:findkeil
set "KEIL="
if not "%ProgramFiles%"=="" if exist "%ProgramFiles%\Keil_v5\UV4\UV4.exe" set "KEIL=%ProgramFiles%\Keil_v5\UV4\UV4.exe"
if defined KEIL goto :eof
if not "%ProgramFiles%"=="" if exist "%ProgramFiles%\Keil\UV4\UV4.exe" set "KEIL=%ProgramFiles%\Keil\UV4\UV4.exe"
if defined KEIL goto :eof
if not "%ProgramFiles(x86)%"=="" if exist "%ProgramFiles(x86)%\Keil_v5\UV4\UV4.exe" set "KEIL=%ProgramFiles(x86)%\Keil_v5\UV4\UV4.exe"
if defined KEIL goto :eof
for %%D in (C D E F G H) do call :trykeil "%%D:\Keil_v5\UV4\UV4.exe"
if defined KEIL goto :eof
for %%D in (C D E F G H) do call :trykeil "%%D:\Keil\UV4\UV4.exe"
if defined KEIL goto :eof
for %%D in (C D E F G H) do call :trykeil "%%D:\MDK\UV4\UV4.exe"
if defined KEIL goto :eof
for %%D in (C D E F G H) do call :trykeil "%%D:\Program Files\Keil_v5\UV4\UV4.exe"
if defined KEIL goto :eof
for %%D in (C D E F G H) do call :trykeil "%%D:\Program Files (x86)\Keil_v5\UV4\UV4.exe"
if defined KEIL goto :eof
for /f "delims=" %%P in ('where UV4.exe 2^>nul') do if not defined KEIL set "KEIL=%%P"
if defined KEIL goto :eof
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\WOW6432Node\Keil\Products\MDK" /v Path 2^>nul') do if not defined KEIL call :trykeil "%%B\UV4\UV4.exe"
if defined KEIL goto :eof
for /f "tokens=2,*" %%A in ('reg query "HKCU\SOFTWARE\Keil\Products\MDK" /v Path 2^>nul') do if not defined KEIL call :trykeil "%%B\UV4\UV4.exe"
goto :eof

:trykeil
if not defined KEIL if exist %1 set "KEIL=%~1"
goto :eof

:findcli
set "CLI="
if not "%ProgramFiles%"=="" if exist "%ProgramFiles%\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe" set "CLI=%ProgramFiles%\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
if not "%ProgramFiles(x86)%"=="" if exist "%ProgramFiles(x86)%\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe" set "CLI=%ProgramFiles(x86)%\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
for %%D in (C D E F G H) do call :trycli "%%D:\ST\STM32CubeCLT\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
for %%D in (C D E F G H) do call :trycli "%%D:\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
for %%D in (C D E F G H) do call :trycli "%%D:\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
for %%D in (C D E F G H) do call :trycli "%%D:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
for %%D in (C D E F G H) do if not defined CLI for /d %%A in ("%%D:\ST\STM32CubeCLT*") do if not defined CLI call :trycli "%%~fA\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
for %%D in (C D E F G H) do if not defined CLI for /d %%A in ("%%D:\STMicroelectronics\STM32Cube\STM32CubeProgrammer*") do if not defined CLI call :trycli "%%~fA\bin\STM32_Programmer_CLI.exe"
if defined CLI goto :eof
for /f "delims=" %%P in ('where STM32_Programmer_CLI.exe 2^>nul') do if not defined CLI set "CLI=%%P"
goto :eof

:trycli
if not defined CLI if exist %1 set "CLI=%~1"
goto :eof


rem ===========================================================
rem  error / info handlers
rem ===========================================================

:noproj
echo.
echo [ERROR] no .uvprojx file found next to this script:
echo         %~dp0
echo         Put build_and_flash.bat into the MDK-ARM folder,
echo         next to Start_With_GPIO.uvprojx
pause
exit /b 1

:nokeil
echo.
echo [ERROR] Keil uVision ^(UV4.exe^) was not found.
echo         Install Keil MDK, or hard-code the path by editing
echo         this file - look for the OVERRIDE block near the top:
echo             set "KEIL=C:\Keil_v5\UV4\UV4.exe"
pause
exit /b 1

:nocli
echo.
echo [WARN] STM32CubeProgrammer CLI not found - skipping the flash.
echo        But the firmware IS already built and ready here:
echo          %HEX%
echo.
echo        Option A: flash it by hand with the STM32CubeProgrammer
echo                  GUI (Erase + Download the .hex above)
echo        Option B: hard-code the CLI path - see the OVERRIDE
echo                  block at the top of this file
echo        Option C: if your ST-Link is a GENUINE one, you do not
echo                  need this script at all - just press Download
echo                  in Keil
pause
exit /b 0

:buildfail
echo.
echo [ERROR] Keil build failed - see build_check.log above.
echo   "Cannot find compiler 'ArmCC'" -^> Arm Compiler 5 missing
echo   pack / device errors           -^> install Keil.STM32F1xx_DFP
echo   .\Start_With_GPIO\... missing  -^> bad project config
pause
exit /b 1

:flashfail
echo.
echo [ERROR] flash failed.
echo   - ST-Link plugged in?  Board powered?  SWD wires seated?
echo   - Another program holding the dongle?  Close Keil / OpenOCD.
echo   - Try flashing under reset, add:  mode=UR
pause
exit /b 1
