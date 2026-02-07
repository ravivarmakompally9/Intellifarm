# Script to fix Next.js ChunkLoadError
Write-Host "Clearing Next.js cache and restarting..." -ForegroundColor Yellow

# Stop any running Node processes on port 3000
$port = 3000
$processes = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
if ($processes) {
    Write-Host "Stopping processes on port $port..." -ForegroundColor Yellow
    $processes | ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }
    Start-Sleep -Seconds 2
}

# Clear Next.js cache
Write-Host "Clearing .next directory..." -ForegroundColor Yellow
if (Test-Path .next) {
    Remove-Item -Recurse -Force .next
}

# Clear node_modules cache
Write-Host "Clearing node_modules cache..." -ForegroundColor Yellow
if (Test-Path node_modules\.cache) {
    Remove-Item -Recurse -Force node_modules\.cache
}

Write-Host "Cache cleared! Now run: npm run dev" -ForegroundColor Green

