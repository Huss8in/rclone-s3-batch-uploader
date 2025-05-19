@echo off
setlocal enabledelayedexpansion

REM Check if directory argument is provided
if "%~1"=="" (
    echo Usage: upload_to_s3.bat [local_directory] [rclone_remote]
    echo Example: upload_to_s3.bat C:\myfolder myaws:s3bucket
    exit /b 1
)

REM Check if rclone remote argument is provided
if "%~2"=="" (
    echo Usage: upload_to_s3.bat [local_directory] [rclone_remote]
    echo Example: upload_to_s3.bat C:\myfolder myaws:s3bucket
    exit /b 1
)

set "LOCAL_DIR=%~1"
set "RCLONE_REMOTE=%~2"

REM Max retries per file
set MAX_RETRIES=3

REM Function to upload one file with retry
:upload_file
set "FILE_PATH=%~1"
set RETRY=0

:retry_loop
echo Uploading: "!FILE_PATH!"
rclone copy "!FILE_PATH!" "%RCLONE_REMOTE%/"

if errorlevel 1 (
    set /a RETRY+=1
    if !RETRY! leq %MAX_RETRIES% (
        echo Error uploading "!FILE_PATH!". Retry !RETRY! of %MAX_RETRIES%.
        timeout /t 5 /nobreak >nul
        goto retry_loop
    ) else (
        echo Failed to upload "!FILE_PATH!" after %MAX_RETRIES% attempts. Skipping.
    )
) else (
    echo Uploaded successfully: "!FILE_PATH!"
)
goto :eof

REM Main script starts here

REM Loop through all files recursively and upload each one
for /r "%LOCAL_DIR%" %%F in (*) do (
    call :upload_file "%%~fF"
)

echo All files processed.
endlocal
exit /b
