# Interactive script to help push portfolio to GitHub
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GitHub Push Setup Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Verify files
Write-Host "Step 1: Checking files..." -ForegroundColor Yellow
$files = @("index.html", "styles.css", "script.js", "README.md")
$allExist = $true
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $file" -ForegroundColor Red
        $allExist = $false
    }
}

if (-not $allExist) {
    Write-Host ""
    Write-Host "Error: Some files are missing!" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Step 2: Checking git status..." -ForegroundColor Yellow
git add -A
$status = git status --porcelain
if ($status) {
    Write-Host "  Committing changes..." -ForegroundColor Yellow
    git commit -m "Update portfolio files"
    Write-Host "  [OK] Changes committed" -ForegroundColor Green
} else {
    Write-Host "  [OK] All changes committed" -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 3: Setting up remote..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>$null
if (-not $remote) {
    git remote add origin https://github.com/waterflex57/Portfolio.git
    Write-Host "  [OK] Remote added" -ForegroundColor Green
} else {
    Write-Host "  [OK] Remote configured" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Authentication Required" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To push to GitHub, you need a Personal Access Token." -ForegroundColor Yellow
Write-Host ""
Write-Host "I'll help you get one. Here's what to do:" -ForegroundColor White
Write-Host ""
Write-Host "1. I'll open your browser to create a token" -ForegroundColor Cyan
Write-Host "2. Click 'Generate new token (classic)'" -ForegroundColor Cyan
Write-Host "3. Name it 'Portfolio Push' (or anything you like)" -ForegroundColor Cyan
Write-Host "4. Check the 'repo' checkbox" -ForegroundColor Cyan
Write-Host "5. Click 'Generate token' at the bottom" -ForegroundColor Cyan
Write-Host "6. COPY THE TOKEN (you won't see it again)" -ForegroundColor Yellow
Write-Host "7. Come back here and paste it when prompted" -ForegroundColor Cyan
Write-Host ""

$response = Read-Host "Ready to open the token page? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    Start-Process "https://github.com/settings/tokens/new"
    Write-Host ""
    Write-Host "Browser opened! Follow the steps above, then come back here." -ForegroundColor Green
    Write-Host ""
    Start-Sleep -Seconds 3
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Enter Your Token" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Paste your Personal Access Token below:" -ForegroundColor Yellow
Write-Host "(It will be hidden for security)" -ForegroundColor Gray
Write-Host ""

$secureToken = Read-Host "Token" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
)

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host ""
    Write-Host "No token provided. Exiting." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Attempting to push with your token..." -ForegroundColor Yellow
Write-Host ""

# Update remote URL to include token
$remoteUrl = "https://$token@github.com/waterflex57/Portfolio.git"
git remote set-url origin $remoteUrl

# Try to push
try {
    $output = git push -u origin main 2>&1 | Out-String
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "  SUCCESS!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your portfolio has been pushed to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "View it at: https://github.com/waterflex57/Portfolio" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "To enable GitHub Pages:" -ForegroundColor Yellow
        Write-Host "1. Go to your repository on GitHub" -ForegroundColor White
        Write-Host "2. Settings → Pages" -ForegroundColor White
        Write-Host "3. Select 'main' branch" -ForegroundColor White
        Write-Host "4. Your site will be at: https://waterflex57.github.io/Portfolio/" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "  Push Failed" -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Error details:" -ForegroundColor Yellow
        Write-Host $output -ForegroundColor Red
        Write-Host ""
        Write-Host "Possible issues:" -ForegroundColor Yellow
        Write-Host "- Token might be incorrect" -ForegroundColor White
        Write-Host "- Token might not have repo permissions" -ForegroundColor White
        Write-Host "- Network connection issue" -ForegroundColor White
        Write-Host ""
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

# Clean up - remove token from remote URL for security
git remote set-url origin https://github.com/waterflex57/Portfolio.git

Write-Host ""
Write-Host "Script completed." -ForegroundColor Cyan
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

