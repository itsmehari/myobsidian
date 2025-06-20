# 📌 07_Export_Flow_Bookmarklet.md

## Bookmarklet Export Flow

### Step-by-Step Process
1. Open a ChatGPT conversation
2. Open browser DevTools → Console
3. Paste bookmarklet code
4. Script extracts all `.markdown` elements
5. Markdown is compiled using `turndown`
6. Output is downloaded as `.md` or copied to clipboard

---

### Sample Bookmarklet Snippet (Basic)
```js
javascript:(function(){
  const elements = document.querySelectorAll('.markdown');
  const turndown = new TurndownService();
  let result = '';
  elements.forEach(e => result += turndown.turndown(e.innerHTML) + '\n\n');
  const blob = new Blob([result], { type: 'text/markdown' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = 'chatgpt-export.md';
  link.click();
})();
```

---

### Why Include Bookmarklet?
- For non-extension users (lightweight usage)
- Enables quick testing of export logic
- Useful for dev-mode use

---

## Related Enhancements
- Add “Copy to Clipboard” variant
- Add auto-triggered prompt interface
- Allow drag-drop bookmarklet into browser

---

## Related Files
- [[02_Reference_Tools]]
- [[01_Features_Scope]]
- [[04_WBS]]
- [[prompts/P2_DOM_Extraction]]

## Tags
`tags: #bookmarklet #console #turndown #extraction #minimal`

> Use this module as a headless fallback or developer utility when full extension functionality is not required.

