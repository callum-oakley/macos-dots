GRID_W = 12
GRID_H = 12

GRID_MARGIN = {{grid_margin}}

hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid(hs.geometry(nil, nil, GRID_W, GRID_H))
    .setMargins({ GRID_MARGIN, GRID_MARGIN })
hs.window.animationDuration = 0

function indexOf(table, elem)
    for i, x in ipairs(table) do
        if x == elem then
            return i
        end
    end
    -- we're going to sort with this function, so math.huge ensures elements
    -- that aren't found get pushed to the end
    return math.huge
end

function filter(from, f)
    local filtered = {}
    for _, x in ipairs(from) do
        if f(x) then
            table.insert(filtered, x)
        end
    end
    return filtered
end

mruWindows = {}
mruWindowIndex = math.huge

-- Syncs up the window state with reality and moves the currently focused
-- window to the top of the stack. We want to call this on cmd down (about to
-- start changing focus) and cmd up (finished changing focus).
function refreshWindowState()
    local windows = filter(
        hs.window.filter.defaultCurrentSpace:getWindows(),
        function(window) return window:isStandard() end
    )

    -- preserve the order from the last state
    table.sort(windows, function(a, b)
        return indexOf(mruWindows, a) < indexOf(mruWindows, b)
    end)

    mruWindows = windows

    mruWindowIndex = indexOf(mruWindows, hs.window.focusedWindow())

    if mruWindowIndex == math.huge or mruWindowIndex == 1 then
        return
    end

    window = table.remove(mruWindows, mruWindowIndex)
    table.insert(mruWindows, 1, window)

    mruWindowIndex = 1
end

-- Changes focus to the next (direction=1) or previous (direction=-1) window,
-- in order of most recent use.
function changeFocus(direction)
    if #mruWindows == 0 then
        return
    end

    if mruWindowIndex == math.huge then
        mruWindowIndex = 1
    else
        -- god I hate one indexing...
        mruWindowIndex = (mruWindowIndex + direction - 1) % #mruWindows + 1
    end

    mruWindows[mruWindowIndex]:focus()
end

function centerWindow()
    hs.window.focusedWindow():centerOnScreen()
end

function snapWindow()
    hs.grid.snap(hs.window.focusedWindow())
end

function throwWindowLeft()
    hs.grid.adjustWindow(function(cell)
        cell.x = 0
    end)
end

function throwWindowRight()
    hs.grid.adjustWindow(function(cell)
        cell.x = GRID_W - cell.w
    end)
end

function throwWindowUp()
    hs.grid.adjustWindow(function(cell)
        cell.y = 0
    end)
end

function throwWindowDown()
    hs.grid.adjustWindow(function(cell)
        cell.y = GRID_H - cell.h
    end)
end

function halfWindowWidth()
    hs.grid.adjustWindow(function(cell)
        cell.w = cell.w // 2
    end)
end

function doubleWindowWidth()
    hs.grid.adjustWindow(function(cell)
        cell.w = 2 * cell.w
        cell.x = math.min(cell.x, GRID_W - cell.w)
    end)
end

function halfWindowHeight()
    hs.grid.adjustWindow(function(cell)
        cell.h = cell.h // 2
    end)
end

function doubleWindowHeight()
    hs.grid.adjustWindow(function(cell)
        cell.h = 2 * cell.h
        cell.y = math.min(cell.y, GRID_H - cell.h)
    end)
end

maximizedWindows = {}

function isMaximized(window)
    local windowFrame = window:frame()
    local screenFrame = hs.screen.mainScreen():frame()
    return windowFrame.h + 2 * GRID_MARGIN == screenFrame.h and
        windowFrame.w + 2 * GRID_MARGIN == screenFrame.w
end

function toggleMaximizeWindow()
    local window = hs.window.focusedWindow()
    if isMaximized(window) and maximizedWindows[window:id()] then
        window:setFrame(maximizedWindows[window:id()])
        maximizedWindows[window:id()] = nil
    else
        maximizedWindows[window:id()] = window:frame()
        hs.grid.maximizeWindow(window)
    end
end

function openForSpace(name, menuItem)
    hs.application.launchOrFocus(name)
    local app = hs.application.find(name)
    if #app:visibleWindows() == 0 then
        app:selectMenuItem(menuItem)
    end
end

hotKeys = {
    { { "cmd" }, "tab", function()
        changeFocus(1)
    end },
    { { "cmd", "shift" }, "tab", function()
        changeFocus(-1)
    end },
    { { "ctrl" }, "left", hs.grid.pushWindowLeft },
    { { "ctrl" }, "right", hs.grid.pushWindowRight },
    { { "ctrl" }, "up", hs.grid.pushWindowUp },
    { { "ctrl" }, "down", hs.grid.pushWindowDown },
    { { "ctrl", "cmd" }, "left", throwWindowLeft },
    { { "ctrl", "cmd" }, "right", throwWindowRight },
    { { "ctrl" }, "pagedown", throwWindowDown },
    { { "ctrl" }, "pageup", throwWindowUp },
    { { "ctrl" }, "delete", centerWindow },
    { { "ctrl" }, "return", toggleMaximizeWindow },
    { { "shift", "ctrl" }, "left", hs.grid.resizeWindowThinner },
    { { "shift", "ctrl" }, "right", hs.grid.resizeWindowWider },
    { { "shift", "ctrl" }, "up", hs.grid.resizeWindowShorter },
    { { "shift", "ctrl" }, "down", hs.grid.resizeWindowTaller },
    { { "shift", "ctrl", "cmd" }, "left", halfWindowWidth },
    { { "shift", "ctrl", "cmd" }, "right", doubleWindowWidth },
    { { "shift", "ctrl" }, "pagedown", doubleWindowHeight },
    { { "shift", "ctrl" }, "pageup", halfWindowHeight },
    { { "shift", "ctrl" }, "delete", snapWindow },
    { { "cmd", "ctrl" }, "t", function()
        openForSpace("kitty", "New OS window")
    end },
    { { "cmd", "ctrl" }, "s", function()
        openForSpace("Safari", "New Window")
    end },
    { { "cmd", "ctrl" }, "r", function()
        openForSpace("iA Writer", "New in Library")
    end },
    { { "alt" }, "q", function()
        hs.eventtap.keyStrokes(utf8.char(772)) -- ◌̄
    end },
    { { "alt" }, "w", function()
        hs.eventtap.keyStrokes(utf8.char(769)) -- ◌́
    end },
    { { "alt" }, "f", function()
        hs.eventtap.keyStrokes(utf8.char(780)) -- ◌̌
    end },
    { { "alt" }, "p", function()
        hs.eventtap.keyStrokes(utf8.char(768)) -- ◌̀
    end },
    { { "alt" }, "v", function()
        hs.eventtap.keyStrokes(utf8.char(252)) -- ü
    end },
    { { "alt", "shift" }, "v", function()
        hs.eventtap.keyStrokes(utf8.char(220)) -- Ü
    end },
}

hotKeysExpanded = {}
for _, hotKey in ipairs(hotKeys) do
    local mods = {}
    for _, mod in ipairs(hotKey[1]) do
        if mod == "cmd" then
            mods.cmd = true
        elseif mod == "alt" then
            mods.alt = true
        elseif mod == "ctrl" then
            mods.ctrl = true
        elseif mod == "shift" then
            mods.shift = true
        end
    end
    table.insert(hotKeysExpanded, {
        mods = mods,
        keyCode = hs.keycodes.map[hotKey[2]],
        f = hotKey[3],
    })
end

keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local mods = e:getFlags()
    for _, hotKey in ipairs(hotKeysExpanded) do
        if e:getKeyCode() == hotKey.keyCode and
            mods.cmd == hotKey.mods.cmd and
            mods.alt == hotKey.mods.alt and
            mods.ctrl == hotKey.mods.ctrl and
            mods.shift == hotKey.mods.shift then
            hotKey.f()
            return true
        end
    end
end):start()

flagsChangedTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
    -- cmd up or down
    if hs.eventtap.checkKeyboardModifiers().cmd ~= e:getFlags().cmd then
        refreshWindowState()
    end
end):start()

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
