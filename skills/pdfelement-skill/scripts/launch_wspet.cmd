@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

rem PDFToolbox wspet:// Protocol Launcher (standalone CMD edition)
rem Usage:
rem   launch_wspet.cmd convert .docx "C:\Docs\sample.pdf"
rem   launch_wspet.cmd optimize "C:\Docs\sample.pdf"

set "COMMAND_ENV=%~1"
set "ARG2=%~2"
set "ARG3=%~3"
set "ARG4=%~4"
set "TARGET_FORMAT_ENV="
set "FILE_PATH_ENV="
set "PASSWORD_ENV="
set "TEMP_XML=%TEMP%\pdfelement-files-%RANDOM%%RANDOM%.xml"
set "TEMP_PARAMS=%TEMP%\pdfelement-params-%RANDOM%%RANDOM%.txt"
set "TEMP_XML_B64=%TEMP%\pdfelement-files-%RANDOM%%RANDOM%.b64"
set "TEMP_PARAMS_B64=%TEMP%\pdfelement-params-%RANDOM%%RANDOM%.b64"
set "WSPET_KEY="
set "WSPET_COMMAND="
set "WSPET_EXE="
set "PARAMS=%COMMAND_ENV%"

if "%COMMAND_ENV%"=="" goto :usage

if /I "%COMMAND_ENV%"=="convert" (
    set "TARGET_FORMAT_ENV=%ARG2%"
    set "FILE_PATH_ENV=%ARG3%"
    set "PASSWORD_ENV=%ARG4%"
) else (
    set "FILE_PATH_ENV=%ARG2%"
    set "PASSWORD_ENV=%ARG3%"
)

call :get_wspet_protocol
if errorlevel 1 (
    call :install_guidance
    exit /b 2
)

if not "%FILE_PATH_ENV%"=="" if not exist "%FILE_PATH_ENV%" (
    echo File not found: "%FILE_PATH_ENV%"
    exit /b 1
)

if /I "%COMMAND_ENV%"=="convert" (
    if "%TARGET_FORMAT_ENV%"=="" (
        echo Error: convert requires a target format such as .docx or .jpg
        exit /b 1
    )
    set "PARAMS=%PARAMS% -t %TARGET_FORMAT_ENV%"
)

if not "%FILE_PATH_ENV%"=="" (
    call :build_file_payload "%FILE_PATH_ENV%" "%PASSWORD_ENV%" FILES_B64
    if errorlevel 1 goto :cleanup_fail
    set "PARAMS=!PARAMS! -f !FILES_B64!"
)

set "PARAMS=!PARAMS! -wsclaw -autoexec -entrance OpenClaw"

if not "%FILE_PATH_ENV%"=="" (
    call :reset_toolbox_instance
    if errorlevel 1 goto :cleanup_fail
    timeout /t 2 /nobreak >nul
)

echo Command parameters: !PARAMS!
> "%TEMP_PARAMS%" <nul set /p "=!PARAMS!"
call :encode_file_base64 "%TEMP_PARAMS%" "%TEMP_PARAMS_B64%" PARAMS_B64
if errorlevel 1 goto :cleanup_fail

set "ESCAPED_URI=!PARAMS_B64!"
set "ESCAPED_URI=!ESCAPED_URI:+=%%2B!"
set "ESCAPED_URI=!ESCAPED_URI:/=%%2F!"
set "ESCAPED_URI=!ESCAPED_URI:==%%3D!"

echo Launching: wspet://param=!ESCAPED_URI!
start "" "wspet://param=!ESCAPED_URI!"
set "START_EXIT=%errorlevel%"
call :cleanup_temp
exit /b %START_EXIT%

:usage
echo Usage: launch_wspet.cmd ^<command^> [target_format] [file_path] [password]
echo Example: launch_wspet.cmd convert .docx "C:\Docs\sample.pdf"
echo Example: launch_wspet.cmd optimize "C:\Docs\sample.pdf"
exit /b 1

:build_file_payload
setlocal EnableDelayedExpansion
set "INPUT_FILE=%~1"
set "INPUT_PASSWORD=%~2"
set "OUTPUT_VALUE="

for %%I in ("%INPUT_FILE%") do set "FULL_FILE=%%~fI"
call :escape_xml "!FULL_FILE!" ESCAPED_FILE_PATH
call :escape_xml "!INPUT_PASSWORD!" ESCAPED_PASSWORD

> "%TEMP_XML%" (
    echo ^<?xml version="1.0" encoding="UTF-8"?^>
    echo ^<Files^>
    echo   ^<File^>
    echo     ^<Path^>!ESCAPED_FILE_PATH!^</Path^>
    echo     ^<Password^>!ESCAPED_PASSWORD!^</Password^>
    echo   ^</File^>
    echo ^</Files^>
)

call :encode_file_base64 "%TEMP_XML%" "%TEMP_XML_B64%" OUTPUT_VALUE
if errorlevel 1 (
    endlocal & exit /b 1
)
endlocal & set "%~3=%OUTPUT_VALUE%"
exit /b 0

:get_wspet_protocol
set "WSPET_KEY="
set "WSPET_COMMAND="
set "WSPET_EXE="
call :read_protocol_key "HKCR\wspet\shell\open\command"
if errorlevel 1 call :read_protocol_key "HKCU\Software\Classes\wspet\shell\open\command"
if not defined WSPET_COMMAND goto :protocol_missing

set "WSPET_EXE=%WSPET_COMMAND:REG_SZ=%"
for /f "tokens=* delims= " %%E in ("%WSPET_EXE%") do set "WSPET_EXE=%%~E"
if not defined WSPET_EXE goto :protocol_missing
if not exist "%WSPET_EXE%" goto :protocol_missing
exit /b 0

:protocol_missing
echo wspet protocol check failed.
if defined WSPET_KEY echo Registry key: %WSPET_KEY%
if defined WSPET_COMMAND echo Protocol command: %WSPET_COMMAND%
if defined WSPET_EXE echo Missing executable: %WSPET_EXE%
exit /b 1

:read_protocol_key
set "WSPET_KEY=%~1"
for /f "skip=2 tokens=1,*" %%A in ('reg query "%~1" /ve 2^>nul') do (
    if /I "%%A"=="(Default)" set "WSPET_COMMAND=%%B"
)
exit /b 0

:escape_xml
setlocal EnableDelayedExpansion
set "VALUE=%~1"
set "VALUE=!VALUE:^&=&amp;!"
set "VALUE=!VALUE:^<=&lt;!"
set "VALUE=!VALUE:^>=&gt;!"
set "VALUE=!VALUE:'=&apos;!"
endlocal & set "%~2=%VALUE%"
exit /b 0

:encode_file_base64
setlocal EnableDelayedExpansion
set "INPUT=%~1"
set "OUTPUT=%~2"
set "VALUE="
where certutil >nul 2>nul
if errorlevel 1 (
    echo Error: certutil is required for base64 encoding.
    endlocal & exit /b 1
)
certutil -f -encode "%INPUT%" "%OUTPUT%" >nul 2>nul
if errorlevel 1 (
    echo Error: failed to base64-encode "%INPUT%".
    endlocal & exit /b 1
)
for /f "usebackq delims=" %%L in ("%OUTPUT%") do (
    if /I not "%%L"=="-----BEGIN CERTIFICATE-----" if /I not "%%L"=="-----END CERTIFICATE-----" set "VALUE=!VALUE!%%L"
)
endlocal & set "%~3=%VALUE%"
exit /b 0

:reset_toolbox_instance
tasklist /FI "IMAGENAME eq PDFToolbox.exe" 2>nul | find /I "PDFToolbox.exe" >nul
if errorlevel 1 exit /b 0

echo Detected existing PDFToolbox instance; resetting it first.
call :launch_raw_param "/nowexit"
timeout /t 4 /nobreak >nul
taskkill /IM PDFToolbox.exe /F >nul 2>nul
timeout /t 2 /nobreak >nul
exit /b 0

:launch_raw_param
setlocal EnableDelayedExpansion
set "RAW_PARAM=%~1"
> "%TEMP_PARAMS%" <nul set /p "=!RAW_PARAM!"
call :encode_file_base64 "%TEMP_PARAMS%" "%TEMP_PARAMS_B64%" RAW_B64
if errorlevel 1 (
    endlocal & exit /b 1
)
set "RAW_URI=!RAW_B64!"
set "RAW_URI=!RAW_URI:+=%%2B!"
set "RAW_URI=!RAW_URI:/=%%2F!"
set "RAW_URI=!RAW_URI:==%%3D!"
start "" "wspet://param=!RAW_URI!"
set "RAW_EXIT=!errorlevel!"
endlocal & exit /b !RAW_EXIT!

:cleanup_temp
del /q "%TEMP_XML%" "%TEMP_PARAMS%" "%TEMP_XML_B64%" "%TEMP_PARAMS_B64%" >nul 2>nul
exit /b 0

:cleanup_fail
call :cleanup_temp
exit /b 1

:install_guidance
echo PDFelement is a local PDF editor and batch-processing tool from Wondershare.
echo It can convert PDFs to Word/Excel/PPT, run OCR, compress files, translate, watermark, split/merge, sign, and secure documents.
echo.
echo I couldn't launch PDFelement because the wspet:// protocol is unavailable on this machine.
echo That usually means PDFelement is missing, not registered correctly, or the version is too old.
echo Download link: https://pdf.wondershare.com/
echo After installing or updating PDFelement, try again. A Windows restart may be needed so the protocol registration takes effect.
exit /b 0
