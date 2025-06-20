# 📁 06_File_Structure.md

## Recommended Folder Layout
```
chatgpt-exporter-extension/
├── manifest.json                # Chrome extension manifest (V3)
├── background.js                # Optional service worker for V3 events
├── content.js                   # Injected into ChatGPT to parse/chat UI
├── popup/
│   ├── popup.html               # Popup interface
│   ├── popup.js                 # Logic and interactivity
│   └── popup.css                # Styling (Tailwind or custom)
├── assets/
│   └── icon.png                 # Extension icon
├── utils/
│   ├── exportPDF.js             # PDF generation logic
│   ├── exportMD.js              # Markdown formatter
│   └── exportHTML.js            # HTML generator module
├── styles/
│   └── tailwind.config.js       # Custom Tailwind configuration
```

---

## Notes
- Use modular structure for maintainability
- Consider breaking logic into services and utilities
- Add i18n folder if multi-language support is planned
- Keep popup isolated for minimal permissions

---

## AI-Generated Scaffold Prompts
- [[prompts/P2_Export_Engine]]
- [[prompts/P3_UI_Development]]
- [[prompts/P5_Packaging_Release]]

## Related Files
- [[03_Tech_Stack]]
- [[04_WBS]]
- [[00_Project_Overview]]

## Tags
`tags: #structure #folders #modular #scaffold`

> This layout is optimized for clarity, build automation, and browser compliance. Each file/module should be targetable by AI via file-specific prompts.

