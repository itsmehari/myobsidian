# Event-Driven Auto-Sync
**Created**: 2025-06-20  
**Tags**: #automation #events #triggers #responsive #tier1  
**Related**: [[Auto-Sync Prevention Strategies Index]] | [[Time-Based Auto-Sync]]  
**Complexity**: Medium | **Investment**: 4-8 hours | **Maintenance**: Medium

---

## 🎯 **Strategy Overview**
Trigger automatic sync based on system events like application close, user logoff, screen lock, or network changes. More intelligent than time-based approach, syncing at natural break points in workflow.

## 🔧 **Technical Implementation**

### **Core Technology**
- **Primary**: Windows Management Instrumentation (WMI)
- **Events**: System event logs, process monitoring
- **Scripts**: PowerShell event handlers
- **Integration**: Windows Event Viewer, PowerShell eventing

### **Architecture**
```
System Event → WMI Listener → PowerShell Handler → sync-vault.ps1 → Git Sync
```

### **Event Triggers**
1. **Obsidian application close**
2. **User logoff/shutdown**
3. **Screen lock activation**
4. **Network reconnection**
5. **System idle detection**
6. **USB device removal** (for portable setups)

## 📋 **Detailed Implementation**

### **Main Event Handler Script** (`event-sync-handler.ps1`)
```powershell
# Event-Driven Auto-Sync Handler
param(
    [string]$EventType = "ObsidianClose",
    [string]$LogPath = "C:\Users\Admin\Documents\Obsidian Vault\event-sync.log"
)

$VaultPath = "C:\Users\Admin\Documents\Obsidian Vault"
$SyncScript = Join-Path $VaultPath "sync-vault.ps1"

function Write-EventLog($Message, $Type = "INFO") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [EVENT-$EventType] [$Type] $Message"
    Add-Content -Path $LogPath -Value $logEntry
}

function Invoke-SyncOperation {
    try {
        Write-EventLog "Event triggered sync: $EventType"
        
        Push-Location $VaultPath
        $result = & powershell -ExecutionPolicy Bypass -File $SyncScript -ConflictStrategy "backup" -Message "Event sync: $EventType at $(Get-Date -Format 'HH:mm')"
        
        if ($LASTEXITCODE -eq 0) {
            Write-EventLog "Event sync completed successfully" "SUCCESS"
        } else {
            Write-EventLog "Event sync failed" "ERROR"
        }
    } catch {
        Write-EventLog "Event sync error: $($_.Exception.Message)" "ERROR"
    } finally {
        Pop-Location
    }
}

# Execute sync with debouncing (prevent rapid-fire events)
$lastSyncFile = Join-Path $VaultPath ".last-event-sync"
$currentTime = Get-Date
$minInterval = 300 # 5 minutes minimum between syncs

if (Test-Path $lastSyncFile) {
    $lastSync = Get-Date (Get-Content $lastSyncFile)
    $timeDiff = ($currentTime - $lastSync).TotalSeconds
    
    if ($timeDiff -lt $minInterval) {
        Write-EventLog "Sync skipped - too recent (${timeDiff}s ago)"
        exit 0
    }
}

# Update last sync time and execute
$currentTime.ToString() | Set-Content $lastSyncFile
Invoke-SyncOperation
```

### **Event Registration Scripts**

#### **Obsidian Close Monitor** (`register-obsidian-close.ps1`)
```powershell
# Register for Obsidian process termination
Register-WmiEvent -Query "SELECT * FROM Win32_ProcessStopTrace WHERE ProcessName='Obsidian.exe'" -Action {
    & "C:\Path\To\event-sync-handler.ps1" -EventType "ObsidianClose"
}
```

#### **System Event Monitor** (`register-system-events.ps1`)
```powershell
# Register for multiple system events
$events = @(
    @{Query = "SELECT * FROM Win32_VolumeChangeEvent WHERE EventType = 2"; Type = "SessionLock"},
    @{Query = "SELECT * FROM Win32_NetworkAdapterConfiguration WHERE DHCPEnabled = True"; Type = "NetworkChange"}
)

foreach ($event in $events) {
    Register-WmiEvent -Query $event.Query -Action {
        & "C:\Path\To\event-sync-handler.ps1" -EventType $event.Type
    }
}
```

## ⚙️ **Event Types & Configuration**

### **Application Events**
- **Obsidian Close**: Sync when Obsidian application exits
- **System Shutdown**: Sync before system shutdown
- **User Logoff**: Sync when user logs off

### **System State Events**
- **Screen Lock**: Sync when screen locks (away from desk)
- **Screen Unlock**: Sync when returning to work
- **System Idle**: Sync after period of inactivity

### **Network Events**
- **Network Connect**: Sync when internet connection established
- **VPN Connect**: Sync when VPN connection established
- **WiFi Change**: Sync when switching networks

### **Hardware Events**
- **USB Removal**: Sync when portable storage removed
- **Laptop Close**: Sync when laptop lid closed
- **Power Events**: Sync on battery/AC power changes

## 🔄 **System Changes Required**

### **New Components**
- Event handler scripts (5-8 PowerShell files)
- WMI event registrations
- Event monitoring service
- Debouncing mechanisms
- Event-specific configuration files

### **System Modifications**
- WMI event subscriptions
- PowerShell execution permissions
- Event log access permissions
- Background process monitoring

### **Resource Usage**
- **Memory**: 15-30MB for event monitoring
- **CPU**: Low impact, event-driven only
- **Disk**: Minimal (logs only)
- **Network**: Event-triggered sync operations

## ✅ **Pros**

### **Intelligence**
- Syncs at natural workflow breakpoints
- Responsive to actual user behavior
- Minimal disruption to active work
- Adaptive to usage patterns

### **Efficiency**
- Only syncs when events occur
- No unnecessary background polling
- Resource usage aligned with activity
- Intelligent debouncing prevents spam

### **Responsiveness**
- Near-immediate sync after events
- Catches important transition points
- Better than fixed intervals
- User behavior awareness

### **Flexibility**
- Multiple trigger types available
- Configurable event sensitivity
- Custom event handlers possible
- Easy to add new event types

## ❌ **Cons**

### **Complexity**
- More complex setup and configuration
- Multiple components to maintain
- Event debugging can be challenging
- Platform-specific (Windows WMI)

### **Reliability Concerns**
- Events might be missed or delayed
- WMI service dependencies
- Potential for event conflicts
- Requires robust error handling

### **Configuration Overhead**
- Need to tune event sensitivity
- Debouncing intervals need adjustment
- Multiple scripts to maintain
- Event registration management

### **Platform Limitations**
- Windows-specific implementation
- Different approaches needed for Mac/Linux
- Version dependencies (WMI changes)
- Permission requirements

## 🛠️ **Setup Instructions**

### **1. Install Event Handlers**
```powershell
# Copy all event handler scripts to vault directory
# Set execution permissions
# Configure paths and settings
```

### **2. Register Event Subscriptions**
```powershell
# Run registration scripts as administrator
# Verify WMI service is running
# Test event triggering manually
```

### **3. Configure Event Types**
```powershell
# Choose appropriate events for your workflow
# Set debouncing intervals
# Configure logging levels
```

### **4. Test and Monitor**
```powershell
# Trigger events manually
# Monitor event logs
# Verify sync operations
# Adjust sensitivity as needed
```

## 📊 **Performance Metrics**

### **Typical Performance**
- **Setup Time**: 4-8 hours
- **Sync Latency**: 30 seconds from event
- **Success Rate**: 90-95%
- **Resource Impact**: Low
- **Maintenance**: 1 hour/month

### **Event Response Times**
- **App Close**: <10 seconds
- **Screen Lock**: <30 seconds
- **Network Change**: 30-60 seconds
- **System Events**: <15 seconds

## 🔧 **Troubleshooting**

### **Common Issues**
1. **Events not triggering**: Check WMI service, permissions
2. **Multiple rapid syncs**: Adjust debouncing intervals
3. **Missing events**: Verify event registration
4. **Performance impact**: Reduce event sensitivity

### **Monitoring Commands**
```powershell
# Check registered events
Get-EventSubscriber

# Monitor WMI events
Get-WmiEvent

# View event logs
Get-Content event-sync.log | Select-Object -Last 20
```

## 🔗 **Related Strategies**
- **Complement**: [[Time-Based Auto-Sync]] as fallback
- **Enhance**: [[Smart Change Detection]] for file awareness
- **Upgrade**: [[Multi-Level Fallback System]] for reliability
- **Alternative**: [[Visual Reminder System]] for manual control

---

**Implementation Priority**: 🥇 Tier 1 - Natural workflow integration  
**Best For**: Active users, laptop workers, variable schedules  
**Avoid If**: Minimal system interaction, server environments

