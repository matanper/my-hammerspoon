local this = {}
this.logger = hs.logger.new('layout-win','info')
this.gridparts = 30
-- x1,x2,y1,y2
-- this.layout = {{0, 7, 0, 30}, {7, 23, 0, 30}, {23, 30, 0, 30}}
this.layout = {{0, 10, 0, 15}, {10, 20, 0, 15}, {20, 30, 0, 15}, {0, 10, 15, 30}, {10, 20, 15, 30}, {20, 30, 15, 30}}


this.calcOverlapArea = function(frame1, frame2)
  x_overlap = math.max(0, math.min(frame1.x + frame1.w, frame2.x + frame2.w) - math.max(frame1.x, frame2.x))
  y_overlap = math.max(0, math.min(frame1.y + frame1.h, frame2.y + frame2.h) - math.max(frame1.y, frame2.y))
  overlapArea = x_overlap * y_overlap
  return overlapArea
end

this.nearestFrameIndex = function(frames, win)
  local winFrame = win:frame()
  local maxArea = 0
  local maxIndex = 0
  for index, frame in pairs(frames) do
    local overlapArea = this.calcOverlapArea(frame, winFrame)
    if maxIndex == 0 or overlapArea > maxArea then
      maxArea = overlapArea
      maxIndex = index
    end
  end
  return maxIndex
end


this.getLayoutFrames = function(win)
  frames = {}
  local screen = win:screen()
  local topbar_diff = screen:fullFrame().h - screen:frame().h
  -- local screenWidth = screen:frame().w
  -- local screenHeight = screen:fullFrame().h - topbar_diff
  local screenWidth = screen:fullFrame().w
  local screenHeight = screen:fullFrame().h

  for _, layout_part in pairs(this.layout) do
    x = screenWidth * layout_part[1] / this.gridparts
    y = screenHeight * layout_part[3] / this.gridparts + topbar_diff
    w = screenWidth * (layout_part[2] - layout_part[1]) / this.gridparts
    h = screenHeight * (layout_part[4] - layout_part[3]) / this.gridparts - topbar_diff
    table.insert(frames, hs.geometry.rect(x, y, w, h))
  end
  return frames
end

this.cycleWindow = function(win, forward)
  local frames = this.getLayoutFrames(win)
  local nearestFrameIndex = this.nearestFrameIndex(frames, win)
  local nearestFrame = frames[nearestFrameIndex]
  -- If frame already in position move to the next position
  if nearestFrame:floor():equals(win:frame():floor()) then
    if forward then
      nearestFrame = frames[(nearestFrameIndex % #frames) + 1]
    else
      nearestFrame = frames[((nearestFrameIndex + #frames - 2) % #frames) + 1]
    end
  end

  this.logger:i(win:frame():floor())
  this.logger:i(nearestFrame)
  win:setFrame(nearestFrame)
  this.logger:i(win:frame())
end

return this