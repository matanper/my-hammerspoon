hyper = require('hyper')
appSwitcher = require('app-switcher')
winwin = hs.loadSpoon('WinWin')

-- shortcut for sleep
hyper:bind({"cmd"}, "s", function()
  hs.caffeinate.systemSleep()
end)

-- shortcut for window resize
winwin.gridparts = 3
hyper:bind({}, "right", function() winwin:moveAndResize('halfright') end)
hyper:bind({}, "left", function() winwin:moveAndResize('halfleft') end)
hyper:bind({}, "up", function() winwin:moveAndResize('maximize') end)
hyper:bind({}, "down", function()
  winwin:moveAndResize('halfdown')
end)
hyper:bind({}, "return", function()
  hs.window.focusedWindow():toggleFullScreen()
end)

-- shortcut to show desktop
hyper:bind({}, "e", function()
 for key, running in pairs(hs.application.runningApplications()) do
    if( app ~= running ) then
      running:bringToBack()
    end
  end
  hs.window.desktop():focus()

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
  d = "Dictionary"
}

appSwitcher.init(switcherMap, hyper)