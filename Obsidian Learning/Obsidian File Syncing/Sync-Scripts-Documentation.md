# Sync Scripts Documentation
**Created**: 2025-06-20  
**Tags**: #sync #scripts #powershell #automation #git  
**Related**: [[AI-Obsidian-Setup]] | [[Data-Loss-Prevention-Guide]]  
**Status**: Complete

---

## 📜 Overview

Technical documentation for the enhanced Obsidian vault synchronization system with data loss prevention and multi-device support.

## 🗂️ Script Components

### 1. **sync-vault.ps1** - Main PowerShell Script
- **Location**: `C:\Users\Admin\Documents\Obsidian Vault\sync-vault.ps1`
- **Lines**: 535 lines of code
- **Features**: Enhanced conflict resolution, backup system, device tracking

### 2. **sync.bat** - Batch Wrapper
- **Location**: `C:\Users\Admin\Documents\Obsidian Vault\sync.bat`
- **Purpose**: Quick access commands with parameter support
- **Features**: User-friendly interface, command validation

### 3. **ai-config.json** - Configuration File
- **Location**: `C:\Users\Admin\Documents\Obsidian Vault\ai-config.json`
- **Purpose**: System configuration and integration settings

## ⚙️ PowerShell Script Features

### **Parameters**
```powershell
param(
    [switch]$Force,           # Force sync ignoring conflicts
    [switch]$PullOnly,        # Only pull remote changes
    [switch]$PushOnly,        # Only push local changes
    [switch]$BackupOnly,      # Create backup only
    [switch]$SkipBackup,      # Skip backup creation
    [string]$Message,         # Custom commit message
    [string]$ConflictStrategy # backup, merge, abort
)
```

### **Configuration Variables**
```powershell
$VaultPath = "C:\Users\Admin\Documents\Obsidian Vault"
$RemoteRepo = "https://github.com/itsmehari/myobsidian.git"
$BackupPath = "C:\Users\Admin\Documents\Obsidian-Backups"
$ConflictPath = Join-Path $VaultPath "conflicts"
$LockFile = Join-Path $VaultPath ".sync-lock"
$DeviceId = "$env:COMPUTERNAME-$env:USERNAME"
```

### **Core Functions**

#### **New-VaultBackup**
```powershell
function New-VaultBackup {
    param([string]$BackupType = "auto")
    
    # Creates timestamped backups with device identification
    # Automatic cleanup of old backups (keeps last 10)
    # Returns backup path for verification
}
```

#### **Test-SyncConflicts**
```powershell
function Test-SyncConflicts {
    # Analyzes git status for potential conflicts
    # Returns conflict information object
    # Checks: local changes, remote changes, conflict risk
}
```

#### **Resolve-SyncConflicts**
```powershell
function Resolve-SyncConflicts {
    param($ConflictInfo)
    
    # Implements multiple conflict resolution strategies:
    # - backup: Save local changes, reset to remote
    # - merge: Attempt automatic merge
    # - abort: Stop sync for manual resolution
}
```

#### **Lock-Sync / Unlock-Sync**
```powershell
# Prevents race conditions between devices
# 10-minute lock timeout with automatic cleanup
# Device-aware lock management
```

### **Enhanced Main Sync Function**
The `Sync-Vault` function implements:
1. **Pre-sync backup** (unless skipped)
2. **Conflict detection** before any git operations
3. **Safe pull strategies** (rebase for local changes)
4. **File validation** before commit
5. **Enhanced commit messages** with device info
6. **Post-sync verification** and backup

## 🔧 Batch Script Commands

### **Basic Commands**
```bash
sync.bat pull              # Pull latest changes only
sync.bat push              # Push local changes only  
sync.bat status            # Show sync status
sync.bat backup            # Create manual backup
sync.bat help              # Show help information
```

### **Advanced Commands**
```bash
sync.bat safe "message"    # Use backup conflict strategy
sync.bat merge "message"   # Use merge conflict strategy
sync.bat force "message"   # Force sync (dangerous)
```

### **Command Examples**
```bash
# Daily routine
sync.bat safe "Daily work update"

# Quick status check
sync.bat status

# Emergency backup
sync.bat backup

# Pull latest from team
sync.bat pull

# Push with custom message
sync.bat push "Updated analysis documents"
```

## 📊 Conflict Resolution Strategies

### **1. Backup Strategy** (Default - Safest)
- **Trigger**: `sync.bat safe` or `-ConflictStrategy "backup"`
- **Process**:
  1. Detect conflicts before they occur
  2. Create full vault backup
  3. Save local changes to `conflicts/local-changes-[timestamp]-[device]/`
  4. Reset repository to remote state
  5. **Result**: Zero data loss, manual merge required

### **2. Merge Strategy** (Advanced)
- **Trigger**: `sync.bat merge` or `-ConflictStrategy "merge"`
- **Process**:
  1. Attempt automatic git merge
  2. If successful: proceed with sync
  3. If conflicts: save conflict files, abort merge
  4. **Result**: Automatic resolution when possible

### **3. Abort Strategy** (Conservative)
- **Trigger**: `-ConflictStrategy "abort"`
- **Process**:
  1. Detect conflicts
  2. Stop all operations
  3. Require manual intervention
  4. **Result**: Maximum safety, user decision required

## 🔒 Safety Mechanisms

### **Sync Locking**
```json
// .sync-lock file structure
{
  "Device": "DESKTOP-ABC123-Admin",
  "Timestamp": "2025-06-20 14:30:00",
  "ProcessId": 12345
}
```

### **Backup Retention**
- **Location**: `C:\Users\Admin\Documents\Obsidian-Backups\`
- **Naming**: `vault-backup-[type]-[timestamp]-[device]`
- **Types**: pre-sync, post-sync, conflict, error, manual
- **Retention**: Last 10 backups per type (automatic cleanup)

### **Device Identification**
- **Format**: `$env:COMPUTERNAME-$env:USERNAME`
- **Usage**: Commit messages, lock files, backup names, conflict resolution
- **Benefits**: Multi-device troubleshooting, audit trail

## 📝 Logging System

### **Log File**: `sync-log.txt`
```
[2025-06-20 14:30:15] [DESKTOP-ABC123-Admin] [INFO] Starting sync...
[2025-06-20 14:30:16] [DESKTOP-ABC123-Admin] [SUCCESS] Backup created
[2025-06-20 14:30:18] [DESKTOP-ABC123-Admin] [WARN] Conflict detected
[2025-06-20 14:30:20] [DESKTOP-ABC123-Admin] [SUCCESS] Sync completed
```

### **Log Levels**
- **INFO**: Normal operations
- **WARN**: Potential issues, non-critical
- **ERROR**: Failed operations
- **SUCCESS**: Completed operations

## 🔄 Sync Flow Diagram

```
┌─────────────┐
│ Sync Start  │
└─────┬───────┘
      │
      ▼
┌─────────────┐
│ Acquire     │
│ Lock        │
└─────┬───────┘
      │
      ▼
┌─────────────┐
│ Create      │
│ Pre-Backup  │
└─────┬───────┘
      │
      ▼
┌─────────────┐
│ Test        │
│ Conflicts   │
└─────┬───────┘
      │
   ┌──▼──┐
   │ Has │
   │ Con?│
   └──┬──┘
      │Yes
      ▼
┌─────────────┐    ┌─────────────┐
│ Resolve     │───▶│ Backup      │
│ Conflicts   │    │ Strategy    │
└─────┬───────┘    └─────────────┘
      │No
      ▼
┌─────────────┐
│ Pull/Push   │
│ Changes     │
└─────┬───────┘
      │
      ▼
┌─────────────┐
│ Create      │
│ Post-Backup │
└─────┬───────┘
      │
      ▼
┌─────────────┐
│ Release     │
│ Lock        │
└─────────────┘
```

## 🧪 Testing Commands

### **Verify Script Functionality**
```powershell
# Test backup system
.\sync-vault.ps1 -BackupOnly

# Test pull only
.\sync-vault.ps1 -PullOnly

# Test conflict detection
.\sync-vault.ps1 -ConflictStrategy "backup"

# Test with custom message
.\sync-vault.ps1 -Message "Test sync from PowerShell"
```

### **Validate Batch Interface**
```bash
sync.bat help
sync.bat status
sync.bat backup
sync.bat safe "Test message"
```

## 🔧 Maintenance Tasks

### **Regular Checks**
```powershell
# Check backup directory size
Get-ChildItem "C:\Users\Admin\Documents\Obsidian-Backups" -Recurse | Measure-Object -Property Length -Sum

# Verify git repository health
cd "C:\Users\Admin\Documents\Obsidian Vault"
git fsck --full

# Check sync log for errors
Select-String -Path "sync-log.txt" -Pattern "ERROR" | Select-Object -Last 10
```

### **Performance Optimization**
- **Backup cleanup**: Automatic (keeps last 10)
- **Log rotation**: Manual cleanup recommended monthly
- **Git optimization**: `git gc` recommended quarterly

## 🔗 Related Documentation

- [[Data-Loss-Prevention-Guide]] - Safety procedures and emergency recovery
- [[AI-Obsidian-Setup]] - System overview and quick start
- [[Git-Operations-Guide]] - Advanced git workflows
- [[Troubleshooting-Common-Issues]] - Problem resolution

---

**Script Version**: 2.0 (Enhanced with Data Protection)  
**Last Updated**: June 20, 2025  
**Testing Status**: ✅ Verified and Functional  
**Compatibility**: PowerShell 5.1+, Windows Batch

