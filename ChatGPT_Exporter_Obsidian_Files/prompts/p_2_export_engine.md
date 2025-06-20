# 📤 prompts/P2_Export_Engine.md

## Phase 2.2: Export Engine Prompts

### 📄 Prompt 1: Markdown Formatter
```
Prompt: Convert a structured JSON array of chat messages into clean Markdown using turndown or custom logic. Preserve headings, code blocks, links, and spacing.
```

### 📄 Prompt 2: PDF Export via jsPDF
```
Prompt: Write a PDF export function using jsPDF to format chat messages with roles, timestamps, and long text wrapping. Add page title and styled headings.
```

### 📄 Prompt 3: HTML Export Template
```
Prompt: Create a full HTML template with inline CSS that formats a chat transcript from JSON with timestamp, speaker label, and styled text.
```

### 📄 Prompt 4: Plain Text Export
```
Prompt: Generate a function to convert chat JSON into readable plain text with speaker names and optional timestamps.
```

### 📄 Prompt 5: File Download Handler
```
Prompt: Use FileSaver.js to trigger a download of a given string as a file with .md, .pdf, .txt, or .html extension based on user selection.
```

---

## Related Files
- [[06_File_Structure]]
- [[03_Tech_Stack]]
- [[01_Features_Scope]]
- [[04_WBS]]

## Leads Into
- [[P3_UI_Development]]

## Tags
`tags: #export #markdown #pdf #html #prompts`

> This prompt chain powers the core engine — transforming parsed data into user-ready documents. All exports must preserve structure, style, and readability.

