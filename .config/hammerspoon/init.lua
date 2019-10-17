hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid("12x12").setMargins("20x20")
hs.window.animationDuration = 0

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

    ["1,3 4x6"] = windowHotKeyConf("q", false, true),
    ["0,3 4x6"] = windowHotKeyConf("w", false, true),
    ["4,3 4x6"] = windowHotKeyConf("f", false, true),
    ["8,3 4x6"] = windowHotKeyConf("p", false, true),
    ["7,3 4x6"] = windowHotKeyConf("g", false, true),

    ["1,2 6x8"] = windowHotKeyConf("a", false, true),
    ["0,2 6x8"] = windowHotKeyConf("r", false, true),
    ["3,2 6x8"] = windowHotKeyConf("s", false, true),
    ["6,2 6x8"] = windowHotKeyConf("t", false, true),
    ["5,2 6x8"] = windowHotKeyConf("d", false, true),

    ["2,3 4x6"] = windowHotKeyConf("z", false, true),
    ["6,3 4x6"] = windowHotKeyConf("b", false, true)
}

keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local mods = hs.eventtap.checkKeyboardModifiers()
    local keyCode = e:getKeyCode()

    for pos, hotkey in pairs(windowHotkeys) do
        if keyCode == hotkey.keyCode and not not mods.ctrl == hotkey.mods.ctrl and
            not not mods.alt == hotkey.mods.alt and not not mods.cmd ==
            hotkey.mods.cmd and not not mods.shift == hotkey.mods.shift then
            hs.grid.set(hs.window.frontmostWindow(), pos)
            return true
        end
    end
end):start()

function openForSpace(name, menuItem)
    hs.application.launchOrFocus(name)

    local app = hs.application.find(name)

    if #app:visibleWindows() == 0 then app:selectMenuItem(menuItem) end
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
