GRID_W = 12
GRID_H = 12
SCROLL_SPEED = 4

-- luarocks install luasocket
gettime = require("socket").gettime

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

stickyScroll = false
bufferedX = 0
bufferedY = 0
lastScrollEventTS = 0

function scroll(e)
  local oldMousePosition = hs.mouse.getAbsolutePosition()

  bufferedX = bufferedX +
    e:getProperty(hs.eventtap.event.properties["mouseEventDeltaX"])
  bufferedY = bufferedY +
    e:getProperty(hs.eventtap.event.properties["mouseEventDeltaY"])

  -- throttle actual scroll events to no more than 60 a second because mouse
  -- events are significantly more frequent than scrollwheel events, and if you
  -- send too many scroll events things start to get laggy...
  local ts = gettime()
  if ts - lastScrollEventTS > 1 / 60 then
    local scroll = hs.eventtap.event.newScrollEvent(
      {bufferedX * SCROLL_SPEED, bufferedY * SCROLL_SPEED},
      {},
      "pixel"
    ):post()

    lastScrollEventTS = ts
    bufferedX = 0
    bufferedY = 0
  end

  hs.mouse.setAbsolutePosition(oldMousePosition)

  return true
end

hotKeys = {
    { { "cmd" }, "tab", function()
        changeFocus(1)
    end },
    { { "cmd", "shift" }, "tab", function()
        changeFocus(-1)
    end },
    { { "cmd", "ctrl" }, "n", hs.grid.pushWindowLeft },
    { { "cmd", "ctrl" }, "i", hs.grid.pushWindowRight },
    { { "cmd", "ctrl" }, "u", hs.grid.pushWindowUp },
    { { "cmd", "ctrl" }, "e", hs.grid.pushWindowDown },
    { { "cmd", "ctrl" }, "l", throwWindowLeft },
    { { "cmd", "ctrl" }, "y", throwWindowRight },
    { { "cmd", "ctrl" }, "m", throwWindowDown },
    { { "cmd", "ctrl" }, ",", throwWindowUp },
    { { "cmd", "ctrl" }, "o", centerWindow },
    { { "cmd", "ctrl" }, ".", toggleMaximizeWindow },
    { { "cmd", "ctrl", "shift" }, "n", hs.grid.resizeWindowThinner },
    { { "cmd", "ctrl", "shift" }, "i", hs.grid.resizeWindowWider },
    { { "cmd", "ctrl", "shift" }, "u", hs.grid.resizeWindowShorter },
    { { "cmd", "ctrl", "shift" }, "e", hs.grid.resizeWindowTaller },
    { { "cmd", "ctrl", "shift" }, "l", halfWindowWidth },
    { { "cmd", "ctrl", "shift" }, "y", doubleWindowWidth },
    { { "cmd", "ctrl", "shift" }, "m", doubleWindowHeight },
    { { "cmd", "ctrl", "shift" }, ",", halfWindowHeight },
    { { "cmd", "ctrl", "shift" }, "o", snapWindow },
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

leftMouseDownTap = hs.eventtap.new({
  hs.eventtap.event.types.leftMouseDown,
}, function(e)
  if stickyScroll then
    stickyScroll = false
    return true
  end
end):start()

rightMouseDownTap = hs.eventtap.new({
  hs.eventtap.event.types.rightMouseDown,
}, function(e)
  if stickyScroll then
    stickyScroll = false
    return true
  end
end):start()

middleMouseDownTap = hs.eventtap.new({
  hs.eventtap.event.types.middleMouseDown,
}, function(e)
  stickyScroll = not stickyScroll
  return true
end):start()

mouseMovedTap = hs.eventtap.new({
  hs.eventtap.event.types.mouseMoved,
  hs.eventtap.event.types.leftMouseDragged,
}, function(e)
  if stickyScroll then
    return scroll(e)
  end
end):start()

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
