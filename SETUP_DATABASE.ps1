# PostgreSQL Database Setup Script for Farmsight
# This script helps install and configure PostgreSQL

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Farmsight Database Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if PostgreSQL is already installed
$pgServices = Get-Service -Name "*postgresql*" -ErrorAction SilentlyContinue

if ($pgServices) {
    Write-Host "[INFO] PostgreSQL service found: $($pgServices[0].Name)" -ForegroundColor Yellow
    $service = $pgServices[0]
    
    if ($service.Status -eq 'Running') {
        Write-Host "[OK] PostgreSQL is already running!" -ForegroundColor Green
    } else {
        Write-Host "[INFO] Starting PostgreSQL service..." -ForegroundColor Yellow
        try {
            Start-Service -Name $service.Name
            Write-Host "[OK] PostgreSQL service started successfully" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Failed to start service. You may need to run as Administrator." -ForegroundColor Red
            Write-Host "  Error: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "Try running: Start-Service -Name $($service.Name)" -ForegroundColor Yellow
            exit 1
        }
    }
} else {
    Write-Host "[INFO] PostgreSQL is not installed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Would you like to install PostgreSQL 16? (Recommended)" -ForegroundColor Cyan
    Write-Host "This will install PostgreSQL using winget." -ForegroundColor White
    Write-Host ""
    $response = Read-Host "Install PostgreSQL? (Y/N)"
    
    if ($response -eq 'Y' -or $response -eq 'y') {
        Write-Host ""
        Write-Host "Installing PostgreSQL 16..." -ForegroundColor Yellow
        Write-Host "Note: During installation, you'll be prompted to set a password for the 'postgres' user." -ForegroundColor Cyan
        Write-Host "Remember this password - you'll need it for the .env.local file!" -ForegroundColor Cyan
        Write-Host ""
        
        try {
            winget install PostgreSQL.PostgreSQL.16 --accept-package-agreements --accept-source-agreements
            Write-Host ""
            Write-Host "[OK] PostgreSQL installed successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "IMPORTANT: Please note the password you set during installation." -ForegroundColor Yellow
            Write-Host "You'll need to add it to your .env.local file." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "The PostgreSQL service should start automatically." -ForegroundColor Cyan
            Write-Host "If not, you may need to start it manually or restart your computer." -ForegroundColor Cyan
        } catch {
            Write-Host "[ERROR] Installation failed: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "You can also install PostgreSQL manually:" -ForegroundColor Yellow
            Write-Host "1. Download from: https://www.postgresql.org/download/windows/" -ForegroundColor White
            Write-Host "2. Or use: winget install PostgreSQL.PostgreSQL.16" -ForegroundColor White
            exit 1
        }
    } else {
        Write-Host ""
        Write-Host "Installation cancelled." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "To install PostgreSQL manually:" -ForegroundColor Cyan
        Write-Host "1. Download from: https://www.postgresql.org/download/windows/" -ForegroundColor White
        Write-Host "2. Or use: winget install PostgreSQL.PostgreSQL.16" -ForegroundColor White
        Write-Host "3. Or use Docker: docker compose up -d" -ForegroundColor White
        exit 1
    }
}

# Wait a moment for service to be ready
Start-Sleep -Seconds 3

# Check if .env.local exists
Write-Host ""
Write-Host "Checking for .env.local file..." -ForegroundColor Cyan
if (Test-Path ".env.local") {
    Write-Host "[OK] .env.local file exists" -ForegroundColor Green
} else {
    Write-Host "[WARNING] .env.local file not found!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Creating .env.local file with default values..." -ForegroundColor Cyan
    Write-Host ""
    
    $envContent = @"
# Database Configuration
# Update DB_PASSWORD with your PostgreSQL password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=farmsight
DB_USER=postgres
DB_PASSWORD=postgres
DB_SSL=false

# Authentication
# Generate a secure random string for production
JWT_SECRET=your_jwt_secret_key_here_change_in_production

# External APIs (optional - for real-time data)
# Uncomment and add your API keys when needed
# OPENWEATHERMAP_API_KEY=your_key_here
# WEATHERAPI_KEY=your_key_here
# GOOGLE_EARTH_ENGINE_SERVICE_ACCOUNT_KEY=path/to/service-account-key.json
# GOOGLE_CLOUD_PROJECT_ID=your-gcp-project-id
# TAVILY_API_KEY=your_tavily_key_here

# File Uploads
UPLOAD_DIR=public/uploads
"@
    
    try {
        $envContent | Out-File -FilePath ".env.local" -Encoding utf8
        Write-Host "[OK] Created .env.local file" -ForegroundColor Green
        Write-Host ""
        Write-Host "IMPORTANT: Please edit .env.local and update DB_PASSWORD with your PostgreSQL password!" -ForegroundColor Yellow
    } catch {
        Write-Host "[ERROR] Could not create .env.local file: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please create .env.local manually with the following content:" -ForegroundColor Yellow
        Write-Host $envContent
    }
}

# Test PostgreSQL connection
Write-Host ""
Write-Host "Testing PostgreSQL connection..." -ForegroundColor Cyan

# Try to read password from .env.local if it exists
$dbPassword = "postgres"  # default
if (Test-Path ".env.local") {
    $envContent = Get-Content ".env.local" -Raw
    if ($envContent -match "DB_PASSWORD=(.+)") {
        $dbPassword = $matches[1].Trim()
    }
}

$env:PGPASSWORD = $dbPassword
try {
    $result = & psql -h localhost -U postgres -d postgres -c "SELECT version();" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] PostgreSQL connection successful!" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Connection test failed. This might be normal if:" -ForegroundColor Yellow
        Write-Host "  - PostgreSQL was just installed (may need a restart)" -ForegroundColor White
        Write-Host "  - The password in .env.local doesn't match" -ForegroundColor White
        Write-Host "  - PostgreSQL service needs to be started manually" -ForegroundColor White
    }
} catch {
    Write-Host "[WARNING] Could not test connection. psql may not be in PATH." -ForegroundColor Yellow
    Write-Host "  This is okay - the connection will be tested when you run the app." -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Edit .env.local and update DB_PASSWORD with your PostgreSQL password" -ForegroundColor White
Write-Host "2. Run database migrations:" -ForegroundColor White
Write-Host "   npm run migrate" -ForegroundColor Yellow
Write-Host ""
Write-Host "Or if you prefer to set up the database manually:" -ForegroundColor Cyan
Write-Host "   psql -U postgres" -ForegroundColor Yellow
Write-Host "   CREATE DATABASE farmsight;" -ForegroundColor Yellow
Write-Host "   \q" -ForegroundColor Yellow
Write-Host "   npm run migrate" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Start your development server:" -ForegroundColor White
Write-Host "   npm run dev" -ForegroundColor Yellow
Write-Host ""

