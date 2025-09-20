@echo off
REM ===========================================
REM NSSM Uninstall Script for Cosmos SDK Node
REM Service Name: cnho_stables_service
REM ===========================================

set SERVICE_NAME=cnho_stables_service
set NODE_DIR=D:\CNHO

echo Checking if service %SERVICE_NAME% exists...

REM --- Check service status ---
nssm status %SERVICE_NAME% >nul 2>&1
if %ERRORLEVEL%==0 (
    echo Stopping service %SERVICE_NAME%...
    nssm stop %SERVICE_NAME%
    
    echo Removing service %SERVICE_NAME%...
    nssm remove %SERVICE_NAME% confirm
) else (
    echo Service %SERVICE_NAME% does not exist.
)

REM --- Optional: remove log files ---
if exist "%NODE_DIR%\stdout.log" del "%NODE_DIR%\stdout.log"
if exist "%NODE_DIR%\stderr.log" del "%NODE_DIR%\stderr.log"

echo.
echo ===========================================
echo  Service %SERVICE_NAME% has been uninstalled!
echo  Logs cleared: %NODE_DIR%\stdout.log / stderr.log
echo ===========================================
pause
