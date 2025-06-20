# Obsidian Vault Auto-Sync Script
# Created: 2025-06-20
# Purpose: Automatically sync Obsidian vault with GitHub repository
# Repository: https://github.com/itsmehari/myobsidian

param(
    [switch]$Force,
    [switch]$PullOnly,
    [switch]$PushOnly,
    [string]$Message = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

# Configuration
$VaultPath = "C:\Users\Admin\Documents\Obsidian Vault"
$RemoteRepo = "https://github.com/itsmehari/myobsidian.git"
$LogFile = Join-Path $VaultPath "sync-log.txt"

# Function to log messages
function Write-Log {
    param($Message, $Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Type] $Message"
    Write-Host $logEntry
    Add-Content -Path $LogFile -Value $logEntry
}

# Function to check git status
function Get-GitStatus {
    try {
        $status = git status --porcelain 2>$null
        return $status
    } catch {
        return $null
    }
}

# Main sync function
function Sync-Vault {
    Write-Log "Starting Obsidian vault synchronization..."
    
    # Ensure we're in the vault directory
    if (-not (Test-Path $VaultPath)) {
        Write-Log "Vault path not found: $VaultPath" "ERROR"
        return $false
    }
    
    Push-Location $VaultPath
    
    try {
        # Check if git repository
        $gitCheck = git rev-parse --git-dir 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Log "Not a git repository. Initializing..." "WARN"
            git init
            git remote add origin $RemoteRepo
        }
        
        # Pull latest changes (unless PushOnly)
        if (-not $PushOnly) {
            Write-Log "Pulling latest changes from remote..."
            git fetch origin
            
            # Check if there are remote changes
            $behind = git rev-list --count HEAD..origin/master 2>$null
            if ($behind -and $behind -gt 0) {
                Write-Log "Found $behind commits behind. Pulling changes..."
                $pullResult = git pull origin master 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Log "Successfully pulled remote changes"
                } else {
                    Write-Log "Pull failed: $pullResult" "ERROR"
                    if (-not $Force) {
                        return $false
                    }
                }
            } else {
                Write-Log "Local repository is up to date with remote"
            }
        }
        
        # Check for local changes (unless PullOnly)
        if (-not $PullOnly) {
            $changes = Get-GitStatus
            if ($changes) {
                Write-Log "Found local changes:"
                $changes | ForEach-Object { Write-Log "  $_" }
                
                # Add all changes
                git add .
                
                # Commit changes
                $commitResult = git commit -m $Message 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Log "Successfully committed local changes"
                    
                    # Push to remote
                    Write-Log "Pushing changes to remote repository..."
                    $pushResult = git push origin master 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Log "Successfully pushed to remote repository"
                    } else {
                        Write-Log "Push failed: $pushResult" "ERROR"
                        return $false
                    }
                } else {
                    Write-Log "Commit failed: $commitResult" "ERROR"
                    return $false
                }
            } else {
                Write-Log "No local changes to commit"
            }
        }
        
        Write-Log "Vault synchronization completed successfully!" "SUCCESS"
        return $true
        
    } catch {
        Write-Log "Sync failed with error: $($_.Exception.Message)" "ERROR"
        return $false
    } finally {
        Pop-Location
    }
}

# Function to show sync status
function Show-SyncStatus {
    Push-Location $VaultPath
    try {
        Write-Host "`n=== Obsidian Vault Sync Status ===" -ForegroundColor Cyan
        Write-Host "Vault Path: $VaultPath" -ForegroundColor Yellow
        Write-Host "Remote Repo: $RemoteRepo" -ForegroundColor Yellow
        
        # Local status
        $changes = Get-GitStatus
        if ($changes) {
            Write-Host "`nLocal Changes:" -ForegroundColor Red
            $changes | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
        } else {
            Write-Host "`nLocal Status: Clean (no changes)" -ForegroundColor Green
        }
        
        # Remote status
        git fetch origin 2>$null
        $ahead = git rev-list --count origin/master..HEAD 2>$null
        $behind = git rev-list --count HEAD..origin/master 2>$null
        
        if ($ahead -gt 0) {
            Write-Host "Remote Status: $ahead commits ahead of remote" -ForegroundColor Yellow
        } elseif ($behind -gt 0) {
            Write-Host "Remote Status: $behind commits behind remote" -ForegroundColor Red
        } else {
            Write-Host "Remote Status: Up to date" -ForegroundColor Green
        }
        
        # Last sync info
        if (Test-Path $LogFile) {
            $lastSync = Get-Content $LogFile | Where-Object { $_ -match "SUCCESS" } | Select-Object -Last 1
            if ($lastSync) {
                Write-Host "Last Successful Sync: $($lastSync -replace '.*\[(.*?)\].*', '$1')" -ForegroundColor Cyan
            }
        }
        
    } finally {
        Pop-Location
    }
}

# Script execution
Write-Host "🔄 Obsidian Vault Synchronization Tool" -ForegroundColor Cyan
Write-Host "Repository: $RemoteRepo" -ForegroundColor Yellow

# Show status if no parameters
if (-not $PullOnly -and -not $PushOnly -and -not $Force) {
    Show-SyncStatus
    Write-Host "`nOptions:" -ForegroundColor White
    Write-Host "  -PullOnly    : Only pull remote changes" -ForegroundColor Gray
    Write-Host "  -PushOnly    : Only push local changes" -ForegroundColor Gray
    Write-Host "  -Force       : Force sync even on conflicts" -ForegroundColor Gray
    Write-Host "  -Message     : Custom commit message" -ForegroundColor Gray
    Write-Host "`nRun with parameters to perform sync, or just 'sync' for interactive mode" -ForegroundColor White
}

# Perform sync if parameters provided
if ($PullOnly -or $PushOnly -or $Force) {
    $result = Sync-Vault
    if ($result) {
        Write-Host "`n✅ Synchronization completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "`n❌ Synchronization failed. Check the log for details." -ForegroundColor Red
    }
    Show-SyncStatus
}

# Interactive mode
if (-not $PullOnly -and -not $PushOnly -and -not $Force) {
    Write-Host "`nDo you want to sync now? (y/N): " -ForegroundColor Yellow -NoNewline
    $response = Read-Host
    if ($response -eq 'y' -or $response -eq 'Y') {
        $result = Sync-Vault
        if ($result) {
            Write-Host "`n✅ Synchronization completed successfully!" -ForegroundColor Green
        } else {
            Write-Host "`n❌ Synchronization failed. Check the log for details." -ForegroundColor Red
        }
    }
}

