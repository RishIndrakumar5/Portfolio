@echo off
echo ========================================
echo Portfolio GitHub Push Script
echo ========================================
echo.

echo Checking git status...
git status

echo.
echo Files ready to push:
git ls-files

echo.
echo Attempting to push to GitHub...
echo.

git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! Code pushed to GitHub!
    echo ========================================
    echo.
    echo Your portfolio is now available at:
    echo https://github.com/waterflex57/Portfolio
) else (
    echo.
    echo ========================================
    echo Push requires authentication
    echo ========================================
    echo.
    echo Please authenticate with GitHub when prompted.
    echo Or use GitHub Desktop to push the code.
    echo.
)

echo.
pause

