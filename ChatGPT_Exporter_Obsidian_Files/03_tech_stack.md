# 🧱 03_Tech_Stack.md

## Primary Technologies

### 🧩 Chrome Extension Platform
- Manifest Version: **V3**
- Background: **Service Worker**
- UI: **Popup + Injected DOM**

### 🔧 Frontend & UI
- **TailwindCSS** for rapid styling
- **ShadCN UI** components (if React support enabled)
- Plain HTML/CSS fallback for popup

### 📦 Core JS Libraries
| Purpose           | Library         |
|------------------|-----------------|
| PDF Export       | `jsPDF`         |
| Markdown Export  | `turndown`      |
| HTML/Image Export| `html2canvas`   |
| File Downloads   | `FileSaver.js`  |

### ⛓️ Utilities
- `localStorage` for settings persistence
- `content.js` for UI & DOM access
- Optional: `dom-to-image` for rich HTML capture

---

## Optional Tools for Future Enhancements
- Google Drive API (OAuth, auto-backup)
- Firebase (auth + usage tracking)
- Vite + React (if scalability needed)

---

## File & Prompt Links
- [[00_Project_Overview]]
- [[01_Features_Scope]]
- [[02_Reference_Tools]]
- [[04_WBS]]
- [[06_File_Structure]]
- [[prompts/P2_Export_Engine]]
- [[prompts/P3_UI_Development]]

## Status
`status: draft`

## Tags
`tags: #techstack #libraries #dependencies #architecture`

> This stack is chosen to keep the extension light, efficient, and compatible with vanilla Chrome APIs, while still enabling rich export formats and modern UI design.

