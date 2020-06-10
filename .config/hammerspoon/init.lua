hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid("12x12").setMargins("20x20")
hs.window.animationDuration = 0
hs.alert.defaultStyle.fillColor = { alpha = 0 }
hs.alert.defaultStyle.strokeColor = { alpha = 0 }

hs.hotkey.bind({"cmd", "ctrl"}, "n",
               function() openForSpace("iTerm", "New Window") end)
hs.hotkey.bind({"cmd", "ctrl"}, "e",
               function() openForSpace("Safari", "New Window") end)
hs.hotkey.bind({"cmd", "ctrl"}, "i",
               function() openForSpace("iA Writer", "New in Library") end)
hs.hotkey.bind({"cmd", "ctrl"}, "o",
               function() openForSpace("Things", "New Things Window") end)
hs.hotkey.bind({"alt"}, "q",
               function() hs.eventtap.keyStrokes(utf8.char(772)) end)
hs.hotkey.bind({"alt"}, "w",
               function() hs.eventtap.keyStrokes(utf8.char(769)) end)
hs.hotkey.bind({"alt"}, "f",
               function() hs.eventtap.keyStrokes(utf8.char(780)) end)
hs.hotkey.bind({"alt"}, "p",
               function() hs.eventtap.keyStrokes(utf8.char(768)) end)
hs.hotkey.bind({"alt"}, "u",
               function() hs.eventtap.keyStrokes(utf8.char(776)) end)
hs.hotkey.bind({"cmd", "ctrl"}, "left",
               function() hs.window.filter.defaultCurrentSpace:focusWindowWest(nil,nil,nil) end)
hs.hotkey.bind({"cmd", "ctrl"}, "right",
               function() hs.window.filter.defaultCurrentSpace:focusWindowEast(nil,nil,nil) end)

function windowHotKeyConf(key, shift, alt)
    return {
        keyCode = hs.keycodes.map[key],
        mods = {cmd = true, alt = alt, ctrl = true, shift = shift}
    }
end

windowHotkeys = {
    ["1,0 4x12"] = windowHotKeyConf("q", false, false),
    ["0,0 4x12"] = windowHotKeyConf("w", false, false),
    ["4,0 4x12"] = windowHotKeyConf("f", false, false),
    ["8,0 4x12"] = windowHotKeyConf("p", false, false),
    ["7,0 4x12"] = windowHotKeyConf("g", false, false),

    ["1,0 6x12"] = windowHotKeyConf("a", false, false),
    ["0,0 6x12"] = windowHotKeyConf("r", false, false),
    ["3,0 6x12"] = windowHotKeyConf("s", false, false),
    ["6,0 6x12"] = windowHotKeyConf("t", false, false),
    ["5,0 6x12"] = windowHotKeyConf("d", false, false),

    ["2,0 4x12"] = windowHotKeyConf("z", false, false),
    ["0,0 8x12"] = windowHotKeyConf("x", false, false),
    ["2,0 8x12"] = windowHotKeyConf("c", false, false),
    ["4,0 8x12"] = windowHotKeyConf("v", false, false),
    ["6,0 4x12"] = windowHotKeyConf("b", false, false),

    ["0,0 12x12"] = windowHotKeyConf("tab", false, false),
    ["1,0 10x12"] = windowHotKeyConf("delete", false, false),

    ["1,0 5x12"] = windowHotKeyConf("q", false, true),
    ["0,0 5x12"] = windowHotKeyConf("w", false, true),
    ["3.5,0 5x12"] = windowHotKeyConf("f", false, true),
    ["7,0 5x12"] = windowHotKeyConf("p", false, true),
    ["6,0 5x12"] = windowHotKeyConf("g", false, true),

    ["1,0 7x12"] = windowHotKeyConf("a", false, true),
    ["0,0 7x12"] = windowHotKeyConf("r", false, true),
    ["2.5,0 7x12"] = windowHotKeyConf("s", false, true),
    ["5,0 7x12"] = windowHotKeyConf("t", false, true),
    ["4,0 7x12"] = windowHotKeyConf("d", false, true),

    ["0,0 9x12"] = windowHotKeyConf("x", false, true),
    ["1.5,0 9x12"] = windowHotKeyConf("c", false, true),
    ["3,0 9x12"] = windowHotKeyConf("v", false, true),

    ["0.5,0 11x12"] = windowHotKeyConf("delete", false, true),

    ["1,1 4x10"] = windowHotKeyConf("q", true, false),
    ["0,1 4x10"] = windowHotKeyConf("w", true, false),
    ["4,1 4x10"] = windowHotKeyConf("f", true, false),
    ["8,1 4x10"] = windowHotKeyConf("p", true, false),
    ["7,1 4x10"] = windowHotKeyConf("g", true, false),

    ["1,1 6x10"] = windowHotKeyConf("a", true, false),
    ["0,1 6x10"] = windowHotKeyConf("r", true, false),
    ["3,1 6x10"] = windowHotKeyConf("s", true, false),
    ["6,1 6x10"] = windowHotKeyConf("t", true, false),
    ["5,1 6x10"] = windowHotKeyConf("d", true, false),

    ["2,1 4x10"] = windowHotKeyConf("z", true, false),
    ["0,1 8x10"] = windowHotKeyConf("x", true, false),
    ["2,1 8x10"] = windowHotKeyConf("c", true, false),
    ["4,1 8x10"] = windowHotKeyConf("v", true, false),
    ["6,1 4x10"] = windowHotKeyConf("b", true, false),

    ["1,1 5x10"] = windowHotKeyConf("q", true, true),
    ["0,1 5x10"] = windowHotKeyConf("w", true, true),
    ["3.5,1 5x10"] = windowHotKeyConf("f", true, true),
    ["7,1 5x10"] = windowHotKeyConf("p", true, true),
    ["6,1 5x10"] = windowHotKeyConf("g", true, true),

    ["1,1 7x10"] = windowHotKeyConf("a", true, true),
    ["0,1 7x10"] = windowHotKeyConf("r", true, true),
    ["2.5,1 7x10"] = windowHotKeyConf("s", true, true),
    ["5,1 7x10"] = windowHotKeyConf("t", true, true),
    ["4,1 7x10"] = windowHotKeyConf("d", true, true),

    ["0,1 9x10"] = windowHotKeyConf("x", true, true),
    ["1.5,1 9x10"] = windowHotKeyConf("c", true, true),
    ["3,1 9x10"] = windowHotKeyConf("v", true, true),

    ["0.5,1 11x10"] = windowHotKeyConf("delete", true, true),
}

keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local mods = hs.eventtap.checkKeyboardModifiers()
    local keyCode = e:getKeyCode()

    for pos, hotkey in pairs(windowHotkeys) do
        if keyCode == hotkey.keyCode and
            not not mods.ctrl == hotkey.mods.ctrl and
            not not mods.alt == hotkey.mods.alt and
            not not mods.cmd == hotkey.mods.cmd and
            not not mods.shift == hotkey.mods.shift then
            hs.grid.set(hs.window.frontmostWindow(), pos)
            return true
        end
    end

    if keyCode == hs.keycodes.map["f11"] then
        if mods.cmd then
            changeVolume(-8)
        elseif mods.alt then
            changeVolume(-4)
        elseif mods.ctrl then
            changeVolume(-2)
        else
            changeVolume(-1)
        end
        return true
    end

    if keyCode == hs.keycodes.map["f12"] then
        if mods.cmd then
            changeVolume(8)
        elseif mods.alt then
            changeVolume(4)
        elseif mods.ctrl then
            changeVolume(2)
        else
            changeVolume(1)
        end
        return true
    end
end):start()

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
    hs.alert.closeAll(0.0)

    hs.alert.show(string.rep("\u{25cf}", targetVolume), {
        textSize = 8,
        fadeInDuration = 0,
        fadeOutDuration = 0,
        atScreenEdge = 2,
    })
    hs.audiodevice.defaultOutputDevice():setVolume(targetVolume)
end

function openForSpace(name, menuItem)
    hs.application.launchOrFocus(name)

    local app = hs.application.find(name)

    if #app:visibleWindows() == 0 then app:selectMenuItem(menuItem) end
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
