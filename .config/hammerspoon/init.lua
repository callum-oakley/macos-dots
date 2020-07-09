GRID_W = 12
GRID_H = 12

hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid(hs.geometry(nil, nil, GRID_W, GRID_H)).setMargins("25x25")
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

-- moves to the next (direction=1) or previous (direction=-1) window, in order
-- of most recent use.
function changeFocus(direction)
    -- refresh the window state
    local windows = filter(
        hs.window.filter.defaultCurrentSpace:getWindows(),
        function(window) return window:isStandard() end
    )

    -- but preserve the order from the last state
    table.sort(windows, function(a, b)
        return indexOf(mruWindows, a) < indexOf(mruWindows, b)
    end)
    mruWindows = windows

    if #mruWindows == 0 then
        return
    end

    local current = indexOf(mruWindows, hs.window.focusedWindow())
    if current == math.huge then
        mruWindows[1]:focus()
    else
        -- god I hate one indexing...
        mruWindows[(current + direction - 1) % #mruWindows + 1]:focus()
    end
end

-- promotes the currently focussed window to be considered "used" (bump it to
-- the top of the MRU table)
function promoteCurrentlyFocusedWindow()
    local current = indexOf(mruWindows, hs.window.focusedWindow())
    if current == 1 or current == math.huge then
        return
    end
    window = table.remove(mruWindows, current)
    table.insert(mruWindows, 1, window)
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

function openForSpace(name, menuItem)
    hs.application.launchOrFocus(name)
    local app = hs.application.find(name)
    if #app:visibleWindows() == 0 then app:selectMenuItem(menuItem) end
end

hotKeys = {
    { { "cmd" }, "tab", function() changeFocus(1) end },
    { { "cmd", "shift" }, "tab", function() changeFocus(-1) end },
    { { "cmd", "ctrl" }, "n", hs.grid.pushWindowLeft },
    { { "cmd", "ctrl" }, "i", hs.grid.pushWindowRight },
    { { "cmd", "ctrl" }, "u", hs.grid.pushWindowUp },
    { { "cmd", "ctrl" }, "e", hs.grid.pushWindowDown },
    { { "cmd", "ctrl" }, "l", throwWindowLeft },
    { { "cmd", "ctrl" }, "y", throwWindowRight },
    { { "cmd", "ctrl" }, "m", throwWindowDown },
    { { "cmd", "ctrl" }, ",", throwWindowUp },
    { { "cmd", "ctrl" }, "o", centerWindow },
    { { "cmd", "ctrl" }, "r", hs.grid.resizeWindowThinner },
    { { "cmd", "ctrl" }, "t", hs.grid.resizeWindowWider },
    { { "cmd", "ctrl" }, "f", hs.grid.resizeWindowShorter },
    { { "cmd", "ctrl" }, "s", hs.grid.resizeWindowTaller },
    { { "cmd", "ctrl" }, "w", halfWindowWidth },
    { { "cmd", "ctrl" }, "p", doubleWindowWidth },
    { { "cmd", "ctrl" }, "v", doubleWindowHeight },
    { { "cmd", "ctrl" }, "c", halfWindowHeight },
    { { "cmd", "ctrl" }, "q", hs.grid.maximizeWindow },
    { { "cmd", "ctrl" }, "a", snapWindow },
    { { "ctrl" }, "5", function() openForSpace("kitty", "New OS window") end },
    { { "ctrl" }, "6", function() openForSpace("Safari", "New Window") end },
    { { "alt" }, "q", function() hs.eventtap.keyStrokes(utf8.char(772)) end },
    { { "alt" }, "w", function() hs.eventtap.keyStrokes(utf8.char(769)) end },
    { { "alt" }, "f", function() hs.eventtap.keyStrokes(utf8.char(780)) end },
    { { "alt" }, "p", function() hs.eventtap.keyStrokes(utf8.char(768)) end },
    { { "alt" }, "v", function() hs.eventtap.keyStrokes(utf8.char(252)) end },
    { { "alt", "shift" }, "v", function() hs.eventtap.keyStrokes(utf8.char(220)) end },
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
    if hs.eventtap.checkKeyboardModifiers().cmd ~= e:getFlags().cmd then
        -- changeFocus(0) has no effect if a window is already focused, but
        -- serves the purpose here of focusing the most recently used window
        -- after closing another window with cmd-w
        changeFocus(0)
        promoteCurrentlyFocusedWindow()
    end
end):start()

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
