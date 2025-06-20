# 📦 Project Documentation: ChatGPT Exporter Extension

## 🎯 Project Overview
Create a robust Chrome extension that allows users to export their ChatGPT conversations in multiple formats including PDF, Markdown, HTML, and plain text. The extension should provide a sleek, user-friendly interface integrated directly into ChatGPT's UI and offer customization options for formatting and file generation.

---

## ✅ Key Features

### 🔁 Export Formats
- [x] PDF (Styled, Paginated)
- [x] Markdown (.md)
- [x] Plain Text (.txt)
- [x] HTML (.html)

### 💡 Export Options
- Include timestamps (toggle)
- Include sender labels (User/System/Assistant)
- Export all or selected parts of a chat
- File naming customization (date, title, custom prefix)

### 🧩 UI Integration
- Floating button in ChatGPT interface
- Keyboard shortcut support
- Popup with settings and export options

### ⚙️ Settings Panel
- Default export format
- Styling options (theme, font size)
- Page layout settings (PDF margins, headers/footers)

### 📚 Advanced Features
- Export chat history across sessions (optional)
- Batch export support (multiple chats at once)
- Auto-backup to Google Drive (optional future)

---

## 🧠 Reference Tools for Benchmarking

### Popular Export Tools
| Tool Name | Type | Export Support | Notes |
|----------|------|----------------|-------|
| ChatGPT2Notion | Extension | Markdown, Notion | Popular for Notion workflows |
| ChatGPT Export (GitHub) | Bookmarklet | Markdown | Requires manual script paste |
| ChatGPT to Markdown | Extension | Markdown | Lightweight, often clipboard-based |
| ChatGPT Exporter (www.chatgptexporter.com) | Extension | PDF, Markdown, Text | Polished UI, Chrome Store listing |
| ChatGPT to PDF | Extension | PDF, Markdown | Supports multiple formats |

### Common Techniques
- DOM parsing using `.markdown` classes
- Use of `turndown` for Markdown conversion
- Injecting UI into ChatGPT with `content.js`
- Export using `jsPDF`, `FileSaver.js`, `html2canvas`
- Bookmarklet method: Script runs via browser console to convert/export

---

## 🧱 Technical Stack
- **Manifest V3** (Chrome Extension Standard)
- **JavaScript / TypeScript**
- **TailwindCSS** or **ShadCN UI Components**
- **Libraries Used:**
  - `jsPDF` for PDF generation
  - `turndown` for Markdown conversion
  - `html2canvas` or `dom-to-image` for styled export
  - `FileSaver.js` for file downloads

---

## 🧩 Work Breakdown Structure (WBS)

### 📊 Time Scheduling Table

| Phase | Task Description | Estimated Duration | Dependencies |
|-------|------------------|--------------------|--------------|
| Phase 1 | Requirements Gathering | 1 day | None |
| Phase 1 | Design Mockups | 2 days | Requirements |
| Phase 1 | UI Library Selection | 1 day | Mockups |
| Phase 1 | Repo Setup | 1 day | None |
| Phase 2.1 | DOM Extraction Engine | 2 days | Repo Setup |
| Phase 2.2 | Markdown Export Logic | 1.5 days | DOM Extraction |
| Phase 2.2 | PDF Export Logic | 1.5 days | DOM Extraction |
| Phase 2.2 | HTML/Text Export | 1 day | DOM Extraction |
| Phase 2.3 | File Download Handler | 1 day | Export Logic |
| Phase 3.1 | Popup UI Development | 2 days | Mockups, UI Library |
| Phase 3.2 | ChatGPT UI Injection | 2 days | DOM Extraction |
| Phase 3.3 | Settings Management | 1.5 days | Popup UI |
| Phase 4 | Testing & Compatibility | 2 days | All Export Functions |
| Phase 4 | Optimization | 1 day | Initial Testing |
| Phase 5 | Manifest + Assets Finalization | 1 day | All Dev Complete |
| Phase 5 | Chrome Web Store Prep | 2 days | Finalized Extension |
| Phase 5 | Submission & Review | 3-7 days | Web Store Prep |



### Phase 1: Planning & Setup
1. Requirements Gathering ✅
2. Design Mockups (Figma/Canva)
3. UI Library Selection (TailwindCSS + ShadCN preferred)
4. Repo Setup (GitHub with standard README)

### Phase 2: Core Functionality
**2.1 DOM Extraction Engine**
- Extract chat content via DOM parsing
- Normalize data: timestamps, sender roles

**2.2 Export Engine**
- Markdown formatter using `turndown`
- PDF generator using `jsPDF`
- HTML and plain text conversion

**2.3 Download Handler**
- Integrate FileSaver.js
- File naming and formatting

### Phase 3: UI Development
**3.1 Popup Interface**
- Clean layout using Tailwind or ShadCN UI
- Tabs or toggles for export settings

**3.2 ChatGPT UI Injection**
- Floating export button inside ChatGPT
- Hover tooltips and shortcut indicators

**3.3 Settings Management**
- Store user preferences (localStorage)
- Toggle visibility of settings in popup

### Phase 4: Testing & Optimization
1. DOM Compatibility Checks (ChatGPT updates)
2. Edge Case Handling (images, large chats)
3. Performance optimization (batch operations)
4. Export validation

### Phase 5: Packaging & Release
1. Manifest Finalization (permissions, service workers)
2. Chrome Web Store Assets (icon, promo images)
3. Publishing & Review Submission

---

## 📁 File Structure (Proposed)
```
chatgpt-exporter-extension/
├── manifest.json
├── background.js
├── content.js
├── popup/
│   ├── popup.html
│   ├── popup.js
│   └── popup.css
├── assets/
│   └── icon.png
├── utils/
│   ├── exportPDF.js
│   ├── exportMD.js
│   └── exportHTML.js
└── styles/
    └── tailwind.config.js
```

---

## 📌 Markdown Export Flow (Console/Bookmarklet)
1. Open ChatGPT conversation
2. Open browser DevTools > Console
3. Paste bookmarklet script that extracts `.markdown` DOM
4. Convert using `turndown`
5. Copy Markdown to clipboard or save as file

### Planned Bookmarklet Generator
- Include "Bookmarklet Generator" in Advanced tab
- Generates a JavaScript string:
```js
javascript:(function(){/* DOM grab + turndown logic */})()
```
- Allows user to drag and drop into bookmarks bar

---

## 🔜 Future Enhancements
- Multi-session export
- Integration with Notion/Obsidian
- Export to Google Docs
- Light/Dark PDF theming
- Drag-to-select chat blocks for export
- Console-friendly snippets for advanced dev users

---

## 📆 Suggested Timeline
- Week 1: Planning, UI Design
- Week 2: DOM Parsing + Markdown/PDF Export
- Week 3: UI + Settings + Integration
- Week 4: Testing, Review, and Publish

---

## 👥 Roles (Assumed)
- **Lead Developer:** Handles JS, export logic
- **UI/UX Designer:** Popup & injected UI
- **QA Tester:** Chrome compatibility, export accuracy
- **Product Owner:** Reviews releases & roadmap

---

## 🔨 Detailed Prompt List for Module-by-Module Development

### 📁 Phase-Wise Prompt Work Breakdown

#### 🔹 Phase 1: Planning & Setup
1. **Prompt:** "Generate a Chrome extension manifest V3 setup template for a project named 'ChatGPT Exporter' with permissions for scripting, active tab, and content scripts."
2. **Prompt:** "Design a modern popup layout using TailwindCSS or ShadCN with tabs for Export Options, Settings, and Advanced tools."
3. **Prompt:** "Suggest icons and UI assets for a minimalistic and modern ChatGPT export extension."

#### 🔹 Phase 2: DOM Extraction Engine
4. **Prompt:** "Write JavaScript to extract all `.markdown` divs from the ChatGPT interface and structure them as message-role-timestamp objects."
5. **Prompt:** "Normalize extracted ChatGPT messages into an array of JSON objects containing: role, timestamp, content."
6. **Prompt:** "Create logic to handle special cases in ChatGPT chats like code blocks, inline code, and links while preserving markdown formatting."

#### 🔹 Phase 2.2: Export Engine
7. **Prompt:** "Convert structured ChatGPT JSON chat data into Markdown using turndown or similar logic."
8. **Prompt:** "Build a PDF export function using jsPDF that supports multiline, headers, and styled content."
9. **Prompt:** "Create an HTML export template with inline CSS to maintain chat formatting."
10. **Prompt:** "Write download functions using FileSaver.js to save files as .md, .pdf, .html, .txt."

#### 🔹 Phase 3: UI Development
11. **Prompt:** "Inject a floating export button into the ChatGPT interface using content.js with tooltip and click handler."
12. **Prompt:** "Create a settings tab that uses localStorage to save user preferences like format, theme, and include-timestamps."
13. **Prompt:** "Build the advanced tab that includes a console-ready bookmarklet generator with usage instructions."

#### 🔹 Phase 4: Testing & Optimization
14. **Prompt:** "Generate test cases for validating Markdown export structure using sample ChatGPT conversation data."
15. **Prompt:** "Write compatibility script to detect updates in ChatGPT DOM structure and adjust extraction logic accordingly."
16. **Prompt:** "Profile the export engine with a large conversation and optimize performance using async batching."

#### 🔹 Phase 5: Packaging & Release
17. **Prompt:** "Create a Chrome Web Store listing copy with title, description, features, and permissions rationale."
18. **Prompt:** "Design 3 promotional banner images for the Web Store listing highlighting Export to Markdown, PDF, and Customization."
19. **Prompt:** "Create a README.md file for the GitHub repo detailing installation, usage, customization, and credits."

---

Each of these prompts can be used independently in AI tools or planning boards to generate components, iterate UI, and debug modules quickly.

