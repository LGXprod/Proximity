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
	rocket_Controls = display.newText( "Basic Outline of Game Events:", 300, 225, "Prime", 40 )
	sceneGroup:insert(title)
	sceneGroup:insert(rocket_Controls)

	explaination = display.newImage( "Explaination2.png" )
	explaination.x = display.contentWidth/2
	explaination.y = 650
	explaination:scale( 1.2, 1.2 )
	sceneGroup:insert(explaination)

	example = display.newImage( "example.png" )
	example.x = display.contentWidth/2
	example.y = 1025
	example:scale( 0.325, 0.325 )
	sceneGroup:insert(example)

	btn_Menu = widget.newButton( {
	label = "Menu",
	fontSize = 32,
	shape = "roundedRect",
	width = 175,
	height = 80,
	cornerRadius = 10,
	fillColor = { default = {1, 1, 1, 1}, over = {1, 0, 0, 0.5}},
    strokeColor = { default = {0, 0, 0, 0}, over = {1, 1, 1, 1}},
	strokeWidth = 8,
	onEvent = handleButtonEvent, -- event listener function
	} )	

	btn_Menu.x = 645
	btn_Menu.y = 1265
	sceneGroup:insert(btn_Menu)
	btn_Menu:addEventListener("touch", touchListener)

	function btn_Menu:touch( event ) 
      if event.phase == "began" then
     	composer.gotoScene("menu") -- touch function which enables the user to get back to the menu
          return true
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