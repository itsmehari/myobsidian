# 📁 Generic Project Folder Explorer and Summary Generator

## 🎯 Purpose

This markdown prompt is designed for AI agents like ChatGPT, Cursor AI, or Warp AI to run **immediately after a project folder is loaded**. It performs a full recursive scan, identifies functional modules, and creates a comprehensive summary of the structure. It also suggests documentation priorities, UI/UX responsibilities, SEO considerations, project management dependencies, and developer collaboration plans.

This template is applicable to:

- Web applications (React, Vue, Angular, Svelte, static sites)
- Chrome extensions
- Node.js, Express, Flask, or backend APIs
- JAMstack projects (Next.js, Astro, Nuxt)

---

## 🧠 Enhanced Prompt (Feed into AI after loading project folder)

```
🔍 Scan the current project folder and subfolders recursively. Build a deeply structured, multi-dimensional summary of the project.

Auto-detect the project type based on folder and file patterns. Use the following logic:
- If manifest.json and background.js/content.js exist → Chrome Extension
- If next.config.js or pages/api exists → Next.js project
- If vite.config.js or main.ts/main.js exists + src/ folder → Vite SPA (Vue/React)
- If server.js or app.js exists with express() → Node.js backend
- If astro.config.mjs exists → Astro site

Based on detection, adapt the structure mapping and recommendations to match the architecture.

Please include the following sections:

---

### 1. 📦 Directory Overview
- Display high-level folder and file structure as a tree view
- Identify:
  - UI code (layouts, components, styles)
  - Core logic (business logic, workflows, data fetching)
  - Assets (images, fonts, SVGs, videos)
  - Environment/configuration files
  - Testing files and frameworks (unit, E2E, snapshot)
  - Build output (e.g., /dist, /out)
  - Legacy or unreferenced files (warn about them)

---

### 2. 🧩 Functional Mapping
- For each key directory/module, list:
  - Primary purpose
  - Related files or dependencies
  - Possible owner (Dev, Designer, PM)
  - AI module reference (e.g., `[[P2_Logic_Export]]`, `[[UI_Dashboard]]`)

---

### 3. 👥 Role-Based Responsibility Allocation
- Identify:
  - Frontend ownership: component, route, UX concerns
  - Backend ownership: API handlers, data flows
  - UI/UX: Styling, animations, layout files
  - SEO: Meta, accessibility, crawlability indicators
  - PM: `README`, `CONTRIBUTING.md`, Roadmap.md

---

### 4. 📋 Suggested Documentation Plan
- Auto-propose file names (Obsidian-compatible) for documentation based on structure:
  - `[[00_Project_Overview]]`
  - `[[01_Features_Scope]]`
  - `[[03_Tech_Stack]]`
  - `[[04_WBS]]`
  - `[[SEO_Checklist]]`, `[[Accessibility_Audit]]`, etc.

---

### 5. 🚥 Priority Labeling
Mark folders/files with purpose-specific labels:
- `CORE`: Essential runtime logic
- `UI`: Visual and UX-layer assets
- `CONFIG`: App-level constants and env
- `SEO`: Metadata, sitemap, robots, a11y
- `UTIL`: Helpers, hooks, services
- `DATA`: Static input, external content
- `BUILD`: Auto-generated outputs
- `LEGACY`: Potentially deprecated or unused

---

### 6. 🧪 QA & Testing Summary
- Detect test files (unit, integration, e2e)
- Identify test coverage gaps (e.g., missing UI tests)
- Warn about tests with no associated logic
- Recommend prompt files like `[[Test_Prompts_UI]]`, `[[Test_Prompts_API]]`

---

### 7. 💅 UI/UX Design Audit
- Highlight folders like /components, /styles, /pages
- Identify unresponsive, non-mobile-first layouts
- Detect redundant or verbose style declarations
- Suggest UI systemization:
  - Atomic design, Tailwind usage, Chakra/Material breakdown
  - Prompt file: `[[Design_Tokens_Registry]]`, `[[Components_System]]`

---

### 8. 🔍 SEO & A11y Recommendations (Web Projects Only)
- Check for:
  - Missing meta tags, OpenGraph/Twitter previews
  - Improper heading structures
  - Alt text issues
  - Sitemap and robots.txt presence
- Suggest files like:
  - `[[SEO_Checklist]]`
  - `[[A11y_Validation_Notes]]`

---

### 9. 📈 Project Management Hooks
- Look for presence of:
  - `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`
  - GitHub issue templates or project boards
  - Roadmaps, milestone references
- Suggest:
  - `[[Project_ReadMe_Index]]`
  - `[[Onboarding_Checklist]]`
  - `[[Milestone_Progress]]`

---

### 10. 🗺️ Next-Step Suggestions
- Recommend ideal `/prompts/` structure based on what was found
- Link files to their associated AI prompt entries using `[[WikiLinks]]`
- Highlight under-documented or risky code areas
- Optionally suggest WBS rebuild or file refactor plan
```

---

## Example Output Format

```yaml
root/
├── README.md               # PM | Project overview & documentation
├── package.json            # CONFIG | Dependencies & scripts
├── tsconfig.json           # CONFIG | TypeScript compiler settings
├── vite.config.ts          # CONFIG | Vite build settings
├── /public                 # DATA | Static assets
├── /src
│   ├── main.ts             # CORE | App entry
│   ├── App.vue             # UI | Main view shell
│   ├── /assets             # DATA | Images, SVGs
│   ├── /components         # UI | Shared UI elements
│   ├── /pages              # UI | Page-level views
│   ├── /styles             # UI | CSS/SCSS/global styles
│   ├── /router             # CORE | Routing definitions
│   ├── /composables        # UTIL | Hooks & logic reuse
│   ├── /store              # CORE | State management
│   ├── /services           # UTIL | API/data logic
│   ├── /locales            # DATA | i18n language packs
│   └── /tests              # QA | Unit/integration tests
├── .gitignore              # CONFIG | Git tracking control
├── .eslintrc.cjs           # CONFIG | Linting rules
├── .prettierrc             # CONFIG | Code style

[[00_Project_Overview]]
[[01_Features_Scope]]
[[03_Tech_Stack]]
[[04_WBS]]
[[SEO_Checklist]]
[[Accessibility_Audit]]
[[Design_Tokens_Registry]]
[[Test_Prompts_UI]]
[[Onboarding_Checklist]]
[[Milestone_Progress]]
```

---

## Tags

`#project-mapping` `#modular-summary` `#ai-ready` `#seo` `#uiux` `#a11y` `#project-manager` `#prompt-generator` `#folder-analyzer` `#developer-toolkit`

