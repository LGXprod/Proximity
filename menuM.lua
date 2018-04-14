local composer = require("composer")

local scene = composer.newScene()

local function gotoGame()
	composer.removeScene("gameM")
	composer.gotoScene("gameM")
end

local function gotoHighScores()
	composer.setVariable("finalScore")
	composer.removeScene("highScoresM")
	composer.gotoScene("highScoresM")
end

function scene:create( event )
	local sceneGroup = self.view
	local background1 = display.newImageRect( sceneGroup, "background1.jpg", 750, 1334)
	background1.x = display.contentCenterX
	background1.y = display.contentCenterY
	background1:toBack()
	sceneGroup:insert(background1)

	local title = display.newImageRect(sceneGroup, "title.png", 700, 600)
	title.x = display.contentCenterX
	title.y = 300

	local gameText = display.newText(sceneGroup, "Play", display.contentCenterX, 700, nil, 44)
	local highScoreText = display.newText(sceneGroup, "High Score", display.contentCenterX, 810, nil, 44)

	gameText:addEventListener("tap", gotoGame)
	highScoreText:addEventListener("tap", gotoHighScores)
	
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "ended" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 	composer.removeScene("menuM")
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene