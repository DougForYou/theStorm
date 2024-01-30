--Global variables so the dialogue box can be read from anywhere
widthScale = love.graphics.getWidth()
heightScale = love.graphics.getHeight()
dBox = {}
dBox.x = widthScale*0.1
dBox.y = heightScale*0.2
dBox.width = widthScale*0.8
dBox.height = 80
--These variables are for animating the text box
dBox.currentWidth = 1
dialoguePosition = 0
opacity = 0

function getDialogueOptions()
	options = {}
	options.o1 = "You always end up back here..."
	return options
end

function drawDialogueBox(dt, currentDialogue)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", dBox.x, dBox.y, dBox.currentWidth, dBox.height)
	if dBox.currentWidth == dBox.width then
		drawText(currentDialogue)
	else
		dBox.currentWidth = dBox.currentWidth+1
	end
end

function drawText(currentDialogue)
	love.graphics.setColor(255,255,255, opacity)
	love.graphics.print(currentDialogue, dBox.x*1.1, dBox.y*1.1, 0, 4, 4)
	
	if opacity < 255 then
		opacity = opacity + 0.005
	end
end