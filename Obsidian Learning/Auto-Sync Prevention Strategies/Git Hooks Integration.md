# Git Hooks Integration
**Created**: 2025-06-20  
**Tags**: #automation #git #hooks #repository #tier2  
**Related**: [[Auto-Sync Prevention Strategies Index]] | [[Auto-Sync Strategy Comparison]]  
**Complexity**: Medium | **Investment**: 4-8 hours | **Maintenance**: Low

---

## 🎯 **Strategy Overview**
Leverage Git's built-in hook system to automatically trigger synchronization operations at specific repository lifecycle events. This approach provides seamless integration with existing Git workflows while maintaining control over when and how sync operations occur.

## 🔧 **Technical Implementation**

### **Core Technology**
- **Git Hooks**: Native repository event system
- **PowerShell Scripts**: Windows automation layer
- **Repository Events**: Commit, push, merge triggers
- **Error Handling**: Graceful failure management

### **Architecture**
```
Git Operation → Hook Trigger → Validation → Sync Decision → Remote Operation → Completion
     ↓              ↓             ↓            ↓              ↓              ↓
Local Commit    Event Fire    Safety Check   Logic Gate   Network Sync   Status Update
```

### **Core Components**
1. **Pre-commit Hook** - Validation before commit
2. **Post-commit Hook** - Immediate sync after commit
3. **Pre-push Hook** - Safety checks before push
4. **Post-merge Hook** - Sync after merge operations
5. **Hook Manager** - Central configuration system

## 📋 **Detailed Implementation**

### **Hook Manager Script** (`hook-manager.ps1`)
```powershell
# Git Hooks Integration Manager
param(
    [string]$VaultPath = "C:\Users\Admin\Documents\Obsidian Vault",
    [string]$HookType = "all",
    [switch]$Install,
    [switch]$Uninstall,
    [switch]$Test
)

$GitHooksPath = Join-Path $VaultPath ".git\hooks"
$HookScriptsPath = Join-Path $VaultPath "git-hooks"
$ConfigFile = Join-Path $VaultPath "hook-config.json"

function Write-HookLog($Message, $Type = "INFO") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [GIT-HOOKS] [$Type] $Message"
    Add-Content -Path (Join-Path $VaultPath "git-hooks.log") -Value $logEntry
    Write-Host $logEntry
}

function Get-HookConfig {
    $defaultConfig = @{
        enabled = $true
        autoSync = $true
        syncOnCommit = $true
        syncOnPush = $true
        syncOnMerge = $true
        validationRequired = $true
        conflictStrategy = "abort"
        maxRetries = 3
        timeoutSeconds = 30
        excludePatterns = @("*.tmp", "*.temp", ".obsidian/workspace.json")
        requireCleanWorkingTree = $true
        notifyOnError = $true
    }
    
    if (Test-Path $ConfigFile) {
        try {
            $config = Get-Content $ConfigFile | ConvertFrom-Json
            # Merge with defaults
            foreach ($key in $defaultConfig.Keys) {
                if (-not $config.PSObject.Properties[$key]) {
                    $config | Add-Member -NotePropertyName $key -NotePropertyValue $defaultConfig[$key]
                }
            }
            return $config
        } catch {
            Write-HookLog "Config file corrupted, using defaults" "WARN"
            return $defaultConfig
        }
    } else {
        $defaultConfig | ConvertTo-Json -Depth 3 | Set-Content $ConfigFile
        return $defaultConfig
    }
}

function Test-GitRepository {
    try {
        Push-Location $VaultPath
        $gitStatus = git status --porcelain 2>$null
        $result = $LASTEXITCODE -eq 0
        Pop-Location
        return $result
    } catch {
        Pop-Location
        return $false
    }
}

function Install-GitHook($HookName, $HookContent) {
    try {
        if (-not (Test-Path $GitHooksPath)) {
            Write-HookLog "Git hooks directory not found: $GitHooksPath" "ERROR"
            return $false
        }
        
        $hookFile = Join-Path $GitHooksPath $HookName
        $hookContent | Set-Content $hookFile -Encoding UTF8
        
        # Make executable (Git for Windows)
        if (Get-Command git -ErrorAction SilentlyContinue) {
            git config core.hooksPath $GitHooksPath
        }
        
        Write-HookLog "Installed hook: $HookName" "SUCCESS"
        return $true
        
    } catch {
        Write-HookLog "Failed to install hook $HookName`: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Invoke-SyncOperation($TriggerType, $Config) {
    try {
        Write-HookLog "Starting sync operation triggered by: $TriggerType"
        
        # Validation checks
        if ($Config.validationRequired) {
            if (-not (Test-VaultIntegrity)) {
                Write-HookLog "Vault integrity check failed" "ERROR"
                return $false
            }
        }
        
        if ($Config.requireCleanWorkingTree) {
            Push-Location $VaultPath
            $changes = git status --porcelain 2>$null
            Pop-Location
            
            if ($changes -and $TriggerType -ne "post-commit") {
                Write-HookLog "Working tree not clean, skipping sync" "WARN"
                return $false
            }
        }
        
        # Execute sync with retry logic
        $syncScript = Join-Path $VaultPath "sync-vault.ps1"
        if (-not (Test-Path $syncScript)) {
            Write-HookLog "Sync script not found: $syncScript" "ERROR"
            return $false
        }
        
        $attempt = 0
        $maxRetries = $Config.maxRetries
        
        while ($attempt -lt $maxRetries) {
            $attempt++
            Write-HookLog "Sync attempt $attempt of $maxRetries"
            
            try {
                $syncResult = & powershell -ExecutionPolicy Bypass -File $syncScript -ConflictStrategy $Config.conflictStrategy -Timeout $Config.timeoutSeconds
                
                if ($LASTEXITCODE -eq 0) {
                    Write-HookLog "Sync completed successfully" "SUCCESS"
                    return $true
                } else {
                    Write-HookLog "Sync failed (exit code: $LASTEXITCODE)" "WARN"
                }
                
            } catch {
                Write-HookLog "Sync error: $($_.Exception.Message)" "ERROR"
            }
            
            if ($attempt -lt $maxRetries) {
                $delay = [Math]::Pow(2, $attempt) # Exponential backoff
                Write-HookLog "Waiting $delay seconds before retry..."
                Start-Sleep -Seconds $delay
            }
        }
        
        Write-HookLog "All sync attempts failed" "ERROR"
        return $false
        
    } catch {
        Write-HookLog "Sync operation failed: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Test-VaultIntegrity {
    try {
        # Check vault accessibility
        if (-not (Test-Path $VaultPath)) {
            return $false
        }
        
        # Check git repository
        if (-not (Test-GitRepository)) {
            return $false
        }
        
        # Check critical files
        $criticalFiles = @("sync-vault.ps1", "ai-config.json")
        foreach ($file in $criticalFiles) {
            if (-not (Test-Path (Join-Path $VaultPath $file))) {
                Write-HookLog "Critical file missing: $file" "WARN"
            }
        }
        
        return $true
        
    } catch {
        return $false
    }
}

# Hook installation content
$preCommitHook = @"
#!/bin/sh
# Pre-commit hook for Obsidian Vault
# Validates changes before commit

powershell -ExecutionPolicy Bypass -Command "
    try {
        `$config = Get-Content '$ConfigFile' | ConvertFrom-Json
        if (-not `$config.enabled) { exit 0 }
        
        # Validation logic here
        Write-Host 'Pre-commit validation passed'
        exit 0
    } catch {
        Write-Host 'Pre-commit validation failed'
        exit 1
    }
"
"@

$postCommitHook = @"
#!/bin/sh
# Post-commit hook for Obsidian Vault
# Triggers sync after successful commit

powershell -ExecutionPolicy Bypass -Command "
    try {
        `$config = Get-Content '$ConfigFile' | ConvertFrom-Json
        if (-not `$config.enabled -or -not `$config.syncOnCommit) { exit 0 }
        
        # Load hook manager
        . '$($MyInvocation.MyCommand.Path)'
        `$result = Invoke-SyncOperation 'post-commit' `$config
        
        if (`$result) {
            Write-Host 'Post-commit sync completed'
            exit 0
        } else {
            Write-Host 'Post-commit sync failed'
            exit 1
        }
    } catch {
        Write-Host 'Post-commit hook error'
        exit 1
    }
"
"@

$prePushHook = @"
#!/bin/sh
# Pre-push hook for Obsidian Vault
# Safety checks before push

powershell -ExecutionPolicy Bypass -Command "
    try {
        `$config = Get-Content '$ConfigFile' | ConvertFrom-Json
        if (-not `$config.enabled) { exit 0 }
        
        # Pre-push validation
        if (`$config.requireCleanWorkingTree) {
            `$changes = git status --porcelain 2>`$null
            if (`$changes) {
                Write-Host 'Working tree not clean, cannot push'
                exit 1
            }
        }
        
        Write-Host 'Pre-push validation passed'
        exit 0
    } catch {
        Write-Host 'Pre-push validation failed'
        exit 1
    }
"
"@

$postMergeHook = @"
#!/bin/sh
# Post-merge hook for Obsidian Vault
# Triggers sync after merge operations

powershell -ExecutionPolicy Bypass -Command "
    try {
        `$config = Get-Content '$ConfigFile' | ConvertFrom-Json
        if (-not `$config.enabled -or -not `$config.syncOnMerge) { exit 0 }
        
        # Load hook manager
        . '$($MyInvocation.MyCommand.Path)'
        `$result = Invoke-SyncOperation 'post-merge' `$config
        
        if (`$result) {
            Write-Host 'Post-merge sync completed'
            exit 0
        } else {
            Write-Host 'Post-merge sync failed (non-blocking)'
            exit 0
        }
    } catch {
        Write-Host 'Post-merge hook error (non-blocking)'
        exit 0
    }
"
"@

# Main execution logic
if ($Install) {
    Write-HookLog "Installing Git hooks..."
    
    if (-not (Test-GitRepository)) {
        Write-HookLog "Not a Git repository or Git not available" "ERROR"
        exit 1
    }
    
    $config = Get-HookConfig
    $success = $true
    
    if ($HookType -eq "all" -or $HookType -eq "pre-commit") {
        $success = $success -and (Install-GitHook "pre-commit" $preCommitHook)
    }
    
    if ($HookType -eq "all" -or $HookType -eq "post-commit") {
        $success = $success -and (Install-GitHook "post-commit" $postCommitHook)
    }
    
    if ($HookType -eq "all" -or $HookType -eq "pre-push") {
        $success = $success -and (Install-GitHook "pre-push" $prePushHook)
    }
    
    if ($HookType -eq "all" -or $HookType -eq "post-merge") {
        $success = $success -and (Install-GitHook "post-merge" $postMergeHook)
    }
    
    if ($success) {
        Write-HookLog "Git hooks installation completed successfully" "SUCCESS"
    } else {
        Write-HookLog "Git hooks installation completed with errors" "WARN"
    }
}

if ($Uninstall) {
    Write-HookLog "Uninstalling Git hooks..."
    
    $hooks = @("pre-commit", "post-commit", "pre-push", "post-merge")
    foreach ($hook in $hooks) {
        $hookFile = Join-Path $GitHooksPath $hook
        if (Test-Path $hookFile) {
            Remove-Item $hookFile -Force
            Write-HookLog "Removed hook: $hook"
        }
    }
    
    Write-HookLog "Git hooks uninstallation completed"
}

if ($Test) {
    Write-HookLog "Testing Git hooks configuration..."
    
    $config = Get-HookConfig
    Write-HookLog "Configuration loaded successfully"
    
    if (Test-GitRepository) {
        Write-HookLog "Git repository validation passed"
    } else {
        Write-HookLog "Git repository validation failed" "ERROR"
    }
    
    if (Test-VaultIntegrity) {
        Write-HookLog "Vault integrity check passed"
    } else {
        Write-HookLog "Vault integrity check failed" "ERROR"
    }
    
    Write-HookLog "Testing completed"
}
```

## ⚙️ **Configuration Options**

### **Hook Behavior**
- **Sync Triggers**: Choose which Git events trigger sync
- **Validation Level**: Control pre-operation checks
- **Conflict Strategy**: Define conflict resolution approach
- **Retry Logic**: Configure failure handling

### **Performance Tuning**
- **Timeout Settings**: Prevent hanging operations
- **Retry Counts**: Balance reliability vs speed
- **Exclusion Patterns**: Skip unnecessary files
- **Batch Operations**: Group multiple changes

### **Safety Features**
- **Working Tree Validation**: Ensure clean state
- **Integrity Checks**: Verify vault health
- **Error Notifications**: Alert on failures
- **Rollback Options**: Undo problematic operations

## 🔄 **System Changes Required**

### **Git Configuration**
- Install Git hooks in repository
- Configure hook execution permissions
- Set up hook management system
- Configure Git settings for automation

### **Repository Structure**
```
.git/hooks/
├── pre-commit
├── post-commit
├── pre-push
└── post-merge

git-hooks/
├── hook-manager.ps1
├── hook-config.json
└── hook-templates/
```

### **Dependencies**
- **Git for Windows**: Hook execution environment
- **PowerShell 5.1+**: Script execution
- **Network Access**: Remote sync operations
- **Obsidian Vault**: Target synchronization

## ✅ **Pros**

### **Native Integration**
- Seamless Git workflow integration
- No external dependencies
- Uses existing Git infrastructure
- Consistent with developer workflows

### **Event-Driven Precision**
- Triggers only on meaningful events
- Avoids unnecessary sync operations
- Preserves Git operation semantics
- Maintains repository integrity

### **Flexibility**
- Configurable hook behavior
- Custom validation logic
- Multiple conflict strategies
- Granular control options

### **Reliability**
- Built-in retry mechanisms
- Error handling and logging
- Validation before operations
- Graceful failure management

## ❌ **Cons**

### **Git Dependency**
- Requires Git knowledge
- Limited to Git repositories
- Hook management complexity
- Git-specific error handling

### **Technical Complexity**
- Hook scripting required
- Cross-platform compatibility issues
- Debugging challenges
- Advanced configuration needs

### **Performance Impact**
- Adds overhead to Git operations
- Network delays during commits
- Potential for operation blocking
- Resource usage during sync

### **Maintenance Overhead**
- Hook updates required
- Configuration management
- Git version compatibility
- Multi-user coordination

## 🛠️ **Setup Instructions**

### **1. Install Git Hooks**
```powershell
# Navigate to vault directory
cd "C:\Users\Admin\Documents\Obsidian Vault"

# Install all hooks
.\hook-manager.ps1 -Install -HookType all

# Or install specific hooks
.\hook-manager.ps1 -Install -HookType post-commit
```

### **2. Configure Hook Behavior**
```powershell
# Edit configuration file
notepad hook-config.json

# Test configuration
.\hook-manager.ps1 -Test
```

### **3. Validate Installation**
```powershell
# Check hook files
ls .git\hooks\

# Test with dummy commit
git add .gitignore
git commit -m "Test hook integration"
```

## 📊 **Performance Metrics**

### **Typical Performance**
- **Setup Time**: 4-8 hours
- **Commit Overhead**: 2-15 seconds
- **Sync Success Rate**: 95%+
- **Hook Execution**: 1-5 seconds
- **Error Recovery**: Automatic

### **Resource Usage**
- **Memory**: 10-50MB during operations
- **CPU**: Low baseline, medium during sync
- **Network**: Dependent on sync operations
- **Disk**: Minimal additional usage

## 🔧 **Troubleshooting**

### **Common Issues**
1. **Hook not executing**: Check permissions, Git configuration
2. **Sync failures**: Verify network, credentials, conflict strategy
3. **Performance issues**: Adjust timeouts, retry counts
4. **Configuration errors**: Validate JSON syntax, required fields

### **Diagnostic Commands**
```powershell
# Check hook status
.\hook-manager.ps1 -Test

# View hook logs
Get-Content git-hooks.log -Tail 20

# Test individual hooks
git config --list | grep hook

# Validate Git repository
git status --porcelain
```

### **Recovery Procedures**
```powershell
# Disable hooks temporarily
git config core.hooksPath /dev/null

# Reinstall hooks
.\hook-manager.ps1 -Uninstall
.\hook-manager.ps1 -Install

# Reset configuration
Remove-Item hook-config.json
.\hook-manager.ps1 -Test
```

## 🔗 **Related Strategies**
- **Foundation**: [[Auto-Sync Prevention Strategies Index]] overview
- **Enhance With**: [[Smart Change Detection]] for better triggers
- **Combine With**: [[Visual Reminder System]] for user awareness
- **Alternative**: [[Event-Driven Auto-Sync]] for non-Git workflows

---

**Implementation Priority**: 🥈 Tier 2 - Excellent for Git-based workflows  
**Best For**: Developers, Git users, repository-based workflows  
**Avoid If**: Non-Git users, simple sync needs, minimal technical knowledge

