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

	local sheetData = {
    width=800,
    height=600,
    numFrames=164,
    sheetContentWidth=8800,
    sheetContentHeight=9000
  	}	

	local mySheet = graphics.newImageSheet( "Background2.png", sheetData ) -- image of the spritesheet used for the animated background

  	local sequenceData = { -- information about the above spritesheet which is required to run
    	{name="background", start = 1, count = 164, time=6000, loopCount = 0}
  	}

	local background = display.newSprite( mySheet, sequenceData ) 
	background:scale( 1.75, 1.75 )
	background.x = display.contentWidth/2
	background.y = display.contentHeight/2
	background.gravityScale = 0
	background.rotation = 90
	sceneGroup:insert( background )
  
	background:play( ) -- runs the sprite using the information from mySheet and sequenceData

	title = display.newImage( "EG.png" ) 
	title.x = display.contentWidth/2
	title:scale( 0.85, 0.85 )
	title.y = 275
	sceneGroup:insert(title)
	
	btn_Proximity = widget.newButton( {
	label = "Proximity",
	fontSize = 32,
	shape = "roundedRect",
	width = 400,
	height = 80,
	cornerRadius = 10,
	fillColor = { default = {1, 1, 1, 1}, over = {1, 0, 0, 0.5}},
    strokeColor = { default = {0, 0, 0, 0}, over = {1, 1, 1, 1}},
	strokeWidth = 8,
	onEvent = handleButtonEvent, 
	} )	

	btn_Proximity.x = (display.contentWidth / 2) - 50
	btn_Proximity.y = 500
	sceneGroup:insert(btn_Proximity)
	btn_Proximity:addEventListener("touch", touchListener) -- event listener is triggered when user touchs the button

	btn_Eric = widget.newButton( {
	label = "Eric's Game",
	fontSize = 32,
	shape = "roundedRect",
	width = 525,
	height = 80,
	cornerRadius = 10,
	fillColor = { default = {1, 1, 1, 1}, over = {1, 0, 0, 0.5}},
    strokeColor = { default = {0, 0, 0, 0}, over = {1, 1, 1, 1}},
	strokeWidth = 8,
	onEvent = handleButtonEvent, 
	} )	

	btn_Eric.x = (display.contentWidth / 2) + 10
	btn_Eric.y = 700
	sceneGroup:insert(btn_Eric)
	btn_Eric:addEventListener("touch", touchListener) -- event listener is triggered when user touchs the button

	btn_Micheal = widget.newButton( {
	label = "Space Invaders",
	fontSize = 32,
	shape = "roundedRect",
	width = 525,
	height = 80,
	cornerRadius = 10,
	fillColor = { default = {1, 1, 1, 1}, over = {1, 0, 0, 0.5}},
    strokeColor = { default = {0, 0, 0, 0}, over = {1, 1, 1, 1}},
	strokeWidth = 8,
	onEvent = handleButtonEvent, 
	} )	

	btn_Micheal.x = (display.contentWidth / 2) + 10
	btn_Micheal.y = 900
	sceneGroup:insert(btn_Micheal)
	btn_Micheal:addEventListener("touch", touchListener) -- event listener is triggered when user touchs the button

	btn_About = widget.newButton( {
	label = "User Manuals Excluding Proximity",
	fontSize = 32,
	shape = "roundedRect",
	width = 525,
	height = 80,
	cornerRadius = 10,
	fillColor = { default = {1, 1, 1, 1}, over = {1, 0, 0, 0.5}},
    strokeColor = { default = {0, 0, 0, 0}, over = {1, 1, 1, 1}},
	strokeWidth = 8,
	onEvent = handleButtonEvent, 
	} )	

	btn_About.x = (display.contentWidth / 2) + 10
	btn_About.y = 1100
	sceneGroup:insert(btn_About)
	btn_About:addEventListener("touch", touchListener) -- event listener is triggered when user touchs the button

	function btn_Proximity:touch( event ) 
      if event.phase == "ended" then -- once the button has been pressed and released it goes to my game proximity
     	composer.gotoScene("Proximity")
          return true
      end
    end

    function btn_Micheal:touch( event ) 
      if event.phase == "ended" then -- once the button has been pressed and released it goes to Michael's game space invaders
     	composer.gotoScene("menuM")
          return true
      end
    end

    manual = widget.newButton( 
    {
        width = 100,
        height = 100,
        defaultFile = "manualiconwhite.png",
        onEvent = handleButtonEvent
    }
	)

	manual.x = btn_Proximity.x + 275
	manual.y = btn_Proximity.y 
	sceneGroup:insert(manual)
	manual:addEventListener( "touch", touchListener)

	function manual:touch( event ) 
        if event.phase == "began" then -- once the button has been pressed it goes to the user manual scene
          	composer.gotoScene( "manual" )
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
