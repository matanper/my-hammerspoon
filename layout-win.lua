local this = {}
this.logger = hs.logger.new('layout-win','info')


this.isFramesEqual = function(frame1, frame2)
  -- Define a tolerance for small differences
  local tolerance = 1.0

  -- Check if widths and heights are within the tolerance
  if math.abs(frame1.w - frame2.w) > tolerance or math.abs(frame1.h - frame2.h) > tolerance then
    return false
  end
  
  -- Calculate the overlap dimensions
  local x_overlap = math.max(0, math.min(frame1.x + frame1.w, frame2.x + frame2.w) - math.max(frame1.x, frame2.x))
  local y_overlap = math.max(0, math.min(frame1.y + frame1.h, frame2.y + frame2.h) - math.max(frame1.y, frame2.y))

  -- Calculate the overlap area
  local overlapArea = x_overlap * y_overlap

  -- Calculate the area of each frame
  local area1 = frame1.w * frame1.h
  local area2 = frame2.w * frame2.h
  local minArea = math.min(area1, area2)

  return (overlapArea / minArea) > 0.99
end

this.currentFrameIndex = function(frames, win)
  local winFrame = win:frame()
  for index, frame in pairs(frames) do
    if this.isFramesEqual(frame, winFrame) then
      return index
    end
  end
  return nil
end


this.getLayoutFrames = function(screen)
  frames = {}
  local topbar_diff = screen:fullFrame().h - screen:frame().h
  local screenWidth = screen:fullFrame().w
  local screenHeight = screen:fullFrame().h

  for _, layout_part in pairs(this.layout) do
    -- the layout parts represents: {x1, x2, y1, y2}
    x = screenWidth * layout_part[1] / this.gridparts
    y = screenHeight * layout_part[3] / this.gridparts + topbar_diff
    w = screenWidth * (layout_part[2] - layout_part[1]) / this.gridparts
    h = screenHeight * (layout_part[4] - layout_part[3]) / this.gridparts - topbar_diff
    -- Must include screen.x and screen.y since frames coordinates are absolute between all screens
    -- (so x,y coordinates of some screens can be negative)
    table.insert(frames, hs.geometry.rect({x=screen:fullFrame().x + x, y=screen:fullFrame().y + y, w=w, h=h}))
  end
  return frames
end

this.moveWindow = function(win, forward)
  local frames = this.getLayoutFrames(win:screen())
  local currentFrameIndex = this.currentFrameIndex(frames, win)
  if currentFrameIndex == nil then
    if forward then
      win:move(frames[#frames])
    else
      win:move(frames[1])
    end
    return
  end

  local targetFrame = nil;
  local screen = win:screen()
  if forward then
    nextIndex = (currentFrameIndex % #frames) + 1
    -- Move to next screen if exists
    if nextIndex == 1 and screen ~= screen:next() then
      targetFrame = this.getLayoutFrames(screen:next())[1]
    -- Does not cycle to the first frame if single screen
    elseif nextIndex == 1 then
      targetFrame = nil;
    else
      targetFrame = frames[nextIndex]
    end
  else
    prevIndex = ((currentFrameIndex + #frames - 2) % #frames) + 1
    -- Move to previous screen if exists
    if prevIndex == #frames and screen ~= screen:previous() then
      targetFrame = this.getLayoutFrames(screen:previous())[#frames]
    -- Does not cycle to the last frame if single screen
    elseif prevIndex == #frames then
      targetFrame = nil
    else
      targetFrame = frames[prevIndex]
    end
  end

  if targetFrame ~= nil then
    win:move(targetFrame)
  end

end

this.init = function(layouts, order, gridparts)
  this.gridparts = gridparts

  if #order > 1 then
    this.menuItems = {}
    this.menu = hs.menubar.new()
    local isFirst = true

    for _, name in ipairs(order) do
      func = function()
        this.layout = layouts[name]
        for _, item in pairs(this.menuItems) do
          if name == item['title'] then
            item['checked'] = true
          else
            item['checked'] = false
          end
        end
        this.menu:setMenu(this.menuItems)
      end
      item = {title = name, fn = func}
      if isFirst then
        item['checked'] = true
        item['fn']()
        isFirst = false
      else
        item['checked'] = false
      end
      table.insert(this.menuItems, item)
    end
    this.menu:setTitle('layout'):setMenu(this.menuItems)
  else
    this.layout = layouts[order[1]]
    this.logger:i('Using single layout' .. order[1])
  end

end

return this