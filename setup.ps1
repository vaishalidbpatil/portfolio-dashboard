Write-Host "=== Portfolio Dashboard Setup ===" -ForegroundColor Cyan

# Step 1 - Tear down
Write-Host "`nTearing down existing containers..." -ForegroundColor Yellow
docker compose down --remove-orphans
if ($LASTEXITCODE -ne 0) {
    Write-Host "docker compose down failed." -ForegroundColor Red
    exit 1
}

# Step 2 - Check portfolio-service is reachable (dashboard needs API + Auth)
Write-Host "`nChecking portfolio-service is up (API on port 8080)..." -ForegroundColor Yellow
$retries = 5
$apiReady = $false
do {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/health/live" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) { $apiReady = $true }
    } catch {}
    if (-not $apiReady) { Start-Sleep -Seconds 2 }
    $retries--
} while (-not $apiReady -and $retries -gt 0)

if (-not $apiReady) {
    Write-Host "WARNING: portfolio-service API is not reachable on port 8080." -ForegroundColor Yellow
    Write-Host "         Run setup.ps1 from the portfolio-service repo first." -ForegroundColor Yellow
    Write-Host "         Continuing anyway — dashboard container will still start." -ForegroundColor DarkGray
} else {
    Write-Host "portfolio-service API is up." -ForegroundColor Green
}

# Step 3 - Build and start dashboard
Write-Host "`nBuilding and starting Dashboard..." -ForegroundColor Yellow
docker compose up -d --build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to start dashboard." -ForegroundColor Red
    docker compose logs
    exit 1
}

Start-Sleep -Seconds 2
docker compose logs --tail 10

Write-Host "`nSetup complete." -ForegroundColor Cyan
Write-Host "  Dashboard  : http://localhost:3000  (demo / demo123)" -ForegroundColor Green
Write-Host "  Auth (OIDC): http://localhost:5001" -ForegroundColor Green
Write-Host "  API        : http://localhost:8080/swagger" -ForegroundColor Green
