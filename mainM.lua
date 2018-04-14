local composer = require("composer")

--hide status bar
display.setStatusBar ( display.HiddenStatusBar)

audio.reserveChannels( 1 )
audio.setVolume(0.5, {channel = 1})

math.randomseed( os.time())

composer.gotoScene("menuM")