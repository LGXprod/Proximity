
local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local json = require("json")
local scoresTable = {}

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)
 
local function loadScores()
    local file = io.open( filePath, "r")

    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
    if (scoresTable == nil or #scoresTable == 0) then
        scoresTable = {0,0,0,0,0,0,0,0}
    end
end

local function saveScores()

    for i = #scoresTable, 11, -1 do
        table.remove(scoresTable, i)
    end

    local file = io.open( filePath, "w" )

    local temp = json.encode(scoresTable)

    file:write( temp )
    io.close(file)
end

local function gotoMenu()
    composer.gotoScene("menuM")
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    loadScores()

    table.insert( scoresTable, composer.getVariable("finalScore"))
    composer.setVariable("finalScore",0)

    local function compare(a, b)
        return a > b
    end
    table.sort(scoresTable, compare)

    saveScores()

    local background1 = display.newImageRect(sceneGroup, "background1.jpg", 750, 1334)
    background1.x = display.contentCenterX
    background1.y = display.contentCenterY
    background1:toBack()

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 100, nil, 44)

    for i = 1, 10 do

        if (scoresTable[i]) then
            local yPos = 150 + (i * 56)
            local rankNum = display.newText(sceneGroup, i .. ") ", display.contentCenterX-50, yPos, nil, 35)
            rankNum:setFillColor(0.8)
            rankNum.anchorX = 1

            local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, nil, 35)
            thisScore.anchorX = 0
        end
    end

local menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 810, nil, 44)
menuButton:setFillColor(0.75, 0.78, 1)
menuButton:addEventListener("tap", gotoMenu)
end
-- show()
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
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("highScoresM")
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

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