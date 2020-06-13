GRID_W = 12
GRID_H = 12

hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid(hs.geometry(nil, nil, GRID_W, GRID_H)).setMargins("20x20")
hs.window.animationDuration = 0

hotKeys = {
    { { "cmd" }, "tab", function() focusMRU() end },
    { { "cmd", "ctrl" }, "n", function() hs.grid.pushWindowLeft() end },
    { { "cmd", "ctrl" }, "i", function() hs.grid.pushWindowRight() end },
    { { "cmd", "ctrl" }, "u", function() hs.grid.pushWindowUp() end },
    { { "cmd", "ctrl" }, "e", function() hs.grid.pushWindowDown() end },
    { { "cmd", "ctrl" }, "l", function() throwWindowLeft() end },
    { { "cmd", "ctrl" }, "y", function() throwWindowRight() end },
    { { "cmd", "ctrl" }, "m", function() throwWindowDown() end },
    { { "cmd", "ctrl" }, ",", function() throwWindowUp() end },
    { { "cmd", "ctrl" }, "o", function() hs.window.focusedWindow():centerOnScreen() end },
    { { "cmd", "ctrl" }, "r", function() hs.grid.resizeWindowThinner() end },
    { { "cmd", "ctrl" }, "t", function() hs.grid.resizeWindowWider() end },
    { { "cmd", "ctrl" }, "f", function() hs.grid.resizeWindowShorter() end },
    { { "cmd", "ctrl" }, "s", function() hs.grid.resizeWindowTaller() end },
    { { "cmd", "ctrl" }, "w", function() halfWindowWidth() end },
    { { "cmd", "ctrl" }, "p", function() doubleWindowWidth() end },
    { { "cmd", "ctrl" }, "v", function() doubleWindowHeight() end },
    { { "cmd", "ctrl" }, "c", function() halfWindowHeight() end },
    { { "cmd", "ctrl" }, "q", function() hs.grid.maximizeWindow() end },
    { { "cmd", "ctrl" }, "a", function() hs.grid.snap(hs.window.focusedWindow()) end },
    { { "ctrl" }, "5", function() openForSpace("iTerm", "New Window") end },
    { { "ctrl" }, "6", function() openForSpace("Safari", "New Window") end },
    { { "alt" }, "q", function() hs.eventtap.keyStrokes(utf8.char(772)) end },
    { { "alt" }, "w", function() hs.eventtap.keyStrokes(utf8.char(769)) end },
    { { "alt" }, "f", function() hs.eventtap.keyStrokes(utf8.char(780)) end },
    { { "alt" }, "p", function() hs.eventtap.keyStrokes(utf8.char(768)) end },
    { { "alt" }, "v", function() hs.eventtap.keyStrokes(utf8.char(252)) end },
    { { "alt", "shift" }, "v", function() hs.eventtap.keyStrokes(utf8.char(220)) end },
    -- For volume control on gamepad
    { {}, "f11", function() volumeDown() end },
    { {}, "f12", function() volumeUp() end },
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
    local mods = hs.eventtap.checkKeyboardModifiers()
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

function focusMRU()
    for _, window in ipairs(hs.window.filter.defaultCurrentSpace:getWindows()) do
        if window ~= hs.window.focusedWindow() then
            window:focus()
            return
        end
    end
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

function volumeDown()
    hs.eventtap.event.newSystemKeyEvent("SOUND_DOWN", true):post()
    hs.eventtap.event.newSystemKeyEvent("SOUND_DOWN", false):post()
end

function volumeUp()
    hs.eventtap.event.newSystemKeyEvent("SOUND_UP", true):post()
    hs.eventtap.event.newSystemKeyEvent("SOUND_UP", false):post()
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
