
console.log("VSCODE-CUSTOM-CSS-JS: Script execution started."); // <--- ADD THIS

// https://www.reddit.com/r/vscode/comments/11e66xh/i_made_neovide_alike_cursor_effect_on_vscode/

// Configuration

// Set the color of the cursor trail to match the user's cursor color
const Color = "default" // If set to "default," it will use the theme's cursor color.
// ! default will only reference editorCursor.background
// "workbench.colorCustomizations": {
//     "editorCursor.background": "#A052FF",
// }

// Set the style of the cursor to either a line or block
// line option use fill() to draw trail, block option use lineTo to draw trail
const CursorStyle = "block" // Options are 'line' or 'block'

// Set the length of the cursor trail. A higher value may cause lag.
const TrailLength = 8 // Recommended value is around 8

// Set the polling rate for handling cursor created and destroyed events, in milliseconds.
const CursorUpdatePollingRate = 500 // Recommended value is around 500

// Use shadow
const UseShadow = false
const ShadowColor = Color
const ShadowBlur = 15


// imported from https://github.com/tholman/cursor-effects/blob/master/src/rainbowCursor.js
function createTrail(options) {
  console.log("VSCODE-CUSTOM-CSS-JS: createTrail function called."); // <--- ADD THIS
  const totalParticles = options?.length || 20
  // ... (rest of createTrail function) ...
  return {
    updateParticles: updateParticles,
    move: move,
    updateSize: updateSize,
    updateCursorSize: updateCursorSize
  }
}

// cursor create/remove/move event handler
// by qwreey
// (very dirty but may working)
async function createCursorHandler(handlerFunctions) {
  console.log("VSCODE-CUSTOM-CSS-JS: createCursorHandler function called."); // <--- ADD THIS
  // Get Editor with dirty way (... due to vscode plugin api's limit)
  /** @type { Element } */
  let editor
  console.log("VSCODE-CUSTOM-CSS-JS: Waiting for editor element..."); // <--- ADD THIS
  while (!editor) {
    await new Promise(resolve=>setTimeout(resolve, 100))
    editor = document.querySelector(".part.editor")
  }
  console.log("VSCODE-CUSTOM-CSS-JS: Editor element found:", editor); // <--- ADD THIS
  handlerFunctions?.onStarted(editor)

  // ... (rest of createCursorHandler function) ...

  // handle cursor create/destroy event (using polling, due to event handlers are LAGGY)
  let lastVisibility = "hidden"
  setInterval(async ()=>{
    console.log("VSCODE-CUSTOM-CSS-JS: Cursor polling interval fired."); // <--- ADD THIS
    let now = [],count = 0
    // created
    for (const target of editor.getElementsByClassName("cursor")) {
      if (target.style.visibility != "hidden") count++
      if (target.hasAttribute("cursorId")) {
        now.push(+target.getAttribute("cursorId"))
        continue
      }
      let thisCursorId = cursorId++
      now.push(thisCursorId)
      lastObjects[thisCursorId] = target
      target.setAttribute("cursorId",thisCursorId)
      let cursorHolder = target.parentElement.parentElement.parentElement
      let minimap = cursorHolder.parentElement.querySelector(".minimap")
      createCursorUpdateHandler(target,thisCursorId,cursorHolder,minimap)
      console.log("VSCODE-CUSTOM-CSS-JS: New cursor detected/handler created:", thisCursorId); // <--- ADD THIS
    }
    
    // update visible
    let visibility = count<=1 ? "visible" : "hidden"
    if (visibility != lastVisibility) {
      console.log("VSCODE-CUSTOM-CSS-JS: Cursor visibility changed to:", visibility); // <--- ADD THIS
      handlerFunctions?.onCursorVisibilityChanged(visibility)
      lastVisibility = visibility
    }

    // destroyed
    for (const id in lastObjects) {
      if (now.includes(+id)) continue
      delete lastObjects[+id]
      console.log("VSCODE-CUSTOM-CSS-JS: Cursor removed:", +id); // <--- ADD THIS
    }
  },handlerFunctions?.cursorUpdatePollingRate || 500)

  // read cursor position polling
  function updateLoop() {
    // console.log("VSCODE-CUSTOM-CSS-JS: updateLoop animation frame."); // <--- CAUTION: VERY FREQUENT
    let {left:editorX,top:editorY} = editor.getBoundingClientRect()
    for (handler of updateHandlers) handler(editorX,editorY)
    handlerFunctions?.onLoop()
    requestAnimationFrame(updateLoop)
  }

  // ... (rest of createCursorHandler function) ...
  
  // startup
  updateLoop()
  handlerFunctions?.onReady()
  console.log("VSCODE-CUSTOM-CSS-JS: createCursorHandler setup complete."); // <--- ADD THIS
}

// Main handler code
let cursorCanvas,rainbowCursorHandle
console.log("VSCODE-CUSTOM-CSS-JS: About to call createCursorHandler."); // <--- ADD THIS
createCursorHandler({

  // cursor create/destroy event handler polling rate
  cursorUpdatePollingRate: CursorUpdatePollingRate,

  // When editor instance stared
  onStarted: (editor)=>{
    console.log("VSCODE-CUSTOM-CSS-JS: onStarted callback executed."); // <--- ADD THIS
    // create new canvas for make animation
    cursorCanvas = document.createElement("canvas")
    cursorCanvas.style.pointerEvents = "none"
    // ... (rest of onStarted) ...
    console.log("VSCODE-CUSTOM-CSS-JS: Canvas created and rainbowCursorHandle initialized."); // <--- ADD THIS
  },

  onReady:()=>{
    console.log("VSCODE-CUSTOM-CSS-JS: onReady callback executed."); // <--- ADD THIS
  },

  // when cursor moved
  onCursorPositionUpdated: (x,y)=>{
    // console.log(`VSCODE-CUSTOM-CSS-JS: onCursorPositionUpdated: x=${x}, y=${y}`); // <--- CAUTION: VERY FREQUENT
    if (rainbowCursorHandle) rainbowCursorHandle.move(x,y); else console.warn("VSCODE-CUSTOM-CSS-JS: rainbowCursorHandle not ready for move");
  },

  // when editor view size changed
  onEditorSizeUpdated: (x,y)=>{
    console.log(`VSCODE-CUSTOM-CSS-JS: onEditorSizeUpdated: width=${x}, height=${y}`); // <--- ADD THIS
    if (rainbowCursorHandle) rainbowCursorHandle.updateSize(x,y); else console.warn("VSCODE-CUSTOM-CSS-JS: rainbowCursorHandle not ready for updateSize");
  },

  // when cursor size changed (emoji, ...)
  onCursorSizeUpdated: (x,y)=>{
    console.log(`VSCODE-CUSTOM-CSS-JS: onCursorSizeUpdated: width=${x}, height=${y}`); // <--- ADD THIS
    if (rainbowCursorHandle) rainbowCursorHandle.updateCursorSize(x,y); else console.warn("VSCODE-CUSTOM-CSS-JS: rainbowCursorHandle not ready for updateCursorSize");
  },

  // when using multi cursor... just hide all
  onCursorVisibilityChanged: (visibility)=>{
    console.log(`VSCODE-CUSTOM-CSS-JS: onCursorVisibilityChanged: ${visibility}`); // <--- ADD THIS
    if (cursorCanvas) cursorCanvas.style.visibility = visibility; else console.warn("VSCODE-CUSTOM-CSS-JS: cursorCanvas not ready for visibility change");
  },

  // update animation
  onLoop: ()=>{
    // console.log("VSCODE-CUSTOM-CSS-JS: onLoop callback executed."); // <--- CAUTION: VERY FREQUENT
    if (rainbowCursorHandle) rainbowCursorHandle.updateParticles(); else console.warn("VSCODE-CUSTOM-CSS-JS: rainbowCursorHandle not ready for updateParticles");
  },

})
console.log("VSCODE-CUSTOM-CSS-JS: Script execution finished (initial setup)."); // <--- ADD THIS
