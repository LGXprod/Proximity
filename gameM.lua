local composer = require( "composer" )
 
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)

local math = require("math")

local physics = require ("physics")
physics.start()

local backgroundMusic
local explosionSound
local fireSounds
 
physics.setGravity(0,0)
math.randomseed( os.time() )

-- Initialize variables
local lives = 1
local score = 0
local died = false

local gameLoopTimer
local livesText
local scoreText
local enemy
local ship

local uniGroup
local backGroup 

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function updateText()
    livesText.text = "Lives: "..lives
    scoreText.text = "Score: "..score
end

local function createAlien()
    local newAlien = display.newImageRect("enemy.png", 100, 100)
    physics.addBody(newAlien, "dynamic", {radius=30, bounce = 0.8})
    newAlien.myName = "alien"

    local whereFrom = math.random(3)

    if (whereFrom == 1 ) then
        newAlien.x = -60
        newAlien.y = math.random(400)
        newAlien:setLinearVelocity( math.random(40, 120), math.random(120,170))

    elseif (whereFrom == 2) then
        newAlien.x = math.random(display.contentWidth)
        newAlien.y = -60
        newAlien:setLinearVelocity(math.random(0,0),math.random(110,180))

    elseif (whereFrom == 3) then
        newAlien.x = display.contentWidth+60
        newAlien.y = math.random(400)
        newAlien:setLinearVelocity(math.random(-120,-40),math.random(120,170))
    end

    newAlien:applyTorque (math.random(0,0))
end

-- Remove enemy ships that have drifted off screen
local function gameLoop()
    createAlien()
        local thisAlien = newAlien
        if (  thisAlien.x < -100 or
              thisAlien.x > display.contnetWidth + 100 or
              thisAlien.y < -100 or
              thisAlien.y > display.contentHeight + 100  )
        then
            display.remove( thisAlien )
        end
end


local function fireLaser()
    local newLaser = display.newImageRect("laser.png", 50, 100)
    physics.addBody(newLaser, "dynamic", {isSensor = true})
    newLaser.isBullet = true
    newLaser.myName = "laser"
    newLaser.x = ship.x
    newLaser.y = ship.y
    audio.play ( fireSounds )
    transition.to(newLaser, {y =-40, time = 500,
        onComplete = function() display.remove(newLaser) end})
end

local function dragShip(event)
    local ship = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.currentStage:setFocus(ship)
        ship.touchOffsetX = event.x - ship.x
        ship.touchOffsetY = event.y - ship.y

    elseif ("moved" == phase) then
        ship.x = event.x - ship.touchOffsetX
        ship.y = event.y - ship.touchOffsetY
    elseif ("ended" == phase) then
        display.currentStage:setFocus(nil)
    end
    return true
end
--restore the ship
local function restoreShip()
    ship.isBodyActive = false
    ship:setLinearVelocity(0,0)
    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 100

    transition.to(ship, {alpha = 1, time = 4000,
        onComplete = function()
            ship.isBodyActive = true
            died = false
        end })
end

local function endGame()
    for id, value in pairs(timer._runlist) do
        timer.cancel( value )
    end
    
    composer.removeScene("gameM")
    composer.setVariable("finalScore",score)
    composer.gotoScene("highScoresM",{time = 2000, effect = "fade"})
    
end

--enable objects to cancel each other
local function onCollision(event)
    if (event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2
        --identify the object as laser and asteroid
        if ((obj1.myName == "laser" and obj2.myName == "alien")or
            (obj1.myName == "alien" and obj2.myName == "laser"))
        then
            display.remove(obj1)
            display.remove(obj2)
            audio.play (explosionSound)

            score = score + 100
            scoreText.text = "Score: "..score
        elseif ((obj1.myName == "ship" and obj2.myName == "alien")or
                (obj1.myName == "alien" and obj2.myName == "ship"))
        then 
            if (died == false) then
                died = true
                audio.play(explosionSound)
                --update lives
                lives = lives - 1
                livesText.text = "Lives: "..lives

                if (lives == 0) then
                    display.remove(ship)
                    timer.performWithDelay(2000, endGame)
                else
                    ship.alpha = 0
                    timer.performWithDelay( 1000, restoreShip )
                end
            end
        end
    end
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    physics.pause()

    explosionSound = audio.loadSound("explosion.wav")
    fireSounds = audio.loadSound("laser.wav")

    backGroup = display.newGroup()
    sceneGroup:insert(backGroup)

    uiGroup = display.newGroup()
    sceneGroup:insert(uiGroup)

    -- Load the background
    local background2 = display.newImageRect( backGroup, "background2_2.png", 750, 1334)
    background2.x = display.contentCenterX
    background2.y = display.contentCenterY
    background2:toBack()
    backGroup:insert(background2)

    ship = display.newImageRect("ship.png", 50, 100)
    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 100
    physics.addBody( ship, { radius = 30} )
    ship.myName = "ship"

    backgroundMusic = audio.loadStream("X-Ray Dog - String Tek.mp3")
    -- Display lives and score
    livesText = display.newText( sceneGroup, "Lives: "..lives, 100, 100, native.systemFont, 36 )
    scoreText = display.newText( sceneGroup, "Score: "..score, 300, 100, native.systemFont, 36 )

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        Runtime:addEventListener("collision", onCollision)
        ship:addEventListener("tap", fireLaser)
        ship:addEventListener("touch", dragShip)
        timer.performWithDelay(1000, createAlien,0)
        audio.play(backgroundMusic, {channel = 1, loops = -1})
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
            Runtime:removeEventListener("collision", onCollision)
            physics.pause()
            audio.stop(1)
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