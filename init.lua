hyper = require('hyper')
appSwitcher = require('app-switcher')
windowsResize = require('windows-resize')

-- shortcut for sleep
hyper:bind({"cmd"}, "s", function()
  hs.caffeinate.systemSleep()
end)

-- shortcut for window resize
hyper:bind({}, "right", windowsResize.move('right'))
hyper:bind({}, "left", windowsResize.move('left'))
hyper:bind({}, "up", windowsResize.maximize)
hyper:bind({}, "down", windowsResize.hide)
hyper:bind({}, "return", windowsResize.toggleFullscreen)

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