gettime = require("socket").gettime

hs.application.enableSpotlightForNameSearches(true)
hs.grid.setGrid("12x12").setMargins("11x11")
hs.window.animationDuration = 0

hs.hotkey.bind({ "ctrl", "cmd" }, "n", function() openForSpace("iTerm", "New Window") end)
hs.hotkey.bind({ "ctrl", "cmd" }, "e", function() openForSpace("Google Chrome", "New Window") end)
hs.hotkey.bind({ "ctrl", "cmd" }, "i", function() openForSpace("iA Writer", "New in Library") end)

-- macro pad keycodes
--
-- +-----------------------------+
-- |  0 | 11 |  8 |  2 | 14 |  3 |
-- +-----------------------------+
-- |  5 |  4 | 34 | 38 | 40 | 37 |
-- +-----------------------------+
-- |    | 46 | 45 | 31 | 35 | 12 |
-- +-----------------------------+

windowHotkeys = {
  ["1,0 4x12"]={ keyCode=11, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["0,0 4x12"]={ keyCode=8,  mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["4,0 4x12"]={ keyCode=2,  mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["8,0 4x12"]={ keyCode=14, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["7,0 4x12"]={ keyCode=3,  mods={ ctrl=true, alt=true, cmd=false, shift=false } },

  ["1,0 6x12"]={ keyCode=4,  mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["0,0 6x12"]={ keyCode=34, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["3,0 6x12"]={ keyCode=38, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["6,0 6x12"]={ keyCode=40, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["5,0 6x12"]={ keyCode=37, mods={ ctrl=true, alt=true, cmd=false, shift=false } },

  ["2,0 4x12"]={ keyCode=46, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["0,0 8x12"]={ keyCode=45, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["2,0 8x12"]={ keyCode=31, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["4,0 8x12"]={ keyCode=35, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["6,0 4x12"]={ keyCode=12, mods={ ctrl=true, alt=true, cmd=false, shift=false } },

  ["0,0 12x12"]={ keyCode=0, mods={ ctrl=true, alt=true, cmd=false, shift=false } },
  ["1,0 10x12"]={ keyCode=5, mods={ ctrl=true, alt=true, cmd=false, shift=false } },

  ["1,1 4x10"]={ keyCode=11, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["0,1 4x10"]={ keyCode=8,  mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["4,1 4x10"]={ keyCode=2,  mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["8,1 4x10"]={ keyCode=14, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["7,1 4x10"]={ keyCode=3,  mods={ ctrl=true, alt=true, cmd=false, shift=true } },

  ["1,1 6x10"]={ keyCode=4,  mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["0,1 6x10"]={ keyCode=34, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["3,1 6x10"]={ keyCode=38, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["6,1 6x10"]={ keyCode=40, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["5,1 6x10"]={ keyCode=37, mods={ ctrl=true, alt=true, cmd=false, shift=true } },

  ["2,1 4x10"]={ keyCode=46, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["0,1 8x10"]={ keyCode=45, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["2,1 8x10"]={ keyCode=31, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["4,1 8x10"]={ keyCode=35, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["6,1 4x10"]={ keyCode=12, mods={ ctrl=true, alt=true, cmd=false, shift=true } },

  ["0,1 12x10"]={ keyCode=0, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
  ["1,1 10x10"]={ keyCode=5, mods={ ctrl=true, alt=true, cmd=false, shift=true } },
}

keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (e)
  local mods = hs.eventtap.checkKeyboardModifiers()
  local keyCode = e:getKeyCode()

  for pos, hotkey in pairs(windowHotkeys) do
    if
      keyCode == hotkey.keyCode and
      not not mods.ctrl == hotkey.mods.ctrl and
      not not mods.alt == hotkey.mods.alt and
      not not mods.cmd == hotkey.mods.cmd and
      not not mods.shift == hotkey.mods.shift
    then
      hs.grid.set(hs.window.frontmostWindow(), pos)
      return true
    end
  end
end):start()

otherMouseDownTap = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, function(e)
  local buttonNumber = e:getProperty(hs.eventtap.event.properties["mouseEventButtonNumber"])

  local mods = hs.eventtap.checkKeyboardModifiers()

  local screen = hs.screen.mainScreen():frame()

  if buttonNumber == 4 then
    hs.mouse.setAbsolutePosition(hs.geometry.point(1 * screen.w / 6, screen.h / 2))
  elseif buttonNumber == 3 then
    hs.mouse.setAbsolutePosition(hs.geometry.point(3 * screen.w / 6, screen.h / 2))
  elseif buttonNumber == 2 then
    hs.mouse.setAbsolutePosition(hs.geometry.point(5 * screen.w / 6, screen.h / 2))
  end
end):start()

function openForSpace(name, menuItem)
  hs.application.launchOrFocus(name)

  local app = hs.application.find(name)

  if #app:visibleWindows() == 0 then
    app:selectMenuItem(menuItem)
  end
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
