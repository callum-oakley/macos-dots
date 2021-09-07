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

function snapWindow()
    hs.grid.snap(hs.window.focusedWindow())
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

function bind(mods, key, f)
    hs.hotkey.bind(mods, key, f("press"), f("release"), f("repeat"))
end

function pressKey(mods, key)
    return function(case)
        if case == "press" then
            return function ()
                hs.eventtap.event.newKeyEvent(mods, key, true):post()
            end
        elseif case == "release" then
            return function ()
                hs.eventtap.event.newKeyEvent(mods, key, false):post()
            end
        elseif case == "repeat" then
            return function ()
                hs.eventtap.event.newKeyEvent(mods, key, true):post()
            end
        end
    end
end

function onPressOrRepeat(f)
    return function(case)
        if case == "press" or case == "repeat" then
            return f
        end
    end
end

function bindPR(mods, key, f)
    return bind(mods, key, onPressOrRepeat(f))
end

function pressSystemKey(key) hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

function keyStrokes(strokes)
    hs.eventtap.keyStrokes(strokes)
end

function openForSpace(name, menuItem)
    hs.application.launchOrFocus(name)
    local app = hs.application.find(name)
    if #app:visibleWindows() == 0 then
        app:selectMenuItem(menuItem)
    end
end

bind({"ctrl"}, "h", pressKey(nil, "left"))
bind({"ctrl"}, "j", pressKey(nil, "down"))
bind({"ctrl"}, "k", pressKey(nil, "up"))
bind({"ctrl"}, "l", pressKey(nil, "right"))
bind({"ctrl"}, "delete", pressKey(nil, "forwarddelete"))
bind({"ctrl", "cmd"}, "h", pressKey({"cmd"}, "left"))
bind({"ctrl", "cmd"}, "j", pressKey({"cmd"}, "down"))
bind({"ctrl", "cmd"}, "k", pressKey({"cmd"}, "up"))
bind({"ctrl", "cmd"}, "l", pressKey({"cmd"}, "right"))
bind({"ctrl", "cmd"}, "delete", pressKey({"cmd"}, "forwarddelete"))
bind({"ctrl", "alt"}, "h", pressKey({"alt"}, "left"))
bind({"ctrl", "alt"}, "j", pressKey({"alt"}, "down"))
bind({"ctrl", "alt"}, "k", pressKey({"alt"}, "up"))
bind({"ctrl", "alt"}, "l", pressKey({"alt"}, "right"))
bind({"ctrl", "alt"}, "delete", pressKey({"alt"}, "forwarddelete"))
bind({"ctrl", "shift"}, "h", pressKey({"shift"}, "left"))
bind({"ctrl", "shift"}, "j", pressKey({"shift"}, "down"))
bind({"ctrl", "shift"}, "k", pressKey({"shift"}, "up"))
bind({"ctrl", "shift"}, "l", pressKey({"shift"}, "right"))
bind({"ctrl", "cmd", "shift"}, "h", pressKey({"cmd", "shift"}, "left"))
bind({"ctrl", "cmd", "shift"}, "j", pressKey({"cmd", "shift"}, "down"))
bind({"ctrl", "cmd", "shift"}, "k", pressKey({"cmd", "shift"}, "up"))
bind({"ctrl", "cmd", "shift"}, "l", pressKey({"cmd", "shift"}, "right"))
bind({"ctrl", "alt", "shift"}, "h", pressKey({"alt", "shift"}, "left"))
bind({"ctrl", "alt", "shift"}, "j", pressKey({"alt", "shift"}, "down"))
bind({"ctrl", "alt", "shift"}, "k", pressKey({"alt", "shift"}, "up"))
bind({"ctrl", "alt", "shift"}, "l", pressKey({"alt", "shift"}, "right"))
bindPR({"alt"}, "a", function() pressSystemKey("SOUND_DOWN") end)
bindPR({"alt"}, "s", function() pressSystemKey("SOUND_UP") end)
bindPR({"alt"}, "z", function() pressSystemKey("PLAY") end)
bindPR({"alt"}, "q", function() keyStrokes(utf8.char(772)) end) -- ◌̄
bindPR({"alt"}, "w", function() keyStrokes(utf8.char(769)) end) -- ◌́
bindPR({"alt"}, "e", function() keyStrokes(utf8.char(780)) end) -- ◌̌
bindPR({"alt"}, "r", function() keyStrokes(utf8.char(768)) end) -- ◌̀
bindPR({"alt"}, "v", function() keyStrokes(utf8.char(252)) end) -- ü
bindPR({"alt", "shift"}, "v", function() keyStrokes(utf8.char(220)) end) -- Ü
bindPR({"alt"}, "t", function() openForSpace("kitty", "New OS Window") end)
bindPR({"alt"}, "g", function() openForSpace("Notes", "New Note") end)
bindPR({"alt"}, "b", function() openForSpace("Safari", "New Window") end)
bindPR({"alt"}, "h", hs.grid.pushWindowLeft)
bindPR({"alt"}, "j", hs.grid.pushWindowDown)
bindPR({"alt"}, "k", hs.grid.pushWindowUp)
bindPR({"alt"}, "l", hs.grid.pushWindowRight)
bindPR({"alt"}, ";", function() hs.window.focusedWindow():centerOnScreen() end)
bindPR({"alt", "cmd"}, "h", hs.grid.resizeWindowThinner)
bindPR({"alt", "cmd"}, "j", hs.grid.resizeWindowTaller)
bindPR({"alt", "cmd"}, "k", hs.grid.resizeWindowShorter)
bindPR({"alt", "cmd"}, "l", hs.grid.resizeWindowWider)
bindPR({"alt", "cmd"}, ";", snapWindow)
bindPR({"alt"}, "m", toggleMaximizeWindow)

-- Can't override cmd-tab with a regular hotkey for some reason
keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    if e:getKeyCode() == 48 then -- tab
        local mods = e:getFlags()
        if mods.cmd then
            if mods.shift then
                changeFocus(-1)
                return true
            else
                changeFocus(1)
                return true
            end
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
