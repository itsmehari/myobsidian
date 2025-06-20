# 🧱 Biple 3D Replica – Design & Development Plan

A 3D interactive replica inspired by the Biple design language. Built with HTML, CSS, and vanilla JavaScript using `Three.js`, no Node.js or build tools.

---

## 🔤 Fonts

**Primary Fonts**:

- `Outfit` – Body & Interface
    
- `Space Grotesk` – Logo
    

**CDN Embed:**

html

CopyEdit

`<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700&family=Space+Grotesk:wght@500;600&display=swap" rel="stylesheet">`

---

## 🎨 Colors

|Color Purpose|Hex Code|
|---|---|
|Background|`#FDF1E9`|
|Dark Purple|`#3A1C6C`|
|Pink Glass “p”|`#E06CDE`|
|BP Palette|`#1C0C33`, `#C95AE6`, `#E5A0E2`, `#725BD0`, `#B39FF8`, `#9BD9CA`|

---

## 🧩 Key UI Components

### 1. **3D Logo**

- TextGeometry with bevel
    
- Custom material for letter “p”
    
- Animated rotation using GSAP
    

### 2. **Typography Blocks**

- `Aa`, `AaBb123`, etc.
    
- Font weight grid (Light → Bold)
    
- Positioned as floating text or flat HTML
    

### 3. **Color Palette Circles**

- CylinderGeometry for each pill
    
- Interactive hover animation
    
- Slight elevation and shading
    

### 4. **Search Bar**

- HTML input with border-radius
    
- Icon + glow hover
    
- Optionally mapped to 3D plane
    

### 5. **Checklist Card**

- Dashed violet border
    
- Toggleable HTML/CSS checkbox
    
- Also mockup as 3D interactive if needed
    

### 6. **Sticky Navigation Bar**

- Transparent background with blur
    
- Menu, logo, user icon
    
- Hide-on-scroll, appear-on-scroll
    

### 7. **Enhancement Components**

- **CTA Buttons** – rounded corners, animated
    
- **Brand Grid Cards** – 2x3 responsive layout
    
- **Font Hierarchy Display** – `H1`, `H2`, `H3` usage
    

---

## 📱 Responsive Layout Behavior

|Viewport Width|Layout Behavior|
|---|---|
|>1200px|Full 3D rendering|
|768–1200px|Reduced 3D effects, flat nav|
|<768px|Vertical stacked, flat layout|
|<480px|All 2D fallback, minimal layout|

Responsive handled via:

- CSS Grid + Flexbox
    
- `@media` queries
    
- Dynamic camera/canvas resizing:
    

js

CopyEdit

`window.addEventListener("resize", () => {   renderer.setSize(window.innerWidth, window.innerHeight);   camera.aspect = window.innerWidth / window.innerHeight;   camera.updateProjectionMatrix(); });`

---

## ✅ Work Breakdown Structure (WBS)

Sample Entries:

|Task ID|Task Name|Description|Tools|Day|Priority|
|---|---|---|---|---|---|
|1.1.1|Create Project Structure|`css/`, `js/`, `assets/` folders|Manual|Day 1|High|
|1.2.1|Add Three.js CDN|Script inclusion in HTML|Three.js CDN|Day 1|High|
|2.1.1|Scene Setup|Renderer, camera, scene init|Three.js|Day 1|High|
|3.1.2|3D Logo Creation|TextGeometry, materials|Three.js|Day 2|High|
|4.1.1|Color Palette|CylinderGeometry + material|Three.js|Day 3|High|
|6.1.1|Responsive Layout|Media queries for all breakpoints|CSS Media Queries|Day 6|High|

_(Full table contains 30+ tasks split by components and file-level granularity.)_

---

## 🔄 Task Dependency Flow

Each task is dependent on setup or prior elements. For example:

- `1.1.1` → `1.1.2` → `1.2.1/1.2.2` → `2.1.1` → `2.1.2`
    
- `3.1.1` (Font loading) must complete before `3.1.2` (Logo)
    

Graph Visual (Reference):  
📊 `Biple_Task_Dependencies.png` (dependency tree showing relationships)

---

## 🔧 Technologies Used

|Area|Tool/Library|
|---|---|
|3D Rendering|`Three.js`|
|Fonts|`Google Fonts`|
|Animations|`GSAP`|
|Styling|`CSS3`, Flex, Grid|
|Interaction|`Three.js Raycaster`, DOM JS|
|File Structure|`HTML + Vanilla JS` (non-Node)|

---

## 🔄 Next Step

> ✅ Let me know when you'd like to begin **Phase 1: Coding Setup**, and I’ll create the project with:

- `index.html`, `style.css`, `script.js`
    
- Fully responsive canvas
    
- Font & library links included
    
- Ready to expand section by section

## 🚧 Biple 3D Replica – Project Phases

### **🔹 Phase 1: Project Initialization**

> Objective: Set up the foundational structure and dependencies

- 🗂️ Create project folder structure (`css/`, `js/`, `assets/`)
    
- 🧾 Setup `index.html`, link to `style.css` and `script.js`
    
- 🌐 Integrate external libraries:
    
    - `Three.js` (via CDN)
        
    - `GSAP` (for animation)
        
    - `Google Fonts` (Outfit & Space Grotesk)
        
- 📏 Setup canvas and base renderer
    

---

### **🔹 Phase 2: Base 3D Scene**

> Objective: Prepare the rendering context and environment

- 🎥 Add `PerspectiveCamera` and `Scene`
    
- 💡 Add ambient and directional lighting
    
- 📐 Enable responsive resizing for canvas
    
- 🎨 Add background plane or flat gradient
    

---

### **🔹 Phase 3: 3D Logo & Typography**

> Objective: Create the core brand visual

- 🔤 Load custom font using `FontLoader`
    
- ✨ Create 3D text geometry for `Biple` with extrusion
    
- 🧊 Apply material: solid for most letters, glass/translucent for “p”
    
- 🌀 Add subtle animation (rotate, bounce)
    
- 🆎 Render typography samples (`Aa`, `AaBb123`) in styled blocks
    

---

### **🔹 Phase 4: UI Components**

> Objective: Build the interactive and visual UI pieces

- 🎯 **Color Palette Circles**
    
    - Create 3D circles with each BP brand color
        
    - Add hover scaling effects
        
- 🔍 **Search Bar**
    
    - HTML-based input + icon
        
    - Optionally map to 3D plane
        
- ☑️ **Checklist Card**
    
    - HTML/CSS checkbox group
        
    - Optional interactivity
        
- 🧭 **Sticky Navigation Bar**
    
    - Transparent, blurred background
        
    - Auto-hide on scroll
        

---

### **🔹 Phase 5: Advanced Visuals**

> Objective: Add support assets and visual polish

- 🔡 Typography blocks (`H1`, `H2`, `H3`) with size/weight specs
    
- 🎟️ CTA Buttons (filled, outline, animated)
    
- 🧱 Brand cards grid (2x3 layout with logo/icon samples)
    

---

### **🔹 Phase 6: Responsiveness & Optimization**

> Objective: Ensure mobile adaptability and visual finesse

- 📱 Apply media queries for tablet/mobile breakpoints
    
- 🪄 Minify and optimize CSS/JS
    
- 🧪 Cross-browser and device testing
    
- 🧼 Polish interaction timing and animations