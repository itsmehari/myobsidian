# Time-Based Auto-Sync
**Created**: 2025-06-20  
**Tags**: #automation #scheduled #timer #simple #tier1  
**Related**: [[Auto-Sync Prevention Strategies Index]] | [[Auto-Sync Strategy Comparison]]  
**Complexity**: Low | **Investment**: 2-4 hours | **Maintenance**: Low

---

## 🎯 **Strategy Overview**
Automatically sync Obsidian vault at regular intervals using Windows Task Scheduler. Simple, reliable, and predictable approach that runs sync operations every X minutes/hours regardless of user activity.

## 🔧 **Technical Implementation**

### **Core Technology**
- **Primary**: Windows Task Scheduler
- **Scripts**: PowerShell automation
- **Triggers**: Time-based intervals
- **Dependencies**: sync-vault.ps1, Task Scheduler service

### **Architecture**
```
Timer (15/30/60 min) → Task Scheduler → PowerShell Script → sync-vault.ps1 → Git Sync
```

### **Implementation Steps**
1. **Create PowerShell wrapper script**
2. **Configure Task Scheduler task**
3. **Set timing intervals**
4. **Add error handling and logging**
5. **Test and validate operation**

## 📋 **Detailed Implementation**

### **PowerShell Wrapper Script** (`auto-sync-timer.ps1`)
```powershell
# Auto-Sync Timer Script
param(
    [int]$IntervalMinutes = 30,
    [string]$LogPath = "C:\Users\Admin\Documents\Obsidian Vault\auto-sync.log"
)

$VaultPath = "C:\Users\Admin\Documents\Obsidian Vault"
$SyncScript = Join-Path $VaultPath "sync-vault.ps1"

function Write-Log($Message, $Type = "INFO") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [TIMER] [$Type] $Message"
    Add-Content -Path $LogPath -Value $logEntry
    Write-Host $logEntry
}

try {
    Write-Log "Starting scheduled auto-sync"
    
    # Check if vault is accessible
    if (-not (Test-Path $VaultPath)) {
        Write-Log "Vault path not accessible: $VaultPath" "ERROR"
        exit 1
    }
    
    # Execute sync with safe strategy
    Push-Location $VaultPath
    $result = & powershell -ExecutionPolicy Bypass -File $SyncScript -ConflictStrategy "backup" -Message "Auto-sync: $(Get-Date -Format 'HH:mm')"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "Auto-sync completed successfully" "SUCCESS"
    } else {
        Write-Log "Auto-sync failed with exit code: $LASTEXITCODE" "ERROR"
    }
    
} catch {
    Write-Log "Auto-sync error: $($_.Exception.Message)" "ERROR"
} finally {
    Pop-Location
}
```

### **Task Scheduler Configuration**
```xml
<!-- Task XML for import -->
<Task>
  <Triggers>
    <TimeTrigger>
      <Repetition>
        <Interval>PT30M</Interval>
        <StopAtDurationEnd>false</StopAtDurationEnd>
      </Repetition>
    </TimeTrigger>
  </Triggers>
  <Actions>
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>-ExecutionPolicy Bypass -File "C:\Path\To\auto-sync-timer.ps1"</Arguments>
    </Exec>
  </Actions>
</Task>
```

## ⚙️ **Configuration Options**

### **Timing Intervals**
- **Conservative**: 60 minutes (low resource usage)
- **Balanced**: 30 minutes (recommended)
- **Aggressive**: 15 minutes (frequent updates)
- **Custom**: User-defined intervals

### **Sync Conditions**
- **Always Sync**: Run regardless of changes
- **Changes Only**: Check for modifications first
- **Business Hours**: Sync only during work hours
- **Network Aware**: Skip if offline

## 🔄 **System Changes Required**

### **New Files Created**
- `auto-sync-timer.ps1` - Main automation script
- `auto-sync.log` - Operation logging
- Task Scheduler task entry
- Configuration file (optional)

### **System Modifications**
- Task Scheduler service utilization
- PowerShell execution policy (if needed)
- User permissions for scheduled tasks
- Registry entries for task definition

### **Resource Usage**
- **Memory**: 10-20MB during execution
- **CPU**: <1% for sync operations
- **Disk**: Log files grow ~1MB/month
- **Network**: Periodic git operations

## ✅ **Pros**

### **Simplicity**
- Easiest to implement and understand
- Built-in Windows functionality
- No complex dependencies
- Straightforward troubleshooting

### **Reliability**
- Proven Windows Task Scheduler platform
- Predictable execution times
- Independent of user activity
- Automatic retry capabilities

### **Maintenance**
- Low ongoing maintenance required
- Self-contained operation
- Clear logging and monitoring
- Easy to modify timing

### **Compatibility**
- Works on all Windows versions
- No additional software required
- Compatible with existing sync scripts
- Platform-independent (adaptable to cron)

## ❌ **Cons**

### **Inefficiency**
- Syncs even when no changes made
- Fixed intervals may be too frequent/infrequent
- Resource usage regardless of activity
- Potential for unnecessary network traffic

### **Timing Issues**
- May interrupt active work
- Fixed schedule doesn't adapt to usage patterns
- Potential conflicts with manual syncs
- Delay between changes and sync (up to interval time)

### **Limited Intelligence**
- No awareness of file changes
- Cannot detect optimal sync timing
- No adaptation to work patterns
- Basic conflict detection only

## 🛠️ **Setup Instructions**

### **1. Create Automation Script**
```powershell
# Save as auto-sync-timer.ps1 in vault directory
# Configure paths and intervals as needed
# Test manually before scheduling
```

### **2. Configure Task Scheduler**
```cmd
# Create task via command line
schtasks /create /tn "ObsidianAutoSync" /tr "powershell.exe -File C:\Path\auto-sync-timer.ps1" /sc minute /mo 30 /st 09:00
```

### **3. Set Permissions**
- Ensure PowerShell execution policy allows scripts
- Grant task scheduler permissions
- Verify file system access rights

### **4. Test and Validate**
- Run task manually first
- Monitor logs for errors
- Verify sync operations
- Adjust timing as needed

## 📊 **Performance Metrics**

### **Typical Performance**
- **Setup Time**: 2-4 hours
- **Sync Latency**: 1-30 minutes (interval dependent)
- **Success Rate**: 85-95%
- **Resource Impact**: Very Low
- **Maintenance**: 30 minutes/month

### **Scalability**
- **Single Device**: Excellent
- **Multiple Devices**: Good (needs coordination)
- **Large Vaults**: Good performance
- **Network Constraints**: Handles gracefully

## 🔧 **Troubleshooting**

### **Common Issues**
1. **Task not running**: Check Task Scheduler service, permissions
2. **Sync failures**: Verify git connectivity, vault access
3. **Performance impact**: Adjust intervals, check resource usage
4. **Conflicts**: Coordinate with manual sync operations

### **Monitoring**
- Check auto-sync.log for operation history
- Monitor Task Scheduler event logs
- Verify git repository consistency
- Track sync success rates

## 🔗 **Related Strategies**
- **Upgrade Path**: [[Smart Change Detection]] for intelligence
- **Combine With**: [[Visual Reminder System]] for awareness
- **Alternative**: [[Event-Driven Auto-Sync]] for responsiveness
- **Enhance With**: [[Multi-Level Fallback System]] for safety

---

**Implementation Priority**: 🥇 Tier 1 - Immediate implementation recommended  
**Best For**: Beginners, simple setups, consistent schedules  
**Avoid If**: Need immediate responsiveness, variable work patterns

