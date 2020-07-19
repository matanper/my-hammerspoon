local this = {}
this.logger = hs.logger.new('app-switcher','info')
this.allAppsWindows = {}

this.alert = function(message)
    style = {
        strokeColor = {white = 1, alpha = 0},
        fillColor = {white = 0.05, alpha = 0.75},
        radius = 10
    }
    hs.alert.closeAll(0)
    hs.alert.show(message, style, 1)
end


-- Filter subscription for window events
-- ===================================================
f = hs.window.filter.new()
f:subscribe(hs.window.filter.windowCreated, function(win)
    id = win:application():bundleID()
    if (this.allAppsWindows[id] == nil) then
        this.allAppsWindows[id] = {}
    end
    this.allAppsWindows[id][win:id()] = win
end)

f:subscribe(hs.window.filter.windowDestroyed, function(win)
    id = win:application():bundleID()
    this.allAppsWindows[id][win:id()] = nil
end)

-- Table helper functions
-- =================================================================

this.isTableEmpty = function(t)
    if (t == nil) then return false end
    for _,_ in pairs(t) do
        return true
    end
    return false
end

this.nextTableItem = function(t, key)
    local nextKey = next(t, key)
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
    if app == nil then
        this.alert('Launching ' .. appName .. '...')
        this.logger:i("Launching " .. appName)
        app = hs.application.open(appName)
    end
    -- Get windows of app
    local appWindows = this.allAppsWindows[app:bundleID()]
    local windowsExists = this.isTableEmpty(appWindows)
    app:activate(true, 3)
    -- If no windows then open one
    if windowsExists == false then
        this.logger:i("Open New Window " .. appName)
        app:selectMenuItem('New Window')
    -- If there are windows but app not frontmost open first one
    elseif app:isFrontmost() == false then
        -- Get focused window (which was the last in use)
        win = app:focusedWindow()
        win:focus()
    else
        currId = app:focusedWindow():id()
        win = this.nextTableItem(appWindows, currId)
        win:focus()
    end
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