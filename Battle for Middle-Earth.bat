@echo off
SETLOCAL

SET scriptpath=%~dp0
SET scriptdir=%scriptpath:~0,-1%


CALL :MAIN
pause
exit

@REM MAIN
:Main
SET GameLauncher=%scriptdir%\Launcher\Restarter.exe

SET BFME1FullName=The Battle for Middle-earth
SET BFME2FullName=The Battle for Middle-earth II
SET BFME25FullName=The Lord of the Rings, The Rise of the Witch-king
SET BFME25EdainModFullName=Edain Mod for Battle for Middle-earth II: Rise of the Witch King

SET BFME25EdainModExeName="Edain_Mod_Launcher.exe"

SET BFME1REGPath="HKLM\SOFTWARE\WOW6432Node\Electronic Arts\EA Games\The Battle for Middle-earth"
SET BFME2REGPath="HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Electronic Arts\The Battle for Middle-earth II"
SET BFME25REGPath="HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Electronic Arts\The Lord of the Rings, The Rise of the Witch-king"

SET BFME1REGKey="InstallPath"
SET BFME2REGKey="InstallPath"
SET BFME25REGKey="InstallPath"

SET InstallBaseGameExe="%scriptdir%\Launcher\Restarter.exe"
SET InstallEdainModExe="%scriptdir%\Mods\Battle for Middle-earth II Rise of the Witch King\Edain Mod\EdainInstaller4.7.exe"

SET "InstallBaseGame="
SET "InstallEdainMod="

CALL :CheckRegKey %BFME1REGPath%, %BFME1REGKey%, BFME1Path
CALL :CheckRegKey %BFME2REGPath% , %BFME2REGKey%, BFME2Path
CALL :CheckRegKey %BFME25REGPath%, %BFME25REGKey%, BFME25Path
CALL :CheckFilePath "%BFME25Path%", %BFME25EdainModExeName% , BFME25EdainModPath

If defined BFME1Path ( CALL :EchoGreen "[OK] %BFME1FullName% was found" ) Else ( 
    CALL :EchoRed "[BAD] %BFME1FullName% was not found"
    SET "InstallBaseGame=true" 
)

If defined BFME2Path ( CALL :EchoGreen "[OK] %BFME2FullName% was found" ) Else (
    CALL :EchoRed "[BAD] %BFME2FullName% was not found"
    SET "InstallBaseGame=true" 
)

If defined BFME25Path ( CALL :EchoGreen "[OK] %BFME25FullName% was found" ) Else (
    CALL :EchoRed "[BAD] %BFME25FullName% was not found"
    SET "InstallBaseGame=true" 
)

If defined BFME25EdainModPath   ( CALL :EchoGreen "[OK] %BFME25EdainModFullName% was found" ) Else (
    CALL :EchoRed "[BAD] %BFME25EdainModFullName% was not found"
    SET "InstallEdainMod=true"
)

If defined InstallBaseGame (
    echo Please ensure the latest version of:
    If not defined BFME1Path    ( echo - %BFME1FullName% )
    If not defined BFME2Path    ( echo - %BFME2FullName% )
    If not defined BFME25Path   ( echo - %BFME25FullName% )

    CALL %InstallBaseGameExe%

    CALL :RunChecksAgain
) else (
    if defined InstallEdainMod (
        echo Please the Edain mod is installed. The installer will run shortly.
        CALL %InstallEdainModExe%

        CALL :RunChecksAgain
    )
)

EXIT /B 0

@REM FUNCTIONS

@REM FUNCTION - Run checks again
:RunChecksAgain

echo Press any key to run through checks again
pause >nul
CALL :MAIN
exit

EXIT /B 0



@REM FUNCTION - Check registry key
:CheckRegKey

SET RegPath=%~1
SET RegKey=%~2
SET "%~3="

@FOR /f "tokens=2*" %%i in ('Reg Query "%RegPath%" /v "%RegKey%" 2^>Nul') do Set "Result=%%j"
If defined Result ( SET "%~3=%Result:~0,-1%" ) Else ( SET "%~3=" )

EXIT /B 0

@REM FUNCTION - Check file path
:CheckFilePath

SET FilePath=%~1
SET FileName=%~2
SET "%~3="

SET FullPath=%FilePath%\%FileName%

if exist "%FullPath%" ( SET "%~3=%FullPath:~0,-1%" ) Else ( SET "%~3=" )

EXIT /B 0

@REM FUNCTION - Echo Green
:EchoGreen

for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
echo %ESC%[0;32m%~1%ESC%[0m

EXIT /B 0

@REM FUNCTION - Echo Red
:EchoRed

for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
echo %ESC%[0;31m%~1%ESC%[0m

EXIT /B 0