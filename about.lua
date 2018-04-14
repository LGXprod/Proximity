local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()
local title
local background
local btn_Proximity
local btn_Eric
local btn_Micheal
local btn_Manual
local btninfo

function scene:create(event)
	local sceneGroup = self.view

	

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will") then
	elseif (phase == "did") then
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	sceneGroup:removeSelf()
	sceneGroup = nil
end --gets rid of everything within scene when a button is touched to go to another scene

scene:addEventListener( "create", scene)
scene:addEventListener( "show", scene)
scene:addEventListener( "hide", scene)
scene:addEventListener( "destroy", scene)

return scene
