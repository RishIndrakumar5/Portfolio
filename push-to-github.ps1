# PowerShell script to push portfolio to GitHub
# This script will help push your code to the GitHub repository

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Portfolio GitHub Push Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in a git repository
if (-not (Test-Path .git)) {
    Write-Host "Error: Not a git repository!" -ForegroundColor Red
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init
    git config user.email "waterflexyt@gmail.com"
    git config user.name "Rishwanth Indrakumar"
}

# Check git status
Write-Host "Checking git status..." -ForegroundColor Yellow
$status = git status --porcelain
if ($status) {
    Write-Host "Uncommitted changes detected. Adding and committing..." -ForegroundColor Yellow
    git add -A
    git commit -m "Update portfolio files"
} else {
    Write-Host "All changes are committed." -ForegroundColor Green
}

# Check if remote exists
Write-Host "Checking remote repository..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>$null
if (-not $remote) {
    Write-Host "Adding remote repository..." -ForegroundColor Yellow
    git remote add origin https://github.com/waterflex57/Portfolio.git
} else {
    Write-Host "Remote repository configured: $remote" -ForegroundColor Green
}

# Show what will be pushed
Write-Host ""
Write-Host "Files to be pushed:" -ForegroundColor Cyan
git ls-files | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }

Write-Host ""
Write-Host "Attempting to push to GitHub..." -ForegroundColor Yellow
Write-Host ""

# Try to push
try {
    $pushOutput = git push -u origin main 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "SUCCESS! Code pushed to GitHub!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your portfolio is now available at:" -ForegroundColor Cyan
        Write-Host "https://github.com/waterflex57/Portfolio" -ForegroundColor Yellow
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "Push may require authentication" -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "The push command needs your GitHub credentials." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Options:" -ForegroundColor Cyan
        Write-Host "1. Use GitHub Desktop (recommended)" -ForegroundColor White
        Write-Host "   - Open GitHub Desktop" -ForegroundColor White
        Write-Host "   - Add this repository" -ForegroundColor White
        Write-Host "   - Click 'Push origin'" -ForegroundColor White
        Write-Host ""
        Write-Host "2. Use Personal Access Token" -ForegroundColor White
        Write-Host "   - Go to: https://github.com/settings/tokens" -ForegroundColor White
        Write-Host "   - Create new token with 'repo' permissions" -ForegroundColor White
        Write-Host "   - Use token as password when pushing" -ForegroundColor White
        Write-Host ""
        Write-Host "3. Try pushing manually:" -ForegroundColor White
        Write-Host "   git push -u origin main" -ForegroundColor Yellow
        Write-Host ""
        
        # Show the actual error
        if ($pushOutput) {
            Write-Host "Error details:" -ForegroundColor Red
            Write-Host $pushOutput -ForegroundColor Red
        }
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Script completed." -ForegroundColor Cyan
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

