require "conf"
require "gameLoop"
require "input"
require "startScreen"
require "dBoxCode"
anim8 = require "libraries/anim8"

--This is how fast the game will progress as the player moves forward
progress = 0

--Whether the game is running
--0 for the start screen
--1 for running
gamestate = 0

--Using a static image for the background
gradient = love.graphics.newImage("graphics/gradient.jpg")

--Get the original render size for the game.
--On different window sizes we can scale to this
ogWidth = 1200
ogHeight = 500

--Make sure we have the window dimensions
--We will need these for scaling purposes
wWidth = love.graphics.getWidth()
wHeight = love.graphics.getHeight()

--find the difference between the og resolution and the current window size
sfWidth = wWidth/ogWidth
sfHeight = wHeight/ogHeight	

--objects for trees and houses
tree = {}
tree.x = 10000
tree.y = 10000
tree.width = 90*sfWidth
tree.height = 90*sfHeight
tree.img = love.graphics.newImage("graphics/blackTree.png")

house = {}
house.x = 10000
house.y = 10000
house.width = 200*sfWidth
house.height = 200*sfHeight
house.img = love.graphics.newImage("graphics/house1.png")

function love.load()
	--define our player
	player = {}
	--Dimensions and position
	player.width = 30 * sfWidth
	player.height = 75 * sfHeight
	player.x = wWidth/10 *sfWidth
	player.y = (wHeight/2 - player.height/2) * sfHeight
	--Player movement
	player.speed = 80 * sfWidth
	player.movingForward = false
	player.movingBackward = false
	player.centred = false
	player.direction = "right"
	--Player sprite
	player.spriteSheet = love.graphics.newImage("graphics/playerSprite.png")
	player.grid = anim8.newGrid(30, 75, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
	--Animate the player
	player.animations = {}
	player.animations.right = anim8.newAnimation(player.grid('1-4', 1), 0.3)
	player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.3)

	getDialogueOptions()
end

function love.update(dt)
	getKeyboardInput(player, wWidth, wHeight, dt)
	startUp(wWidth, wHeight, sfHeight)
	if love.keyboard.isDown("space") and gamestate == 0 then
		gamestate = 1
	end
	if gamestate == 1 then
		gameRunning(wWidth, wHeight, sfWidth, sfHeight, dt)
	end
end

function love.draw(dt)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(gradient, 0, 0, 0, sfWidth, sfHeight)
	drawStart(sfWidth, sfHeight, gamestate)
	if gamestate == 1 then
		drawGame(wWidth, wHeight, dt)
	end
end