local composer = require("composer")
local widget = require("widget")
physics.start()
local scene = composer.newScene()
local bg1
local bg2
local runtime = 0
local scrollSpeed = 6
local pausef = 0

function scene:create(event)
	local sceneGroup = self.view
	local function addScrollableBg() -- continuous background function
		if pausef == 0 then
		    local bgImage = { type="image", filename="gamebg.jpg" } -- image used for continuous background 

		    -- Add First bg image
		    bg1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
		    bg1.fill = bgImage
		    bg1.x = display.contentCenterX
		    bg1.y = display.contentCenterY

		    -- Add Second bg image
		    bg2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
		    bg2.fill = bgImage
		    bg2.x = display.contentCenterX
		    bg2.y = display.contentCenterY - display.actualContentHeight
		end
	end

	local function moveBg(dt) -- function that moves continuous background by moving by 1.4 16.67 times a second
		if pausef == 0 then
	    bg1.y = bg1.y + scrollSpeed * dt
	    bg2.y = bg2.y + scrollSpeed * dt

	    if (bg1.y - display.contentHeight/2) > display.actualContentHeight then
	        bg1:translate(0, -bg1.contentHeight * 2)
	    end
	    if (bg2.y - display.contentHeight/2) > display.actualContentHeight then
	        bg2:translate(0, -bg2.contentHeight * 2)
	    end
		end
	end

	local function getDeltaTime() -- Time in milliseconds since application launch
		if pausef == 0 then
		   local temp = system.getTimer()
		   local dt = (temp-runtime) / (1000/60)
		   runtime = temp
		   return dt
		end
	end

	local function enterFrame()
		if pausef == 0 then
		    local dt = getDeltaTime() -- delta time is used to compensate for if there is a framerate drop by making objects larger
		    moveBg(dt)
		end
	end

	function init() -- run continuous background fucntion
		if pausef == 0 then
		    addScrollableBg()
		    Runtime:addEventListener("enterFrame", enterFrame)
		end
	end

	if pausef == 0 then
		init()
		sceneGroup:insert(bg1)
		sceneGroup:insert(bg2)
	end

	local sheetData = { -- sheetData for the rocket contains information about the dimensions and frames within the image
    width=600,
    height=600,
    numFrames=33,
    sheetContentWidth=3600,
    sheetContentHeight=3600
  	}	

	local mySheet = graphics.newImageSheet( "rocket.png", sheetData ) 

  	local sequenceData = { -- information to determine the framerate and how many times to run the sprite
    	{name="rocket", start = 1, count = 33, time=3000, loopCount = 0}
  	}

  	local letterOutline = graphics.newOutline( 2, mySheet, sequenceData ) -- Creates a wireframe which fits exactly around the body of the rocket


	local rocket = display.newSprite( mySheet, sequenceData ) 
	rocket:scale( 0.75, 0.75 )
	rocket.width = 450
	rocket.height = 450
	rocket.x = 375
	rocket.y = 1100
	rocket.myName = "rocket_o"
	rx = rocket.x
	physics.addBody(rocket, "Static", { outline=letterOutline })
	rocket.gravityScale = 0
	local rocketCollisionFilter = { groupIndex = 1 }
	sceneGroup:insert( rocket )
	rocket.isVisible = true
	--physics.setDrawMode( "hybrid" )
  	
	rocket:play( )

	function rotateR()
		w=0
	end
	
	move = 1

	local function onTouch(event)
		if(event.phase == "ended") then 
			if pausef == 0 and move == 1 then
				move = 1
				transition.to(rocket, {x=event.x}) -- transitions the rocket to where the uses has tapped
				if event.x >= 695 then -- stops the user from moving the rocket to far to the left/off the screen
					event.x = 695
				end
				if event.x <= 50 then -- stops the user from moving the rocket to far to the right/off the screen
					event.x = 50
				end
				print( rocket.x )
				print( event.x )
				rocket.rotation = math.atan( ( event.x - rocket.x )/450 )*57.2958 -- trig calculation that works out the angle of elavation from the base of the rocket
				timer.performWithDelay( 0, rotateR, 1 )
				timer.performWithDelay( 3000, rotateR )
				if w == 0  then
					transition.to( rocket, {time=1250, rotation=0} ) -- changes the angle of elavation to zero over a span of 1.25 seconds
				end
			end
		end
	end

	Runtime:addEventListener("touch", onTouch)

	local numberAsteroids = 1 -- amount of asteroids spawned at once from the function

	local function spawnAsteroid() -- spawns the amount of asteroids indicated by the numberAsteroids variable every 1500 milliseconds continuously. The asteroids travel randomly between -10px to 700px and end y =1300. Physics body is used for collision detection.
	   	
	   	for i=1,numberAsteroids do

		   	asteroid = display.newImageRect("Asteroid.png", 80, 150) -- Changed to local if something goes wrong go back (delete local) 150,150
		   	asteroid:scale( 1.875, 1 )
		    local bx = math.random(-10,700)
		      asteroid.x = 400
		      asteroid.y = -40
		      transition.to( asteroid, { time=math.random(3000,4000), x=bx , y=1700, onComplete=clearasteroid } ) -- moves the asteroid across the screen in random directions at random speeds
		      physics.addBody( asteroid, "Static" ) 
		      asteroid.gravityScale = 0
		      sceneGroup:insert( asteroid )
		      local asteriodCollisionFilter = { groupIndex = 1 }
		      if bx > 400 then
		      	asteroid.rotation = (math.atan( (math.abs(bx - 400))*-1/1740))*57.2958 -- calculates the angle of depression the asteroid should be rotated when it goes it's given direction
		      elseif bx <= 400 then
		      	asteroid.rotation = (math.atan( (math.abs(bx - 400))/1540))*57.2958
		      end
		      asteroid.myName = "asteroid_o"
		      asteroid:toFront( )

		end

	end

	aTimers = {}
	aTimers[0] = timer.performWithDelay( 1500, spawnAsteroid, 0 ) -- calls the spawnAsteroid Function every 1.5 seconds continuously

	local distanceTxt = display.newText( "Distance:", 0, 0, "Prime", 75 )
	distanceTxt.x = display.contentWidth / 2
	distanceTxt.y = 70
	sceneGroup:insert(distanceTxt)

	local score = 0

	local scoreTxt = display.newText( "0", 0, 0, "Prime", 50 )
	scoreTxt.x = display.contentWidth / 2
	scoreTxt.y = 175
	sceneGroup:insert(scoreTxt)

	local function updateScore() -- adds 10 to score/distance
		score = score + 10 
	     scoreTxt.text = string.format("%d" .. " Gm", score)
	     -- the if statements below are called once the user reaches the distance of a planet
		if score == 250 then 
			marsInfo = display.newImage( "Marsinfo.png" )
			marsInfo.x = display.contentWidth/2
			marsInfo.y = display.contentHeight/2
			sceneGroup:insert(marsInfo)
			infopause()
		end
		if score == 560 then 
			jupiterInfo = display.newImage( "Jupiter.png" )
			jupiterInfo.x = display.contentWidth/2
			jupiterInfo.y = display.contentHeight/2
			sceneGroup:insert(jupiterInfo)
			infopause()
		end
		if score == 1200 then 
			saturnInfo = display.newImage( "Saturn.png" )
			saturnInfo.x = display.contentWidth/2
			saturnInfo.y = display.contentHeight/2
			sceneGroup:insert(saturnInfo)
			infopause()
		end
		if score == 2500 then 
			uranusInfo = display.newImage( "Uranus.png" )
			uranusInfo.x = display.contentWidth/2
			uranusInfo.y = display.contentHeight/2
			sceneGroup:insert(uranusInfo)
			infopause()
		end
		if score == 2900 then 
			neptuneInfo = display.newImage( "Neptune.png" )
			neptuneInfo.x = display.contentWidth/2
			neptuneInfo.y = display.contentHeight/2
			sceneGroup:insert(neptuneInfo)
			infopause()
		end
	end

	scoreTimer = timer.performWithDelay(200, updateScore, 0) -- calls the updateScore Function every 0.2 seconds continuously

	print( mars )

	pause = widget.newButton( -- creates button using the Pause.png image
    {
        width = 100,
        height = 100,
        defaultFile = "Pause.png",
        onEvent = handleButtonEvent
    }
	)

	pause.x = 645
	pause.y = 75
	pause.isVisible = false
	sceneGroup:insert(pause)
	pause:toFront( )

	function pauseVis()
		pause.isVisible = true
	end

	timer.performWithDelay( 1600, pauseVis, 1 )

	play = widget.newButton( -- creates button using the Play.png image
    {
        width = 100,
        height = 100,
        defaultFile = "Play.png",
        onEvent = handleButtonEvent
    }
	)

	play.x = 645
	play.y = 75
	sceneGroup:insert(play)
	play:toFront( )
	play.isVisible = false
	play:scale( 1.6, 1.6 )
	play:addEventListener( "touch", touchListener)

	local backgroundMusic = audio.loadStream( "backgroundmusic.mp3" ) --music file
	local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 } )

	local mute = widget.newButton( -- creates button using the Mute.png image
    {
        width = 100,
        height = 100,
        defaultFile = "Mute.png",
        onEvent = handleButtonEvent
    }
	)

	mute.x = 105
	mute.y = 70
	sceneGroup:insert(mute)
	mute:toFront( )
	mute.isVisible = false

	local unmute = widget.newButton( -- creates button using the volume.png image
    {
        width = 100,
        height = 100,
        defaultFile = "volume.png",
        onEvent = handleButtonEvent
    }
	)

	unmute.x = 105
	unmute.y = 70
	sceneGroup:insert(unmute)
	unmute:toFront( )
	unmute.isVisible = true

	local path = system.pathForFile( "myFile.txt", system.DocumentsDirectory ) -- path of the myFile text file found in Corona SDK's documentsDirectory
	print( path )
	 
	local file, errorString = io.open( path, "r" ) -- opens the file in read mode
	 
	if not file then

	    print( "File error: " .. errorString ) -- gives a print error if file isn't there
	else -- if the file is there it does the below
	    contents = file:read( "*a" ) -- all data within the text file is saved within a variable called contents in the string data type
	    print( "Contents of " .. path .. "\n" .. contents )

	   	io.close( file )
	end
	 
	file = nil

	local function onLocalCollision( self, event )
	    if ( event.phase == "began" ) then
	        stop()
	        rocket.isVisible = false
	        playpause = 0
	        rocket:removeEventListener( "collision", rocket )

		    if tonumber(contents) < score then -- converts contents from a string to integer and tests if it is less than the score obtained by the user

		    	local file = io.open( path, "w" ) -- if the user beats the previous highscore it oepns myFile.txt in write mode
		    	file:write( score ) -- it then writes the new highscore of the user to the file removing all previous data within it
		    	print( "Contents of " .. path .. "\n" .. contents )

			    io.close( file )
			    file = nil
			    
			end

			local path = system.pathForFile( "myFile.txt", system.DocumentsDirectory )
			print( path )
			 
			local file, errorString = io.open( path, "r" )
			 
			if not file then

			    print( "File error: " .. errorString )
			else
			    contents2 = file:read( "*a" ) --  the data from the text file is then read again and saved in the variable contents2 so if the user beats the previous highscore it updates on screen
			    print( "Contents of " .. path .. "\n" .. contents )

			   	io.close( file )
			end
			 
			file = nil

	        rect = display.newImage( "rrect.png" )
	        rect:scale( 1.55, 1.35 )
	        rect.x = display.contentWidth/2
			rect.y = display.contentHeight/2
			sceneGroup:insert(rect)
			gameover = display.newText( "Gameover", display.contentWidth/2, (display.contentHeight/2)-200, "Prime", 75 )
			sceneGroup:insert(gameover)
			dst = display.newText( "Final Distance: " .. score .. " Gm", display.contentWidth/2, (display.contentHeight/2)-75, "Prime", 55 )
			sceneGroup:insert(dst)
			highscore = display.newText( "Best Distance: " .. contents2 .. " Gm", display.contentWidth/2, (display.contentHeight/2)+50, "Prime", 55 )
			sceneGroup:insert(highscore)

			btn_playA = widget.newButton( {
			label = "Play Again",
			fontSize = 32,
			shape = "roundedRect",
			width = 250,
			height = 80,
			cornerRadius = 10,
			fillColor = { default = {1, 1, 1, 1}, over = {1, 0, 0, 0.5}},
		    strokeColor = { default = {0, 0, 0, 0}, over = {1, 1, 1, 1}},
			strokeWidth = 8,
			onEvent = handleButtonEvent, 
			} )	

			btn_playA.x = (display.contentWidth/2) - 200
			btn_playA.y = (display.contentWidth/2) + 475
			print( btn_playA.x )
			print( btn_playA.y )
			btn_playA:addEventListener("touch", touchListener)
			sceneGroup:insert(btn_playA)

			btn_menu = widget.newButton( {
			label = "Back to Menu",
			fontSize = 32,
			shape = "roundedRect",
			width = 250,
			height = 80,
			cornerRadius = 10,
			fillColor = { default = {1, 1, 1, 1}, over = {1, 0, 0, 0.5}},
		    strokeColor = { default = {0, 0, 0, 0}, over = {1, 1, 1, 1}},
			strokeWidth = 8,
			onEvent = handleButtonEvent, 
			} )	

			btn_menu.x = (display.contentWidth/2) + 200
			btn_menu.y = (display.contentWidth/2) + 475
			btn_menu:addEventListener("touch", touchListener)
			sceneGroup:insert(btn_menu)

			manual = widget.newButton( 
		    {
		        width = 100,
		        height = 100,
		        defaultFile = "manualicon.png",
		        onEvent = handleButtonEvent
		    }
			)

			manual.x = display.contentWidth/2
			manual.y = 850
			sceneGroup:insert(manual)
			manual:toFront( )
			manual:scale( 1.6, 1.6 )
			manual:addEventListener( "touch", touchListener)

			function btn_menu:touch( event ) 
		      if event.phase == "began" then
		      	score = 0
		      	playpause = 1 -- stops the rocket from moving if you press the buttons in the ui (if statements later enable this)
			 
				pausef = 1 -- when this variable is set to one it pauses the continuous background function and some other components of the program
				timer.pause( aTimers[0] ) -- stops asteroids from being spawned
				timer.pause( scoreTimer ) -- pauses the score
				transition.pause( asteroid[0] ) -- stops the previous asteroid on screen
				rocket:pause() -- pauses the rocket sprite
				Runtime:removeEventListener("touch", onTouch) -- removes the event listener for touch
				pause.isVisible = false
				play.isVisible = true 
				display.remove( marsInfo ) -- removes the mars infographic if it is there
				display.remove( jupiterInfo )
				display.remove( saturnInfo )
				display.remove( uranusInfo )
				display.remove( neptuneInfo )
				composer.gotoScene("menu")

		        return true
		      end
		    end

		    function btn_playA:touch( event ) 
		      if event.phase == "began" then
		 		reset() 
		        return true
		      end
		    end

		    function manual:touch( event ) 
		      if event.phase == "began" then
		      	score = 0 
		      	playpause = 1
			 
				pausef = 1 
				timer.pause( aTimers[0] ) 
				timer.pause( scoreTimer ) 
				transition.pause( asteroid[0] ) 
				rocket:pause()  
				Runtime:removeEventListener("touch", onTouch)
				pause.isVisible = false
				play.isVisible = true 
				display.remove( marsInfo )
				display.remove( jupiterInfo )
				display.remove( saturnInfo )
				display.remove( uranusInfo )
				display.remove( neptuneInfo )
		 		composer.gotoScene( "manual" )

		        return true
		      end
		    end

	    end
	end

	rocket.collision = onLocalCollision
	rocket:addEventListener( "collision" )

	function stop()
		pausef = 1
		timer.pause( aTimers[0] ) 
		timer.pause( scoreTimer )
		transition.pause( asteroid[0] )
		rocket:removeEventListener( "collision", rocket )
		Runtime:removeEventListener("touch", onTouch)
		pause.isVisible = false 
		play.isVisible = true 
	end

	function reset()
		physics.pause()
		score = 0
		btn_playA:removeSelf( )
		btn_menu:removeSelf( )
		rect:removeSelf( )
		gameover:removeSelf( )
		dst:removeSelf( )
		highscore:removeSelf( )
		manual:removeSelf( )

		rocket.isVisible = true
		rocket.x = display.contentWidth/2
		rocket.y = 1100

	    temp = display.newImage( "Blurgrey.png" )
	    temp.x = display.contentWidth/2
	    temp.y = display.contentHeight/2

	    transition.fadeOut( temp, { time=5000 } )

    	local time = 3

		local timeTxt = display.newText( "Resumes in: 3", 0, 0, "Prime", 72 )
		timeTxt.x = display.contentWidth / 2
		timeTxt.y = display.contentHeight/2 
		sceneGroup:insert(timeTxt)

		local function updateTime() -- adds 5 to score each 200 milliseconds
			time = time - 1 -- should be 1
		    	timeTxt.text = string.format("Resumes in: " .. "%d", time)
		end

		timedeplay = timer.performWithDelay(1000, updateTime, 3)

		local function removeTxt()
			transition.fadeOut( timeTxt, { time=3000 } )
			physics.start()
		end

		local function addcollision()
			rocket:addEventListener( "collision" )
			playpause = 1 --
		end

		removetxtDelay = timer.performWithDelay(3000, removeTxt, 1)

		addcollisionDelay = timer.performWithDelay(4000, addcollision, 1)
	 
		pausef = 0
		timer.resume( aTimers[0] )
		timer.resume( scoreTimer )
		transition.resume( asteroid[0] )
		Runtime:addEventListener("touch", onTouch)
		pause.isVisible = true
		play.isVisible = false
		display.remove( marsInfo )
		display.remove( jupiterInfo )
		display.remove( saturnInfo )
		display.remove( uranusInfo )
		display.remove( neptuneInfo )
	end

	function mute:touch( event )
		if event.phase == "began" then
			unmute.isVisible = true 
          	mute.isVisible = false
          	audio.resume( backgroundMusicChannel )
          	move = 0 
          	local function addTouch()
          		move = 1
          	end
          	timer.performWithDelay( 500, addTouch, 1 ) -- find lowest time that still stops the rocket from moving
		end
	end

	function unmute:touch( event )
		if event.phase == "began" then
			unmute.isVisible = false 
          	mute.isVisible = true
          	audio.pause( backgroundMusicChannel )
          	move = 0 
          	local function addTouch()
          		move = 1
          	end
          	timer.performWithDelay( 500, addTouch, 1 ) -- find lowest time that still stops the rocket from moving
		end
	end

	function infopause()
		--Runtime:removeEventListener("enterFrame", enterFrame)
          	pausef = 1
			timer.pause( aTimers[0] ) --
			timer.pause( scoreTimer ) -- 
			transition.pause( asteroid[0] ) --
			rocket:pause() -- 
			Runtime:removeEventListener("touch", onTouch)
			pause.isVisible = false -- 
			play.isVisible = true --
	end	

	playpause = 1

	function play:touch( event ) -- when unmute button is touched makes the: unmute button invisible, the mute button visible and pauses the audio
          if event.phase == "began" and playpause == 1 then
          	--Runtime:addEventListener("enterFrame", enterFrame)
          	pausef = 0
          	local function addTouch()
          		move = 1
          	end
          	timer.performWithDelay( 500, addTouch, 1 ) -- find lowest time that still stops the rocket from moving
			timer.resume( aTimers[0] )
			timer.resume( scoreTimer )
			transition.resume( asteroid[0] )
			rocket:play()
			Runtime:addEventListener("touch", onTouch)
			pause.isVisible = true
			play.isVisible = false
			display.remove( marsInfo )
			display.remove( jupiterInfo )
			display.remove( saturnInfo )
			display.remove( uranusInfo )
			display.remove( neptuneInfo )
		end
	end

	function pause:touch( event ) -- when unmute button is touched makes the: unmute button invisible, the mute button visible and pauses the audio
          if event.phase == "began" and playpause == 1 then 
          	--Runtime:removeEventListener("enterFrame", enterFrame)
          	pausef = 1
          	move = 0
			timer.pause( aTimers[0] ) 
			timer.pause( scoreTimer ) 
			transition.pause( asteroid[0] ) 
			rocket:pause() 
			Runtime:removeEventListener("touch", onTouch)
			pause.isVisible = false 
			play.isVisible = true 
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