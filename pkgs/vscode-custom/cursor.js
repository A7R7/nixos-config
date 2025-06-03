async function getFirstChildWhenExist(parent, className) {
    let children = parent.getElementsByClassName(className)
    return new Promise((resolve, reject) => {
        if (children[0]) {
            // console.log("DEBUG: childExist: child found immediately", children[0])
            resolve(children[0])
            return
        }
        let obs = new MutationObserver((mutList, obs) => {
            if (children[0]) {
                obs.disconnect()
                // console.log("DEBUG: childExist: child found", children[0])
                resolve(children[0])
                return
            }
        })
        obs.observe(parent, {
            childList: true,
            subtree: true
        })
        // setTimeout(() => {
        //     obs.disconnect()
        //     reject(new Error("DEBUG: Timeout: child not found"))
        // }, 10000) // 10-second timeout
    })
}

class CanvasHandler {
    constructor(document) {
        let canvas = document.createElement("canvas")
        canvas.style.pointerEvents = "none"
        canvas.style.position = "absolute"
        canvas.style.top = "0px"
        canvas.style.left = "0px"
        canvas.style.zIndex = "1000"
        document.appendChild(canvas)
        console.log("DEBUG: canvas created", canvas)
        this.canvas = canvas
    }


    setOffsetCoords(x, y) {
        this.offsetX = x
        this.offsetY = y
    }

    setRevCoords(x, y) {
        if (x == this.revX && y == this.revY) return
        if (this.revX == undefined || this.revY == undefined) {
            this.revX = x
            this.revY = y
            this.trailX = x
            this.trailY = y
            return
        }
        this.ready = true
        this.trailX = this.revX
        this.trailY = this.revY
        this.revX = x
        this.revY = y
    }

    setSize(w, h) {
        this.w = w
        this.h = h
    }

    updateCoords() {
        
    }

    onLoop(timestamp) {
        if (!this.ready) return
        this.updateCoords()
    }
}

class CoordsHandler {
    constructor(document, canvasHandler) {
        this.document = document
        this.canvasHandler = canvasHandler
        this.init()
    }

    async init() {
        await this.getEditor()
        await this.getGroup()
        await this.getTab() 
        await this.getCursor()
        // this.getPage()
        // this.getGroupObs()
        // this.getTabObs()
        // this.getCursorObs()
    }

    async getEditor() {
        this.editor = await getFirstChildWhenExist(this.document.body, "part editor")
    }

    async getGroup() {
        // get active (focused) tab group from editor
        // this.group = this.editor.getElementsByClassName("editor-group-container active")[0]
        this.group = await getFirstChildWhenExist(this.editor, "editor-group-container active");
        console.log('DEBUG: got group', this.group)

    // }

    // getGroupObs() {
        if (this.groupObs) this.groupObs.disconnect()
        this.groupObs = new MutationObserver(async (_list, _obs) => {
            if (this.groupObsLock == true) return
            console.log('DEBUG: groupObs triggered')
            this.groupObsLock = true
            await this.updateGroup()
            this.groupObsLock = false
        }) // triggers when switch group
        this.groupObs.observe(this.group, { attributeFilter: ["class"] })
    }

    async getTab() {
        // get current tab of the tab group
        // this.tab = this.group.getElementsByClassName("editor-instance")[0]
        this.tab = await getFirstChildWhenExist(this.group, "editor-instance")
        console.log('DEBUG: got tab', this.tab)
    // }

    // getTabObs() {
        if (this.tabObs) this.tabObs.disconnect()
        this.tabObs = new MutationObserver(async (_list, _obs) => {
            // no need to updateTab(), tab dom isn't deleted
            if (this.tabObsLock == true) return
            console.log('DEBUG: tabObs triggered')
            this.tabObsLock = true
            await this.updateCursor()
            this.tabObsLock = false
        }) // triggers when switch tab
        this.tabObs.observe(this.tab, { attributes: true })

        this.tabResizeObs = new ResizeObserver(() => {
            this.updateOffsetCoords()
        })
        this.tabResizeObs.observe(this.tab)
    }

    async getCursor() {
        // get cursor from tab
        // if there're multiple cursors, the first child is primary cursor
        // this.cursor = this.tab.getElementsByClassName("cursor")[0]
        this.cursor = await getFirstChildWhenExist(this.tab, "cursor")
        console.log('DEBUG:: got cursor', this.cursor)
        this.page = this.cursor.parentElement.parentElement
        console.log('DEBUG:: got page', this.page)

        if (this.cursorObs) this.cursorObs.disconnect()
        this.cursorObs = new MutationObserver((_list, _obs) => {
            // console.log('DEBUG: cursorObs triggered')
            // setTimeout(() => this.onCursorSizeUpdate(), 17) // a frame
            this.updateCoords()
        }) // triggers when move cursor
        this.cursorObs.observe(this.cursor, { attributeFilter: ["style"] })
    }
    
    async updateGroup() {
        await this.getGroup()
        await this.updateTab()
        this.updateCoords()
    }
    async updateTab() {
        await this.getTab()
        await this.updateCursor()
    }
    async updateCursor() {
        await this.getCursor()
        // this.onCursorMove() // will get (0,0)
    }

    updateCoords() {
        let cursorStyle = this.cursor.style
        let w = parseFloat(cursorStyle.width)
        let h = parseFloat(cursorStyle.height)
        let revX = parseFloat(cursorStyle.left)
        let revY = parseFloat(cursorStyle.top)
        console.log("DEBUG: rev: x:", revX, "y:", revY)
        this.canvasHandler.setSize(w, h)
        this.canvasHandler.setRevCoords(revX, revY)
        // "Size" means size and pos
    }

    updateOffsetCoords() {
        let pageRect = this.page.getBoundingClientRect()
        this.canvasHandler.setOffsetCoords(pageRect.x, pageRect.y)
    }
}


// main 
async function main() {
    // create canvas and add to editor
    let canvasHandler = new CanvasHandler(document)
    let coordsHandler = new CoordsHandler(document, canvasHandler)

    // main loop
    function updateLoop(timestamp) {
        canvasHandler.onLoop(timestamp)
        requestAnimationFrame(updateLoop)
    }
    updateLoop()
}
main()