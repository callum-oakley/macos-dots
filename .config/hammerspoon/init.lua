stickyScroll = false
stickyScrollLockX = false
scrollEvents = 0

mouseMovedTap = hs.eventtap.new({hs.eventtap.event.types.mouseMoved}, function(e)
  local mods = hs.eventtap.checkKeyboardModifiers()

  if mods["cmd"] then
    return scroll(e, false)
  elseif mods["alt"] then
    return scroll(e, true)
  elseif stickyScroll then
    return scroll(e, stickyScrollLockX)
  end
end):start()

leftMouseDownTap = hs.eventtap.new({hs.eventtap.event.types.leftMouseDown}, function(e)
  if stickyScroll then
    stickyScroll = false
    return true
  end

  local mods = hs.eventtap.checkKeyboardModifiers()

  if mods["ctrl"] then
    return moveLeftSpace()
  end
end):start()

rightMouseDownTap = hs.eventtap.new({hs.eventtap.event.types.rightMouseDown}, function(e)
  if stickyScroll then
    stickyScroll = false
    return true
  end

  local mods = hs.eventtap.checkKeyboardModifiers()

  if mods["ctrl"] then
    return moveRightSpace()
  end
end):start()

middleMouseDownTap = hs.eventtap.new({hs.eventtap.event.types.middleMouseDown}, function(e)
  stickyScroll = false

  local mods = hs.eventtap.checkKeyboardModifiers()

  if mods["cmd"] then
    stickyScroll = true
    stickyScrollLockX = false
    return true
  elseif mods["alt"] then
    stickyScroll = true
    stickyScrollLockX = true
    return true
  end
end):start()

function scroll(e, lockX)
  local scrollSpeed = 20
  local sampleRate = 5

  local oldMousePosition = hs.mouse.getAbsolutePosition()
  local dx = e:getProperty(hs.eventtap.event.properties["mouseEventDeltaX"])
  local dy = e:getProperty(hs.eventtap.event.properties["mouseEventDeltaY"])

  if lockX then
    dx = 0
  end

  -- mouse events are much more frequent than scroll events, so only send an
  -- actual scroll event every `sampleRate` mouse events to avoid laggy
  -- scrolling!
  scrollEvents = scrollEvents + 1
  if scrollEvents == sampleRate then
    scrollEvents = 0

    local scroll = hs.eventtap.event.newScrollEvent(
      {dx * scrollSpeed, dy * scrollSpeed},
      {},
      "pixel"
    ):post()
  end

  hs.mouse.setAbsolutePosition(oldMousePosition)

  return true
end

function moveLeftSpace()
  hs.osascript.applescript(
    'tell application "System Events" to key code 123 using {control down}'
  )
  return true
end

function moveRightSpace()
  hs.osascript.applescript(
    'tell application "System Events" to key code 124 using {control down}'
  )
  return true
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
