# 🔍 prompts/P2_DOM_Extraction.md

## Phase 2.1: DOM Extraction Prompts

### 🟪 Prompt 1: Basic Chat Message Extractor
```
Prompt: Write a JavaScript snippet that selects all .markdown elements on https://chat.openai.com and extracts their innerHTML into an array.
```

### 🟪 Prompt 2: Structured JSON Format
```
Prompt: Convert extracted .markdown elements into a JSON array with properties: role (user/assistant), timestamp (if visible), and content.
```

### 🟪 Prompt 3: Handling Code Blocks and Links
```
Prompt: Improve the DOM parsing logic to properly extract and format code blocks, inline code, and links within the chat content.
```

### 🟪 Prompt 4: Role Assignment Heuristics
```
Prompt: Based on DOM hierarchy or position, assign message roles (User, Assistant) to each message block extracted.
```

### 🟪 Prompt 5: Exporting Extracted Data
```
Prompt: Convert the chat JSON data into a clean stringified JSON download using FileSaver.js.
```

---

## Related Files
- [[04_WBS]]
- [[06_File_Structure]]
- [[07_Export_Flow_Bookmarklet]]

## Leads Into
- [[P2_Export_Engine]]

## Tags
`tags: #prompts #dom #parsing #chatgpt #extraction`

> Use these prompts to extract clean, structured, context-aware data from ChatGPT's current DOM layout. Adjust for changes over time with selector fallbacks.

