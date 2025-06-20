# Obsidian Vault Auto-Sync Script with Data Loss Prevention
# Created: 2025-06-20
# Enhanced: 2025-06-20 - Added conflict resolution and data protection
# Purpose: Safely sync Obsidian vault with GitHub repository across multiple devices
# Repository: https://github.com/itsmehari/myobsidian

param(
    [switch]$Force,
    [switch]$PullOnly,
    [switch]$PushOnly,
    [switch]$BackupOnly,
    [switch]$SkipBackup,
    [string]$Message = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm') from $env:COMPUTERNAME",
    [string]$ConflictStrategy = "backup" # backup, merge, abort
)

# Configuration
$VaultPath = "C:\Users\Admin\Documents\Obsidian Vault"
$RemoteRepo = "https://github.com/itsmehari/myobsidian.git"
$LogFile = Join-Path $VaultPath "sync-log.txt"
$BackupPath = "C:\Users\Admin\Documents\Obsidian-Backups"
$ConflictPath = Join-Path $VaultPath "conflicts"
$LockFile = Join-Path $VaultPath ".sync-lock"
$DeviceId = "$env:COMPUTERNAME-$env:USERNAME"

# Function to log messages
function Write-Log {
    param($Message, $Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$DeviceId] [$Type] $Message"
    Write-Host $logEntry
    Add-Content -Path $LogFile -Value $logEntry
}

# Function to create timestamped backup
function New-VaultBackup {
    param([string]$BackupType = "auto")
    
    if ($SkipBackup) {
        Write-Log "Backup skipped as requested" "WARN"
        return $null
    }
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $backupName = "vault-backup-$BackupType-$timestamp-$DeviceId"
    $fullBackupPath = Join-Path $BackupPath $backupName
    
    try {
        if (-not (Test-Path $BackupPath)) {
            New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null
        }
        
        Write-Log "Creating backup: $backupName"
        Copy-Item -Path $VaultPath -Destination $fullBackupPath -Recurse -Force
        
        # Cleanup old backups (keep last 10)
        $oldBackups = Get-ChildItem $BackupPath | Where-Object { $_.Name -like "vault-backup-*" } | Sort-Object CreationTime -Descending | Select-Object -Skip 10
        foreach ($backup in $oldBackups) {
            Remove-Item $backup.FullName -Recurse -Force
            Write-Log "Cleaned up old backup: $($backup.Name)"
        }
        
        Write-Log "Backup created successfully: $backupName" "SUCCESS"
        return $fullBackupPath
    }
    catch {
        Write-Log "Backup failed: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Function to check for sync conflicts
function Test-SyncConflicts {
    try {
        # Check if we're behind remote
        git fetch origin 2>$null
        $behind = git rev-list --count HEAD..origin/master 2>$null
        $ahead = git rev-list --count origin/master..HEAD 2>$null
        $localChanges = Get-GitStatus
        
        $conflictInfo = @{
            Behind = [int]$behind
            Ahead = [int]$ahead
            HasLocalChanges = ($localChanges -ne $null -and $localChanges.Count -gt 0)
            ConflictRisk = $false
        }
        
        # High conflict risk if we have local changes AND we're behind
        if ($conflictInfo.HasLocalChanges -and $conflictInfo.Behind -gt 0) {
            $conflictInfo.ConflictRisk = $true
        }
        
        return $conflictInfo
    }
    catch {
        Write-Log "Error checking conflicts: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Function to handle sync conflicts safely
function Resolve-SyncConflicts {
    param($ConflictInfo)
    
    if (-not $ConflictInfo.ConflictRisk) {
        return $true
    }
    
    Write-Log "⚠️ CONFLICT RISK DETECTED!" "WARN"
    Write-Log "Local changes: $($ConflictInfo.HasLocalChanges)" "WARN"
    Write-Log "Commits behind: $($ConflictInfo.Behind)" "WARN"
    Write-Log "Commits ahead: $($ConflictInfo.Ahead)" "WARN"
    
    # Create conflict backup
    $conflictBackup = New-VaultBackup -BackupType "conflict"
    if (-not $conflictBackup) {
        Write-Log "Cannot proceed without backup!" "ERROR"
        return $false
    }
    
    switch ($ConflictStrategy.ToLower()) {
        "backup" {
            Write-Log "Using BACKUP strategy - preserving local changes" "INFO"
            
            # Create conflicts directory
            if (-not (Test-Path $ConflictPath)) {
                New-Item -Path $ConflictPath -ItemType Directory -Force | Out-Null
            }
            
            # Save local changes with timestamp
            $localChangesPath = Join-Path $ConflictPath "local-changes-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')-$DeviceId"
            New-Item -Path $localChangesPath -ItemType Directory -Force | Out-Null
            
            # Copy conflicted files
            $changes = Get-GitStatus
            foreach ($change in $changes) {
                $fileName = $change -replace '^\s*[AMD?]\s*', ''
                if (Test-Path $fileName) {
                    $destPath = Join-Path $localChangesPath $fileName
                    $destDir = Split-Path $destPath -Parent
                    if (-not (Test-Path $destDir)) {
                        New-Item -Path $destDir -ItemType Directory -Force | Out-Null
                    }
                    Copy-Item -Path $fileName -Destination $destPath -Force
                }
            }
            
            Write-Log "Local changes backed up to: $localChangesPath" "SUCCESS"
            
            # Reset to remote state
            git reset --hard origin/master
            Write-Log "Reset to remote state" "INFO"
            
            return $true
        }
        
        "merge" {
            Write-Log "Using MERGE strategy - attempting automatic merge" "INFO"
            
            # Try to merge
            $mergeResult = git merge origin/master 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Merge successful" "SUCCESS"
                return $true
            } else {
                Write-Log "Merge failed: $mergeResult" "ERROR"
                Write-Log "Manual intervention required - check conflicts directory" "WARN"
                
                # Save merge conflict state
                $conflictFiles = git diff --name-only --diff-filter=U
                foreach ($file in $conflictFiles) {
                    $conflictCopy = Join-Path $ConflictPath "merge-conflict-$file-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"
                    Copy-Item -Path $file -Destination $conflictCopy -Force
                }
                
                return $false
            }
        }
        
        "abort" {
            Write-Log "Using ABORT strategy - stopping sync" "WARN"
            Write-Log "Manual resolution required before sync can continue" "WARN"
            return $false
        }
        
        default {
            Write-Log "Unknown conflict strategy: $ConflictStrategy" "ERROR"
            return $false
        }
    }
}

# Function to acquire sync lock
function Lock-Sync {
    if (Test-Path $LockFile) {
        $lockInfo = Get-Content $LockFile -Raw | ConvertFrom-Json
        $lockAge = (Get-Date) - [datetime]$lockInfo.Timestamp
        
        if ($lockAge.TotalMinutes -lt 10) {
            Write-Log "Sync already in progress by $($lockInfo.Device) since $($lockInfo.Timestamp)" "WARN"
            return $false
        } else {
            Write-Log "Stale lock detected, removing..." "WARN"
            Remove-Item $LockFile -Force
        }
    }
    
    $lockData = @{
        Device = $DeviceId
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        ProcessId = $PID
    }
    
    $lockData | ConvertTo-Json | Set-Content $LockFile
    Write-Log "Sync lock acquired by $DeviceId"
    return $true
}

# Function to release sync lock
function Unlock-Sync {
    if (Test-Path $LockFile) {
        Remove-Item $LockFile -Force
        Write-Log "Sync lock released by $DeviceId"
    }
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

# Enhanced main sync function with conflict detection
function Sync-Vault {
    Write-Log "Starting Obsidian vault synchronization..."
    
    # Handle backup-only mode
    if ($BackupOnly) {
        $backup = New-VaultBackup -BackupType "manual"
        if ($backup) {
            Write-Log "Manual backup completed: $backup" "SUCCESS"
            return $true
        } else {
            Write-Log "Manual backup failed" "ERROR"
            return $false
        }
    }
    
    # Acquire sync lock
    if (-not (Lock-Sync)) {
        Write-Log "Cannot acquire sync lock - another sync may be in progress" "ERROR"
        return $false
    }
    
    try {
        # Ensure we're in the vault directory
        if (-not (Test-Path $VaultPath)) {
            Write-Log "Vault path not found: $VaultPath" "ERROR"
            return $false
        }
        
        Push-Location $VaultPath
        
        try {
            # Create pre-sync backup (unless skipped)
            $preBackup = New-VaultBackup -BackupType "pre-sync"
            if (-not $preBackup -and -not $SkipBackup) {
                Write-Log "Pre-sync backup failed - aborting for safety" "ERROR"
                return $false
            }
            
            # Check if git repository
            $gitCheck = git rev-parse --git-dir 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Not a git repository. Initializing..." "WARN"
                git init
                git remote add origin $RemoteRepo
                git branch -M master
            }
            
            # Test repository connectivity
            Write-Log "Testing repository connectivity..."
            $remoteTest = git ls-remote --heads origin 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Cannot connect to remote repository: $remoteTest" "ERROR"
                return $false
            }
            
            # Check for conflicts BEFORE any operations
            if (-not $Force) {
                Write-Log "Checking for potential conflicts..."
                $conflictInfo = Test-SyncConflicts
                
                if ($conflictInfo -and $conflictInfo.ConflictRisk) {
                    Write-Log "⚠️ POTENTIAL DATA LOSS DETECTED!" "WARN"
                    
                    if (-not (Resolve-SyncConflicts -ConflictInfo $conflictInfo)) {
                        Write-Log "Conflict resolution failed - sync aborted" "ERROR"
                        return $false
                    }
                }
            }
            
            # Pull latest changes (unless PushOnly)
            if (-not $PushOnly) {
                Write-Log "Pulling latest changes from remote..."
                git fetch origin
                
                # Check if there are remote changes
                $behind = git rev-list --count HEAD..origin/master 2>$null
                if ($behind -and $behind -gt 0) {
                    Write-Log "Found $behind commits behind. Pulling changes..."
                    
                    # Different pull strategies based on local changes
                    $localChanges = Get-GitStatus
                    if ($localChanges -and $localChanges.Count -gt 0) {
                        Write-Log "Local changes detected - using rebase strategy"
                        $pullResult = git pull --rebase origin master 2>&1
                    } else {
                        $pullResult = git pull origin master 2>&1
                    }
                    
                    if ($LASTEXITCODE -eq 0) {
                        Write-Log "Successfully pulled remote changes"
                    } else {
                        Write-Log "Pull failed: $pullResult" "ERROR"
                        
                        # Try to recover from failed pull
                        if ($pullResult -match "CONFLICT") {
                            Write-Log "Merge conflicts detected - creating conflict backup"
                            $conflictBackup = New-VaultBackup -BackupType "conflict"
                            Write-Log "Conflict backup created: $conflictBackup"
                            
                            # Reset to known good state
                            git merge --abort 2>$null
                            git rebase --abort 2>$null
                            git reset --hard HEAD
                            
                            Write-Log "Repository reset to stable state - manual merge required" "WARN"
                        }
                        
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
                    
                    # Validate files before committing
                    $invalidFiles = @()
                    foreach ($change in $changes) {
                        $fileName = $change -replace '^\s*[AMD?]\s*', ''
                        if ($fileName -match '\.(md|txt|json)$' -and (Test-Path $fileName)) {
                            # Basic validation for text files
                            $content = Get-Content $fileName -Raw -ErrorAction SilentlyContinue
                            if ($content -and $content.Length -eq 0) {
                                $invalidFiles += $fileName
                                Write-Log "Warning: Empty file detected: $fileName" "WARN"
                            }
                        }
                    }
                    
                    if ($invalidFiles.Count -gt 0 -and -not $Force) {
                        Write-Log "Empty files detected - use -Force to commit anyway" "WARN"
                        return $false
                    }
                    
                    # Add all changes
                    git add .
                    
                    # Commit changes with enhanced message
                    $enhancedMessage = "$Message`n`nDevice: $DeviceId`nFiles changed: $($changes.Count)`nTimestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
                    
                    $commitResult = git commit -m $enhancedMessage 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Log "Successfully committed local changes"
                        
                        # Final check before push
                        git fetch origin
                        $behindAfterCommit = git rev-list --count HEAD..origin/master 2>$null
                        if ($behindAfterCommit -gt 0) {
                            Write-Log "Remote has new commits - pulling before push"
                            $prePushPull = git pull --rebase origin master 2>&1
                            if ($LASTEXITCODE -ne 0) {
                                Write-Log "Pre-push pull failed: $prePushPull" "ERROR"
                                return $false
                            }
                        }
                        
                        # Push to remote
                        Write-Log "Pushing changes to remote repository..."
                        $pushResult = git push origin master 2>&1
                        if ($LASTEXITCODE -eq 0) {
                            Write-Log "Successfully pushed to remote repository"
                            
                            # Create post-sync backup
                            $postBackup = New-VaultBackup -BackupType "post-sync"
                            Write-Log "Post-sync backup created: $postBackup"
                            
                        } else {
                            Write-Log "Push failed: $pushResult" "ERROR"
                            
                            # Create failed-push backup
                            $failedBackup = New-VaultBackup -BackupType "failed-push"
                            Write-Log "Failed-push backup created: $failedBackup"
                            
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
            
            # Create error backup
            $errorBackup = New-VaultBackup -BackupType "error"
            Write-Log "Error backup created: $errorBackup"
            
            return $false
        } finally {
            Pop-Location
        }
        
    } finally {
        # Always release the sync lock
        Unlock-Sync
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

