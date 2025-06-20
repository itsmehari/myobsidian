# 🧠 Template\_MasterPrompt.md

## 🎯 Purpose

Use this template to instruct ChatGPT (or Cursor/Warp AI) to replicate the **complete modular project documentation system** as built for the ChatGPT Exporter project — including:

- Obsidian-linked `.md` files
- Structured prompt chains
- Context-aware prompt generation based on ongoing discussions

---

## ✅ Master Prompt Template

```
I want to generate a complete project documentation system in Obsidian-style Markdown for a project titled: [PROJECT NAME].

It should include:

1. 🔖 Core project files:
   - 00_Project_Overview
   - 01_Features_Scope
   - 02_Reference_Tools
   - 03_Tech_Stack
   - 04_WBS (Work Breakdown Structure)
   - 05_Timeline
   - 06_File_Structure
   - 07_Export_Flow_Bookmarklet (if applicable)
   - 08_Future_Enhancements
   - 09_Team_Roles

2. 🧠 Prompt Modules folder:
   Create a `/prompts` folder containing files for each phase:
   - P1_Planning_Setup
   - P2_DOM_Extraction
   - P2_Export_Engine
   - P3_UI_Development
   - P4_Testing_Optimization
   - P5_Packaging_Release

3. 🧩 Linking & Format:
   - All files should be written in clean Obsidian Markdown
   - Use `[[WikiLinks]]` to connect documents contextually
   - Include `## Tags` and status flags like `status: draft`
   - Maintain nested folders where appropriate (e.g., `prompts/`)

4. 🗃️ AI Operability:
   - Make each file fully readable by ChatGPT/LLMs
   - Where files are regenerated, include detailed content — not placeholders
   - If the session had content context (like ChatGPT summaries), **reuse that context window** to regenerate exact file bodies (not dummy markdown)

5. 📦 Packaging:
   - Bundle all `.md` files into a ZIP structure for download
   - Offer option to export prompts separately or use as AI triggers

6. 🛠️ Final Deliverables:
   - Downloadable archive of all files
   - Reusable prompt template
   - Optional: export to Notion or visual Gantt tool
```

---

## 📝 Notes

- Emphasize: **NO placeholder text** unless explicitly specified.
- Always regenerate based on working memory/context when rebuilding.
- Support reuse of past chat threads or Markdown sessions if applicable.

---

## Tags

`tags: #prompt-template #obsidian #documentation-system #project-template #ai-ready`

> This template serves as a blueprint for rapid knowledge system deployment across projects. Save and adapt it for each new modular AI-driven initiative.

