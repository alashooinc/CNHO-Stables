REM SystemPropertiesAdvanced
REM setx PATH "%PATH%;C:\tools" /M
@echo off
REM ===========================================
REM NSSM Install Script for Cosmos SDK Node
REM Service Name: cnho_stables_service
REM Executable: cnho_stables.exe
REM Data Directory: --home=.
REM Log Output: stdout.log / stderr.log
REM ===========================================

REM --- Change to your actual node directory ---
set NODE_DIR=D:\CNHO
set NODE_EXE=%NODE_DIR%\cnho_stables.exe
set SERVICE_NAME=cnho_stables_service
set DATA_DIR=%NODE_DIR%\data
set SAFE_FILE=%NODE_DIR%\priv_validator_state.json
set TARGET_FILE=%DATA_DIR%\priv_validator_state.json

echo Checking if service %SERVICE_NAME% already exists...

REM --- Stop and remove old service if it exists ---
nssm status %SERVICE_NAME% >nul 2>&1
if %ERRORLEVEL%==0 (
    echo Stopping old service...
    nssm stop %SERVICE_NAME%
    echo Removing old service...
    nssm remove %SERVICE_NAME% confirm
)

REM --- Restore priv_validator_state.json before reinstall ---
if exist "%SAFE_FILE%" (
    echo Copying priv_validator_state.json into data directory...
    copy /Y "%SAFE_FILE%" "%TARGET_FILE%"
) else (
    if exist "%TARGET_FILE%" (
        echo WARNING: Safe copy not found, using existing data file.
        echo Creating a safe copy in %SAFE_FILE% ...
        copy /Y "%TARGET_FILE%" "%SAFE_FILE%"
    ) else (
        echo ERROR: priv_validator_state.json not found in either location!
        echo Node will not start without this file.
    )
)

echo Installing service %SERVICE_NAME% ...

REM --- Install the service with absolute path for --home ---
nssm install %SERVICE_NAME% "%NODE_EXE%" start --home="%NODE_DIR%"

REM --- Set working directory ---
nssm set %SERVICE_NAME% AppDirectory "%NODE_DIR%"

REM --- Set log output ---
nssm set %SERVICE_NAME% AppStdout "%NODE_DIR%\stdout.log"
nssm set %SERVICE_NAME% AppStderr "%NODE_DIR%\stderr.log"
nssm set %SERVICE_NAME% AppRotateFiles 1

REM --- Set automatic restart ---
nssm set %SERVICE_NAME% AppRestartDelay 5000
nssm set %SERVICE_NAME% AppStopMethodConsole 1500

REM --- Set service to start automatically at boot ---
nssm set %SERVICE_NAME% Start SERVICE_AUTO_START

REM --- Start the service ---
nssm start %SERVICE_NAME%

echo.
echo ===========================================
echo  Service %SERVICE_NAME% has been installed and started!
echo  priv_validator_state.json has been restored/initialized.
echo  Check the service in: services.msc
echo  Log files: %NODE_DIR%\stdout.log / stderr.log
echo ===========================================
pause
