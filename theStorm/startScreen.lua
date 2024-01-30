local splash = love.graphics.newImage("graphics/title.png")
splashY = -300
startingSplash = -300
fadeAway = false

function startUp(wWidth, wHeight)
	--Get the size of the title image
	splashWidth = splash:getWidth()
	splashHeight = splash:getHeight()
	splashX = (wWidth/2) - ((splashWidth*sfWidth)/2)
	--Position the title image in the middle of the screen
	finalY = (wHeight/2) - ((splashHeight*sfHeight)/2)
	
	if splashY < finalY and gamestate == 0 then
		splashY = splashY + 0.5
	end
	if gamestate == 1 and splashY > startingSplash then
		splashY = splashY - 0.3
	end
	
	print("splashY:"..splashY)
end

function drawStart(sfWidth, sfHeight, gamestate)
	love.graphics.setColor(255, 255, 255, 255)
	--Draw the title image
	love.graphics.draw(splash, splashX, splashY, 0, sfWidth, sfHeight)		
end