# 🧩 04_WBS.md

## Work Breakdown Structure (WBS)

### Phase 1: Planning & Setup
- Requirements Gathering ✅
- Design Mockups (Figma/Canva)
- UI Library Selection (TailwindCSS + ShadCN)
- Repo Setup (GitHub)

### Phase 2: Core Functionality
**2.1 DOM Extraction Engine**
- Extract chat content via DOM parsing
- Normalize data: timestamps, sender roles

**2.2 Export Engine**
- Markdown formatter (`turndown`)
- PDF export (`jsPDF`)
- HTML and Text fallback

**2.3 Download Handler**
- `FileSaver.js` for all exports
- Custom filename builder

### Phase 3: UI Development
**3.1 Popup UI**
- Tabbed interface for settings, formats, advanced tools

**3.2 ChatGPT UI Injection**
- Floating export menu inside `.chatgpt` page
- Hover menu + shortcut

**3.3 Settings Management**
- Toggle timestamps, format, theme
- Save via `localStorage`

### Phase 4: Testing & Optimization
- Compatibility check (DOM changes)
- Performance benchmark (chat length)
- Error logging and edge handling

### Phase 5: Packaging & Release
- Finalize manifest & permissions
- Create Chrome Store assets
- Submit + await review

---

## Linked Scheduling Table → [[05_Timeline]]

## Linked Prompts
- [[prompts/P1_Planning_Setup]]
- [[prompts/P2_DOM_Extraction]]
- [[prompts/P2_Export_Engine]]
- [[prompts/P3_UI_Development]]
- [[prompts/P4_Testing_Optimization]]
- [[prompts/P5_Packaging_Release]]

## Related Docs
- [[00_Project_Overview]]
- [[01_Features_Scope]]
- [[03_Tech_Stack]]
- [[06_File_Structure]]

## Tags
`tags: #structure #workflow #phases #wbs`

> Each WBS section maps to a modular development flow, with prompts and file logic tied to AI automation workflows (Cursor/Warp).

