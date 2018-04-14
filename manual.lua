local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view

	background = display.newImage( "Blurgrey.png" )
	background.x = display.contentWidth/2
	background.y = display.contentHeight/2
	sceneGroup:insert(background)

	title = display.newText( "User Manual", display.contentWidth/2, 100, "Prime", 75 )
	rocket_Controls = display.newText( "How to move the rocket:", 250, 200, "Prime", 40 )
	sceneGroup:insert(title)
	sceneGroup:insert(rocket_Controls)

	rocketcontrol = display.newImage( "rocketcontrol.png" )
	rocketcontrol2 = display.newImage( "rocketcontrol2.png" )
	rocketcontrol:scale( 0.75, 0.75 )
	rocketcontrol2:scale( 0.75, 0.75 )
	sceneGroup:insert(rocketcontrol)
	sceneGroup:insert(rocketcontrol2)

	rocketcontrol.x = 150
	rocketcontrol.y = 475

	rocketcontrol2.x = 600
	rocketcontrol2.y = 475

	rocketexplained = display.newImage( "rocketexplained.png" )
	rocketexplained.x = display.contentWidth/2
	rocketexplained.y = 1000
	sceneGroup:insert(rocketexplained)

	nextButton = widget.newButton( -- creates button using the unmute.png image
    {
        width = 100,
        height = 100,
        defaultFile = "Nextbutton.png",
        onEvent = handleButtonEvent
    }
	)

	nextButton.x = 675
	nextButton.y = 1250
	sceneGroup:insert(nextButton)
	nextButton:addEventListener( "touch", touchListener)

	function nextButton:touch( event ) -- touch function which enables the user to go to the next page of the user manual
        if event.phase == "began" then
          	composer.gotoScene( "manual2" )
		end
	end

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