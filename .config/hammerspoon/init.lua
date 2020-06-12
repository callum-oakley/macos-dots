GRID_W = 12
GRID_H = 12

hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid(hs.geometry(nil, nil, GRID_W, GRID_H)).setMargins("25x25")
hs.window.animationDuration = 0
hs.alert.defaultStyle.fillColor = { alpha = 0 }
hs.alert.defaultStyle.strokeColor = { alpha = 0 }

hotKeys = {
    { { "cmd" }, "tab", function() focusMRU() end },
    { { "ctrl" }, "1", function() changeDesktop(1) end, true },
    { { "ctrl" }, "2", function() changeDesktop(2) end, true },
    { { "ctrl" }, "3", function() changeDesktop(3) end, true },
    { { "ctrl" }, "4", function() changeDesktop(4) end, true },
    { { "ctrl", "shift" }, "1", function() changeDesktop(5) end, true },
    { { "ctrl", "shift" }, "2", function() changeDesktop(6) end, true },
    { { "ctrl", "shift" }, "3", function() changeDesktop(7) end, true },
    { { "ctrl", "shift" }, "4", function() changeDesktop(8) end, true },
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
    { {}, "f11", function() changeVolume(-1) end },
    { { "ctrl" }, "f11", function() changeVolume(-2) end },
    { { "alt" }, "f11", function() changeVolume(-4) end },
    { { "cmd" }, "f11", function() changeVolume(-8) end },
    { {}, "f12", function() changeVolume(1) end },
    { { "ctrl" }, "f12", function() changeVolume(2) end },
    { { "alt" }, "f12", function() changeVolume(4) end },
    { { "cmd" }, "f12", function() changeVolume(8) end },
    { { "ctrl" }, "5", function() openForSpace("iTerm", "New Window") end },
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
    mods = {}
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
        done = not hotKey[4],
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
            return hotKey.done
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

function changeDesktop(desktop)
    hs.execute("echo " .. desktop .. " > ~/.desktop")
    reloadBar()
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

targetVolume = nil
function changeVolume(diff)
    if targetVolume == nil then
        targetVolume =
            math.floor(hs.audiodevice.defaultOutputDevice():volume())
    end
    targetVolume = math.min(100, math.max(0, targetVolume + diff))
    if targetVolume > 0 then
        hs.audiodevice.defaultOutputDevice():setMuted(false)
    end
    hs.audiodevice.defaultOutputDevice():setVolume(targetVolume)

    hs.execute("echo " .. targetVolume .. " > ~/.volume")
    reloadBar()
end

function reloadBar()
    hs.execute(
        "osascript -e 'tell application id \"tracesOf.Uebersicht\" to refresh widget id \"bar-jsx\"'"
    )
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
