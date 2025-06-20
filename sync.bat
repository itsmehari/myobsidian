@echo off
:: Quick Obsidian Vault Sync
:: Usage: sync.bat [pull|push|status]

cd /d "C:\Users\Admin\Documents\Obsidian Vault"

if "%1"=="pull" (
    echo Pulling latest changes...
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -PullOnly
) else if "%1"=="push" (
    echo Pushing local changes...
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" -PushOnly
) else if "%1"=="status" (
    echo Checking sync status...
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1"
) else (
    echo Starting interactive sync...
    powershell -ExecutionPolicy Bypass -File "sync-vault.ps1"
)

pause

