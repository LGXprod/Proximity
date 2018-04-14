--display.setStatusBar(display.HiddenStatusBar)

--local composer = require("composer")

--composer.gotoScene("menu")

local composer = require("composer")

--hide status bar
display.setStatusBar ( display.HiddenStatusBar)

audio.reserveChannels( 1 )
audio.setVolume(0.5, {channel = 1})

math.randomseed( os.time())

composer.gotoScene("menu")