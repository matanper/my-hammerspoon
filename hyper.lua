-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, 'F19')

-- Enter Hyper Mode
function enterHyperMode()
  hyper:enter()
end

-- Leave Hyper Mode
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
end

-- Bind the Hyper key to key F20
f20 = hs.hotkey.bind({}, 'F20',enterHyperMode, exitHyperMode)

return hyper