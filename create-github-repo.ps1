# Script to create GitHub repository via API
# Usage: .\create-github-repo.ps1 -Token "your_github_token" -RepoName "Zenith"

param(
    [Parameter(Mandatory=$false)]
    [string]$Token,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "Zenith",
    
    [Parameter(Mandatory=$false)]
    [string]$Username = "Pgoutham47"
)

if (-not $Token) {
    Write-Host "GitHub Personal Access Token is required to create repository via API."
    Write-Host ""
    Write-Host "To get a token:"
    Write-Host "1. Go to https://github.com/settings/tokens"
    Write-Host "2. Click 'Generate new token (classic)'"
    Write-Host "3. Give it 'repo' scope"
    Write-Host "4. Copy the token and run this script with -Token parameter"
    Write-Host ""
    Write-Host "Alternatively, create the repository manually at: https://github.com/new"
    Write-Host "Repository name: $RepoName"
    Write-Host "Then run: git push -u origin master"
    exit 1
}

$headers = @{
    'Accept' = 'application/vnd.github.v3+json'
    'Authorization' = "token $Token"
    'User-Agent' = 'PowerShell'
}

$body = @{
    name = $RepoName
    private = $false
    description = "Zenith Repository"
} | ConvertTo-Json

try {
    Write-Host "Creating repository '$RepoName' on GitHub..."
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType 'application/json'
    Write-Host "Repository created successfully!" -ForegroundColor Green
    Write-Host "Repository URL: $($response.html_url)"
    Write-Host ""
    Write-Host "Now pushing code..."
    git push -u origin master
    Write-Host "Done!" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Authentication failed. Please check your token." -ForegroundColor Red
    } elseif ($_.Exception.Response.StatusCode -eq 422) {
        Write-Host "Repository might already exist or name is invalid." -ForegroundColor Yellow
    }
    exit 1
}

