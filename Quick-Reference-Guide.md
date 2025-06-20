# AI-Obsidian Quick Reference
**Created**: 2025-06-20  
**Tags**: #reference #quick-guide #cheatsheet  
**Related**: [[AI-Obsidian-Setup]] | [[Data-Loss-Prevention-Guide]]  
**Status**: Complete

---

## 🚀 Quick Start Commands

### **Daily Sync Operations**
```bash
sync.bat status                    # Check current status
sync.bat safe "Daily update"       # Safe sync with backup
sync.bat backup                    # Manual backup
sync.bat pull                      # Pull latest only
sync.bat push "message"            # Push with message
```

### **Emergency Commands**
```bash
sync.bat backup                    # Create immediate backup
sync.bat force "Emergency sync"    # Force sync (after backup)
sync.bat help                      # Show all options
```

## 📁 File Operations

### **Creating Files**
```markdown
create_file(
    path="C:\Users\Admin\Documents\Obsidian Vault\Topic-Analysis-2025-06-20.md",
    content="# Title\n**Created**: 2025-06-20\n**Tags**: #analysis\n\n## Content",
    summary="Description"
)
```

### **Reading Files**
```markdown
read_files([{"path": "C:\Users\Admin\Documents\Obsidian Vault\file.md"}])
read_files([{"path": "file.md", "ranges": ["1-100"]}])  # First 100 lines
```

### **Editing Files**
```markdown
edit_files([{
    "file_path": "C:\Users\Admin\Documents\Obsidian Vault\file.md",
    "search": "old content",
    "replace": "new content",
    "search_start_line_number": 10
}])
```

### **Finding Files**
```markdown
file_glob(
    path="C:\Users\Admin\Documents\Obsidian Vault",
    patterns=["*Analysis*.md", "*-2025-*.md"]
)
```

## 📝 Content Templates

### **Standard File Header**
```markdown
# Title
**Created**: 2025-06-20  
**Tags**: #tag1 #tag2  
**Related**: [[Related Note]]  
**Status**: Draft

---

## Summary
Brief overview

## Content
Main content here
```

### **Analysis Document**
```markdown
# System Analysis
**Created**: 2025-06-20  
**Tags**: #analysis #technical  
**Related**: [[Related Analysis]]  
**Status**: Complete

---

## 📋 Executive Summary
Key findings and recommendations

## 🔍 Analysis Details
Technical findings

## 🚀 Recommendations
Actionable next steps

## 🔗 References
Related documents and links
```

## 🔗 Obsidian Linking

```markdown
[[Note Name]]                     # Basic link
[[Note Name|Custom Text]]         # Link with custom text
[[Note Name#Section]]            # Link to specific section
![[Image.png]]                   # Embed image
![[Note]]                        # Embed entire note
#tag                             # Simple tag
#category/subcategory            # Hierarchical tag
```

## 🔧 System Commands

### **Safe Commands** (Read-only)
```powershell
git status --porcelain
git log --oneline -5
Get-ChildItem "path" -Name
Test-Path "path"
```

### **Sync Commands**
```powershell
.\sync-vault.ps1 -PullOnly
.\sync-vault.ps1 -BackupOnly
.\sync-vault.ps1 -ConflictStrategy "backup"
```

## ⚠️ Safety Rules

### **DO's**
- ✅ Always use `sync.bat safe` for routine syncs
- ✅ Create backups before major changes
- ✅ Use descriptive commit messages
- ✅ Check status before starting work
- ✅ Use absolute file paths

### **DON'Ts**  
- ❌ Never use `sync.bat force` without backup
- ❌ Don't sync from multiple devices simultaneously
- ❌ Don't use destructive git commands
- ❌ Don't skip conflict resolution
- ❌ Don't ignore backup failures

## 📊 File Naming Conventions

```
Analysis Files:     [Topic]-Analysis-YYYY-MM-DD.md
Project Files:      Project-[Name]-[Component]-YYYY-MM-DD.md
Daily Notes:        YYYY-MM-DD-Daily-Notes.md
Reference Guides:   [Topic]-Reference-Guide.md
Quick Guides:       Quick-[Purpose]-Guide.md
```

## 🆘 Emergency Procedures

### **Data Loss Recovery**
1. **STOP** - Don't make changes
2. Check backups: `Get-ChildItem C:\Users\Admin\Documents\Obsidian-Backups`
3. Restore from backup: `Copy-Item [backup] [vault] -Recurse -Force`
4. Verify restoration
5. Create new backup: `sync.bat backup`

### **Sync Conflicts**
1. Create backup: `sync.bat backup`
2. Use safe strategy: `sync.bat safe "Conflict resolution"`
3. Check conflicts folder for local changes
4. Manually merge if needed
5. Test sync: `sync.bat status`

### **Repository Issues**
1. Create backup: `sync.bat backup`
2. Check git health: `git fsck --full`
3. Verify remote: `git ls-remote --heads origin`
4. If needed: Clone fresh copy and merge

## 📍 Important Paths

```
Vault:              C:\Users\Admin\Documents\Obsidian Vault
Backups:            C:\Users\Admin\Documents\Obsidian-Backups
Remote Repo:        https://github.com/itsmehari/myobsidian.git
Sync Script:        C:\Users\Admin\Documents\Obsidian Vault\sync-vault.ps1
Config File:        C:\Users\Admin\Documents\Obsidian Vault\ai-config.json
```

## 🔄 Conflict Resolution Matrix

| Situation | Command | Risk | Data Loss | Recommended |
|-----------|---------|------|-----------|-------------|
| Daily sync | `sync.bat safe` | Low | None | ✅ Always |
| Quick check | `sync.bat status` | None | None | ✅ Always |
| Known conflicts | `sync.bat merge` | Medium | Low | ⚠️ Advanced |
| Emergency | `sync.bat force` | High | Medium | ❌ Backup first |
| Pull only | `sync.bat pull` | Very Low | None | ✅ Always safe |

## 📚 Documentation Links

**Setup & Configuration:**
- [[AI-Obsidian-Setup]] - Main system overview
- [[AI-Integration-Capabilities]] - Available functions

**Safety & Sync:**
- [[Data-Loss-Prevention-Guide]] - Comprehensive safety guide
- [[Sync-Scripts-Documentation]] - Technical details

**Usage & Standards:**
- [[Markdown-Standards-Guide]] - Formatting guidelines
- [[Naming-Conventions-Guide]] - File organization

---

**Quick Reference Version**: 1.0  
**Last Updated**: June 20, 2025  
**Print this for offline reference** 📄

