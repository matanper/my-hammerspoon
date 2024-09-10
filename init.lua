hyper = require('hyper')
appSwitcher = require('app-switcher')
layoutWin = require('layout-win')
winwin = hs.loadSpoon('WinWin')
logger = hs.logger.new('init.lua','info')

-- shortcut for sleep
hyper:bind({"cmd"}, "s", function()
  hs.caffeinate.systemSleep()
end)

-- Define windows layouts
local layoutOptions = {}
local order = {'Two Thirds'} -- If more than 1 option defined, than a "layout" menu will be added to the top bar
layoutOptions['Two Parts'] = {{0, 15, 0, 30}, {15, 30, 0, 30}}
layoutOptions['Six Parts'] = {{0, 10, 0, 15}, {10, 20, 0, 15}, {20, 30, 0, 15}, {0, 10, 15, 30}, {10, 20, 15, 30}, {20, 30, 15, 30}}
layoutOptions['Center Third'] = {{0, 7, 0, 30}, {7, 23, 0, 30}, {23, 30, 0, 30}}
layoutOptions['Two Thirds'] = {{0, 20, 0, 30}, {20, 30, 0, 30}}
layoutWin.init(layoutOptions,order, 30)

-- Define shortcuts to switch windows of the layout
hyper:bind({}, "right", function()
  local cwin = hs.window.focusedWindow()
  layoutWin.cycleWindow(cwin, true)
end)
hyper:bind({}, "left", function()
  local cwin = hs.window.focusedWindow()
  layoutWin.cycleWindow(cwin, false)
end)
-- Other window management options
hyper:bind({}, "up", function() winwin:moveAndResize('maximize') end)
hyper:bind({}, 'down',  function() winwin:moveAndResize('halfdown') end, nil, function() winwin:moveAndResize('halfup') end)
hyper:bind({}, "return", function() hs.window.focusedWindow():toggleFullScreen() end)
hyper:bind({"cmd"}, "left", function() winwin:moveToScreen('left') end)
hyper:bind({"cmd"}, "right", function() winwin:moveToScreen('right') end)

-- shortcut to show desktop
hyper:bind({}, "delete", function()
  local app = hs.application.find('Finder')
  app:activate()
  app:selectMenuItem('Hide Others')
end)

-- Shortcuts for fast app switching
-- In order to find the correct name run "lsappinfo" and put here the main title name.
local switcherMap = {
  s = "Slack",
  w = "Whatsapp",
  e = "Canary Mail",
  m = "Spotify",
  t = "iTerm",
  v = "Code",
  p = "PyCharm",
  d = "DBeaver",
  f = "Finder",
  b = "Arc",
  n = "Notion",
  c = "Notion Calendar",
  j = "IntelliJ IDEA"
}

-- if the app has to be launched by a different name than the one the windows are found by, this list
-- will take precedence when opening the app.
-- In order to find the correct name run "lsappinfo" and put here the name under the bundle path.
local switcherLaunchMap = {
  v = 'Visual Studio Code',
  p = 'PyCharm CE',
  j = 'IntelliJ IDEA CE'
}

appSwitcher.init(switcherMap, switcherLaunchMap, hyper)
