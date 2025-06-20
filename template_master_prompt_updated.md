# 🧠 Template\_MasterPrompt.md

## 🎯 Purpose

Use this template to instruct ChatGPT (or Cursor/Warp AI) to replicate a **complete modular, AI-operable, Obsidian-compatible documentation system** for **any software development project**. This template is especially suited for:

- Chrome Extensions
- Web Apps (React, Vite, Next.js)
- UI/UX-heavy tools
- Automation Workflows
- DevOps Utilities

It includes:

- Interlinked `.md` files ready for Obsidian
- Structured prompt chains per development phase
- Best practices in UX, architecture, Chrome compliance, and release flow
- Full context retention to regenerate complete documents (no placeholders)

---

## ✅ Master Prompt Template

```
I want to generate a complete modular documentation and development system for a project titled: [PROJECT NAME].

It should include:

1. 🔖 Core Project Files:
   - 00_Project_Overview
   - 01_Features_Scope
   - 02_Reference_Tools (competitor/comparative intelligence)
   - 03_Tech_Stack (justified, optional alternatives)
   - 04_WBS (Work Breakdown Structure with links to prompt sets)
   - 05_Timeline (effort + scheduling view)
   - 06_File_Structure (folder + file layout)
   - 07_Logic_Flows (user interaction + system logic)
   - 08_Future_Enhancements (deferred ideas)
   - 09_Team_Roles & Responsibility Matrix

2. 🧠 Prompt Modules:
   A `/prompts` folder containing structured, phase-wise prompts:
   - P1_Planning_Setup
   - P2_DOM_or_Data_Extraction
   - P2_Export_or_Logic_Engine
   - P3_UI_Development (popup, web, injected UIs)
   - P4_Error_Handling_&_Testing
   - P5_Packaging_&_Release

3. 🧩 Document Linking & Format:
   - Use Obsidian-style `[[WikiLinks]]`
   - Include `## Tags`, `status: draft`, and short usage blurbs
   - Optional YAML frontmatter for AI indexing

4. 🧪 Built-In Best Practices:
   - UI/UX principles (accessibility, responsiveness, minimalism)
   - Chrome Extension standards per [developer.chrome.com best practices] and [daily.dev guide]:
     - Manifest V3 with minimal permission footprint
     - Secure data handling (HTTPS, privacy disclosures)
     - Avoid blocking BFCache (no unload handlers in content scripts)
     - Use background scripts/service workers for clean event handling
     - Isolate content scripts responsibly (sandboxing, scoped interaction)
     - Implement a well-documented `manifest.json` and logic-separated architecture
     - Provide seamless user onboarding with clear instructional flows
     - Deliver user-friendly, customizable, and low-clutter UIs
     - Optimize file size via minification, compression, and debounced logic
     - Test with Chrome DevTools and simulate multiple devices & speeds

5. 🗃️ AI Operability:
   - All files contain actual usable content — **not placeholders**
   - Prompt blocks are designed for Cursor AI, Warp, or manual AI agents
   - Each file stands alone, but connects contextually using `[[WikiLinks]]`

6. 📦 Output Packaging:
   - Bundle all `.md` files into a structured `.zip`
   - Export to Notion, Gantt-style visual, or CLI-readable folder
   - Allow easy reuse as a project boilerplate or starter kit

7. 🤖 AI Agent Setup:
   - Define global AI behavior: summarize, suggest, auto-generate missing files
   - Preset memory scope: store key architecture decisions, component signatures
   - Auto-update WBS and Timeline as modules progress
   - Activate context-aware linting, testing, and code formatting per file type

8. 🧩 Dynamic Prompt Input Blocks:
   Use this dynamic format inside `/prompts`:
   ### Prompt Title: Create Manifest
```

Input:

- Extension name: {{extension\_name}}
- Permissions: {{permissions\_list}}

Output: A valid `manifest.json` with V3 compliance and defined actions

```

9. 🔗 Prompt Chaining Logic:
> If [[P2_DOM_or_Data_Extraction]] is complete,
Proceed to [[P2_Export_or_Logic_Engine]] using previously extracted selectors and target URLs.

If [[P4_Error_Handling_&_Testing]] finds errors, loop back to:
- [[P3_UI_Development]] if UI-related
- [[P2_Export_or_Logic_Engine]] if logic-related

10. 🕘 Timeline Tracking:
- Auto-tag files with estimated effort blocks
- Optional daily/weekly velocity prompts for tracking progress

11. 👥 Role Guidelines:
- `PM`: Oversees WBS, Timeline, and Documentation sync
- `Dev`: Owns `/prompts/P2*`, `/prompts/P4*`
- `Designer`: Owns `/prompts/P3_UI_Development`
- `Reviewer`: Tests prompts, outputs, links

12. 🔁 Automated QA Prompts:
- Generate test cases for each UI interaction
- Simulate input/output for export logic
- Validate manifest against schema
- Audit localStorage/Chrome.storage behavior
```

---

## 📝 Notes

- Always retain **context window summaries** for full file regeneration
- Do not generate dummy files unless explicitly requested
- Ensure secure coding + Chrome Web Store policy alignment
- Reuse across design, logic, error handling, onboarding, and publishing
- Implement content script safety, storage API practices, and Chrome-specific testing workflows

---

## Tags

`tags: #prompt-template #documentation-system #chrome-extension #uiux #fullstack #project-template #best-practices #manifest-v3 #obsidian #chrome-api #performance #security #onboarding #qa #modular-ai #collaboration #dynamic-prompts`

> This upgraded template covers technical, functional, design, compliance, operational, and automation concerns. Use it to bootstrap any tool, extension, or product with rapid, AI-compatible, Obsidian-based documentation.

