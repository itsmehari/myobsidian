# 🧪 prompts/P4_Testing_Optimization.md

## Phase 4: Testing & Optimization Prompts

### 🧫 Prompt 1: Markdown Export Validation
```
Prompt: Write a test suite to validate Markdown output from various types of ChatGPT messages — plain text, code blocks, lists, links, etc.
```

### 🧫 Prompt 2: DOM Compatibility Monitoring
```
Prompt: Create a fallback mechanism to detect changes in ChatGPT's DOM structure and notify the developer when the `.markdown` selector fails.
```

### 🧫 Prompt 3: Large Chat Performance Test
```
Prompt: Generate a stress test for exporting very long ChatGPT threads (e.g., 100+ messages) and measure performance impact of Markdown and PDF exporters.
```

### 🧫 Prompt 4: Error Handling + Recovery
```
Prompt: Implement robust error handling in export logic to gracefully notify the user (in popup) if export fails or is incomplete.
```

### 🧫 Prompt 5: Cross-Browser QA Checklist
```
Prompt: Provide a browser-compatibility checklist for Chrome-based extensions and key things to verify during QA.
```

---

## Related Files
- [[04_WBS]]
- [[05_Timeline]]
- [[P2_Export_Engine]]

## Leads Into
- [[P5_Packaging_Release]]

## Tags
`tags: #testing #qa #validation #performance #prompts`

> Use this set to bulletproof your exporter across DOM changes, long sessions, and multiple devices. Ideal for preparing a stable launch candidate.

