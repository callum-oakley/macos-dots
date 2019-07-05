hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid("12x12").setMargins("8x8")
hs.window.animationDuration = 0

hs.hotkey.bind({"cmd", "ctrl"}, "n",
               function() openForSpace("iTerm", "New Window") end)
hs.hotkey.bind({"cmd", "ctrl"}, "e",
               function() openForSpace("Google Chrome", "New Window") end)
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

function windowHotKeyConf(key, shift)
    return {
        keyCode = hs.keycodes.map[key],
        mods = {cmd = true, alt = false, ctrl = true, shift = shift}
    }
end

windowHotkeys = {
    ["1,0 4x12"] = windowHotKeyConf("q", false),
    ["0,0 4x12"] = windowHotKeyConf("w", false),
    ["4,0 4x12"] = windowHotKeyConf("f", false),
    ["8,0 4x12"] = windowHotKeyConf("p", false),
    ["7,0 4x12"] = windowHotKeyConf("g", false),

    ["1,0 6x12"] = windowHotKeyConf("a", false),
    ["0,0 6x12"] = windowHotKeyConf("r", false),
    ["3,0 6x12"] = windowHotKeyConf("s", false),
    ["6,0 6x12"] = windowHotKeyConf("t", false),
    ["5,0 6x12"] = windowHotKeyConf("d", false),

    ["2,0 4x12"] = windowHotKeyConf("z", false),
    ["0,0 8x12"] = windowHotKeyConf("x", false),
    ["2,0 8x12"] = windowHotKeyConf("c", false),
    ["4,0 8x12"] = windowHotKeyConf("v", false),
    ["6,0 4x12"] = windowHotKeyConf("b", false),

    ["0,0 12x12"] = windowHotKeyConf("tab", false),
    ["1,0 10x12"] = windowHotKeyConf("delete", false),

    ["1,1 4x10"] = windowHotKeyConf("q", true),
    ["0,1 4x10"] = windowHotKeyConf("w", true),
    ["4,1 4x10"] = windowHotKeyConf("f", true),
    ["8,1 4x10"] = windowHotKeyConf("p", true),
    ["7,1 4x10"] = windowHotKeyConf("g", true),

    ["1,1 6x10"] = windowHotKeyConf("a", true),
    ["0,1 6x10"] = windowHotKeyConf("r", true),
    ["3,1 6x10"] = windowHotKeyConf("s", true),
    ["6,1 6x10"] = windowHotKeyConf("t", true),
    ["5,1 6x10"] = windowHotKeyConf("d", true),

    ["2,1 4x10"] = windowHotKeyConf("z", true),
    ["0,1 8x10"] = windowHotKeyConf("x", true),
    ["2,1 8x10"] = windowHotKeyConf("c", true),
    ["4,1 8x10"] = windowHotKeyConf("v", true),
    ["6,1 4x10"] = windowHotKeyConf("b", true)
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
