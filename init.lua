hyper = require('hyper')
appSwitcher = require('app-switcher')
winwin = hs.loadSpoon('WinWin')
logger = hs.logger.new('init.lua','info')

-- shortcut for sleep
hyper:bind({"cmd"}, "s", function()
  hs.caffeinate.systemSleep()
end)

-- shortcut for window resize
hyper:bind({}, "right", function() winwin:moveAndResize('halfright') end, nil, function() winwin:moveToScreen('right') end)
hyper:bind({}, "left", function() winwin:moveAndResize('halfleft') end, nil, function() winwin:moveToScreen('left') end)
hyper:bind({}, "up", function() winwin:moveAndResize('maximize') end)
hyper:bind({}, 'down',  function() winwin:moveAndResize('halfdown') end, nil, function() winwin:moveAndResize('halfup') end)
hyper:bind({}, "return", function() hs.window.focusedWindow():toggleFullScreen() end)

-- shortcut to show desktop
hyper:bind({}, "delete", function()
  local app = hs.application.find('Finder')
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