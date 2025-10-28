@echo off
setlocal enabledelayedexpansion

REM Pfad zur CSV-Datei
set "CSVDatei=C:\Users\derba\Documents\MultiMonitorTool\test_monitors.csv"

REM Export monitor info to a CSV file (Fehler unterdrücken)
.\MultiMonitorTool.exe /scomma "%CSVDatei%" >nul 2>nul

REM Prüfen, ob Datei existiert
if not exist "%CSVDatei%" (
    echo Datei existiert nicht: %CSVDatei%
    pause
    exit /b
)

REM Zeile 2 auslesen
set "zeile="
set /a count=0
for /f "usebackq delims=" %%A in ("%CSVDatei%") do (
    set /a count+=1
    if !count! EQU 2 (
        set "zeile=%%A"
        goto :gefunden
    )
)

:gefunden

REM Prüfen, ob die Zeile den gewünschten Wert enthält
set "wert1=Yes,No,Yes"
set "wert2=Yes,No,No"

echo "!zeile!" | find /C "%wert1%" >nul
if %errorlevel%==0 (
    echo Primary monitor has been switched.
    .\MultiMonitorTool.exe /SetPrimary 1 >nul 2>nul
    goto :ende
)

echo "!zeile!" | find /C "%wert2%" >nul
if %errorlevel%==0 (
    echo Primary monitor has been switched.
    .\MultiMonitorTool.exe /SetPrimary 2 >nul 2>nul
    goto :ende
)

:ende
pause
