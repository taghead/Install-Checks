@echo off
SETLOCAL

SET BFME1FullName=The Battle for Middle-earth
SET BFME2FullName=The Battle for Middle-earth II
SET BFME25FullName=The Lord of the Rings, The Rise of the Witch-king
SET BFME25EdainModFullName=Edain Mod for Battle for Middle-earth II: Rise of the Witch King

CALL :CheckRegKey "%BFME1FullName%", "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\EA Games\The Battle for Middle-earth", "InstallPath", BFME1Path
CALL :CheckRegKey "%BFME2FullName%", "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Electronic Arts\The Battle for Middle-earth II", "InstallPath", BFME2Path
CALL :CheckRegKey "%BFME25FullName%", "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Electronic Arts\The Lord of the Rings, The Rise of the Witch-king", "InstallPath", BFME25Path
CALL :CheckFilePath "%BFME25EdainModFullName%", "%BFME25Path%", "Edain_Mod_Launcher.exe", isBFME25EdainModPath

If defined BFME1Path            ( CALL :EchoGreen "[OK] %BFME1FullName% was found" )          Else ( CALL :EchoRed "[BAD] %BFME1FullName% was not found" )
If defined BFME2Path            ( CALL :EchoGreen "[OK] %BFME2FullName% was found" )          Else ( CALL :EchoRed "[BAD] %BFME2FullName% was not found" )
If defined BFME25Path           ( CALL :EchoGreen "[OK] %BFME25FullName% was found" )         Else ( CALL :EchoRed "[BAD] %BFME25FullName% was not found" )
If defined isBFME25EdainModPath ( CALL :EchoGreen "[OK] %BFME25EdainModFullName% was found" ) Else ( CALL :EchoRed "[BAD] %BFME25EdainModFullName% was not found" )

pause
exit

@REM FUNCTIONS

@REM FUNCTION - Check registry key
:CheckRegKey

SET HumanReadableName=%~1
SET RegPath=%~2
SET RegKey=%~3
SET "EndResult="

@FOR /f "tokens=2*" %%i in ('Reg Query "%RegPath%" /v "%RegKey%" 2^>Nul') do Set "Result=%%j"
If defined Result (set EndResult=%Result% ) Else ( set "EndResult=" )

set %~4=%EndResult%
EXIT /B 0

@REM FUNCTION - Check file path
:CheckFilePath

SET HumanReadableName=%~1
SET FilePath=%~2
SET FileName=%~3
SET "EndResult="

dir "%FilePath%%FileName%"
echo "%FilePath%%FileName%"

set %~4=%EndResult%
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