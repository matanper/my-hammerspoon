local this = {}
this.logger = hs.logger.new('app-switcher','info')
this.allAppsWindows = {}
this.winToApps = {}

this.alert = function(message)
    style = {
        strokeColor = {white = 1, alpha = 0},
        fillColor = {white = 0.05, alpha = 0.75},
        radius = 10
    }
    hs.alert.closeAll(0)
    hs.alert.show(message, style, 3)
end


-- Filter subscription for window events
-- ===================================================
f = hs.window.filter.new()
f:subscribe(hs.window.filter.windowCreated, function(win)
    appid = win:application():bundleID()
    if (this.allAppsWindows[appid] == nil) then
        this.allAppsWindows[appid] = {}
    end
    this.allAppsWindows[appid][win:id()] = win
    this.winToApps[win:id()] = appid
end)

f:subscribe(hs.window.filter.windowDestroyed, function(win)
    appid = this.winToApps[win:id()]
    if appid then
        this.allAppsWindows[appid][win:id()] = nil
    end
end)

-- Table helper functions
-- =================================================================

this.appHaveWindows = function(app)
    t = this.allAppsWindows[app:bundleID()]
    if (t == nil) then return false end
    for _,_ in pairs(t) do
        return true
    end
    return false
end

this.nextWindow = function(app, lastWindow)
    t = this.allAppsWindows[app:bundleID()]
    local nextKey = next(t, lastWindow)
    -- If the key is the last getting the first key
    if nextKey == nill then
        nextKey = next(t, nil)
    end
    return t[nextKey]
end

-- Main logic
-- =================================================================
this.handleApp = function(appName)
    local app = hs.application.find(appName)
    -- If app is closed, open it
    if app == nil or not(this.appHaveWindows(app)) then
        this.logger:i('Open ' .. appName)
        this.alert('Open ' .. appName)
        app = hs.application.open(appName, 3)
        if app then
            win = app:focusedWindow()
        end
    -- If there are windows but app not frontmost open first one
    elseif not(app:isFrontmost()) then
        this.logger:i('Switch to frontmost ' .. appName)
        -- Get focused window of app (which was the last in use)
        win = app:focusedWindow()
    else
        lastWin = app:focusedWindow():id()
        win = this.nextWindow(app, lastWin)
    end

    if win then
        this.moveToWindow(win)
    end
end


this.moveToWindow = function(win)
    win:focus()
    center = hs.geometry.rectMidPoint(win:frame())
    hs.mouse.setAbsolutePosition(center)
end

-- Init of application map
this.init = function(switcherMap, hyperKey)
  hs.application.enableSpotlightForNameSearches(true)
  for appKey, appValue in pairs(switcherMap) do
      -- Add binding to key
      hyperKey:bind(switcherKey, appKey, function()
          this.handleApp(appValue)
      end)
  end
end

return this