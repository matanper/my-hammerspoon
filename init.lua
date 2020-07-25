hyper = require('hyper')
appSwitcher = require('app-switcher')
winwin = hs.loadSpoon('WinWin')
logger = hs.logger.new('init.lua','info')

-- shortcut for sleep
hyper:bind({"cmd"}, "s", function()
  hs.caffeinate.systemSleep()
end)

-- shortcut for window resize
hyper:bind({}, "right", function() winwin:moveAndResize('halfright') end)
hyper:bind({}, "left", function() winwin:moveAndResize('halfleft') end)
hyper:bind({}, "up", function() winwin:moveAndResize('maximize') end)
hyper:bind({}, "down", function()
  before = hs.window.focusedWindow():frame()
  winwin:moveAndResize('halfdown')
  after = hs.window.focusedWindow():frame()
  if (before == after) then
    winwin:moveAndResize('halfup')
  end
end)
hyper:bind({}, "return", function()
  hs.window.focusedWindow():toggleFullScreen()
end)

-- shortcuts for window screen movement
hyper:bind({'cmd'}, 'left', function()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():previous()
  win:moveToScreen(nextScreen)
end)

hyper:bind({'cmd'}, 'right', function()
  win = hs.window.focusedWindow()
  isFullScreen = win:isFullScreen()
  logger:i(isFullScreen)
  if (isFullScreen) then
    hs.alert.show("turn off fullscreen")
    win:setFullScreen(false)
  end
  win:moveOneScreenEast()
  if (isFullScreen) then
    win:setFullScreen(true)
  end
end)

-- shortcut to show desktop
hyper:bind({}, "delete", function()
  app = hs.application.find('Finder')
  app:activate()
  app:selectMenuItem('Hide Others')
end)

-- Shortcuts for fast app switching
local switcherMap = {
  s = "Slack",
  w = "Whatsapp",
  a = "com.apple.mail",
  m = "Spotify",
  t = "com.googlecode.iterm2",
  c = "Google Chrome",
  v = "com.microsoft.VSCode",
  p = "com.jetbrains.pycharm",
  z = "zoom.us",
  d = "DBeaver",
  e = "Finder"
}

appSwitcher.init(switcherMap, hyper)