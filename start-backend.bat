@echo off
cd /d "%~dp0Backend"
echo Starting Ride Booking backend...
npm run dev
if errorlevel 1 (
  echo.
  echo Backend failed to start.
  pause
)
