@echo off
:: Enhanced Obsidian Vault Sync with Data Loss Prevention
:: Usage: sync.bat [pull|push|status|backup|force] [message] [strategy]
:: 
:: Commands:
::   pull     - Only pull remote changes
::   push     - Only push local changes  
::   status   - Show sync status
::   backup   - Create manual backup
::   force    - Force sync (ignore conflicts)
::   safe     - Use backup conflict strategy
::   merge    - Use merge conflict strategy
::
:: Examples:
::   sync.bat pull
::   sync.bat push "Updated documentation"
::   sync.bat force
::   sync.bat safe

cd /d "C:\Users\Admin\Documents\Obsidian Vault"

:: Check if PowerShell script exists
if not exist "sync-vault.ps1" (
    echo ERROR: sync-vault.ps1 not found!
    echo Please ensure the PowerShell sync script is in the vault directory.
    pause
    exit /b 1
)

:: Handle different commands
if "%1"=="pull" (
    echo 🔽 Pulling latest changes...
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -PullOnly
) else if "%1"=="push" (
    if "%2"=="" (
        echo 🔼 Pushing local changes...
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -PushOnly
    ) else (
        echo 🔼 Pushing local changes with custom message...
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -PushOnly -Message "%2"
    )
) else if "%1"=="status" (
    echo 📊 Checking sync status...
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1"
) else if "%1"=="backup" (
    echo 💾 Creating manual backup...
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -BackupOnly
) else if "%1"=="force" (
    echo ⚡ Force syncing (ignoring conflicts)...
    if "%2"=="" (
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -Force
    ) else (
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -Force -Message "%2"
    )
) else if "%1"=="safe" (
    echo 🛡️ Safe sync with backup conflict strategy...
    if "%2"=="" (
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -ConflictStrategy "backup"
    ) else (
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -ConflictStrategy "backup" -Message "%2"
    )
) else if "%1"=="merge" (
    echo 🔀 Sync with merge conflict strategy...
    if "%2"=="" (
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -ConflictStrategy "merge"
    ) else (
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -ConflictStrategy "merge" -Message "%2"
    )
) else if "%1"=="help" (
    echo.
    echo 🔄 Enhanced Obsidian Vault Sync - Data Loss Prevention
    echo.
    echo Usage: sync.bat [command] [message] [options]
    echo.
    echo Commands:
    echo   pull     - Only pull remote changes
    echo   push     - Only push local changes
    echo   status   - Show current sync status
    echo   backup   - Create manual backup only
    echo   force    - Force sync ignoring conflicts
    echo   safe     - Use backup strategy for conflicts
    echo   merge    - Use merge strategy for conflicts
    echo   help     - Show this help message
    echo.
    echo Examples:
    echo   sync.bat pull
    echo   sync.bat push "Updated documentation"
    echo   sync.bat safe "Important changes"
    echo   sync.bat backup
    echo.
    echo Safety Features:
    echo   - Automatic backups before sync
    echo   - Conflict detection and resolution
    echo   - Device identification in commits
    echo   - Sync locking to prevent race conditions
    echo.
) else (
    echo 🔄 Starting interactive sync...
    echo TIP: Use 'sync.bat help' for available commands
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1"
)

echo.
echo Press any key to continue...
pause >nul

