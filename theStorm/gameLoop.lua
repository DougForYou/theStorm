--is the player on the ground?
onGround  = false

--Set a ramndom number variable
--at any given moment this decides whether we spawn a house, tree, or nothing
spawner = 0

rainWait = 10
rainState = false
rain1 = love.graphics.newImage("graphics/rain1.png")
rain2 = love.graphics.newImage("graphics/rain2.png")

--we need a table to keep track of all trees on the screen
bgTrees = {}
bgTrees.__index = tree
treeImg = love.graphics.newImage("graphics/blackTree.png")
treeSpawnWait = 0
--same for houses
houseTable = {}
houseTable.__index = house
houseSpawnWait = 6
houseImg = love.graphics.newImage("graphics/house1.png")

setDressing = 0

doDialogue = false

function gameRunning(wWidth, wHeight, sfWidth, sfHeight, dt)
	--first define where the ground is
	groundY = wHeight*0.8
	
	if onGround == false then
		if player.y < groundY - player.height then
			player.y = player.y+(player.speed*dt)
		else
			onGround = true
		end
	end
	
	if player.movingForward then
		progress = progress + 1*dt
	end
	
	animatePlayer(dt)
	runEnvironment(sfWidth, sfHeight, dt)
end

function drawGame(wWidth, wHeight)
	--Draw background elements before the player
	love.graphics.setColor(255,255,255)
	--The elements are drawn from back to front
	for i, house in ipairs(houseTable) do
		love.graphics.draw(house.img, house.x, house.y, 0, sfWidth, sfHeight)
	end
	for i, tree in ipairs(bgTrees) do
		love.graphics.draw(tree.img, tree.x, tree.y, 0, sfWidth, sfHeight)
	end
	
	--THE GROUND.
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, groundY, wWidth, wHeight*0.2)

	--Draw the player
	love.graphics.setColor(255, 255, 255)
	if player.movingForward then 
		player.animations.right:draw(player.spriteSheet, player.x, player.y, nil, sfWidth, sfHeight)
	elseif player.movingBackward then
		player.animations.left:draw(player.spriteSheet, player.x, player.y, nil, sfWidth, sfHeight)
	else
		player.animations.right:draw(player.spriteSheet, player.x, player.y, nil, sfWidth, sfHeight)
	end
	
	--Draw the rain over everything
	love.graphics.setColor(255, 255, 255)
	if rainState then
		love.graphics.draw(rain1, 0, 0, 0, sfWidth, sfHeight)
		print("Rain state: 1")
	else
		love.graphics.draw(rain2, 0, 0, 0, sfWidth, sfHeight)
		print("Rain state: 2")
	end
	
	--Text boxes go in front of the rain
	
end

--
--
function animatePlayer(dt)
	if player.movingBackward then
		player.animations.left:update(dt)
	elseif player.movingForward then 
		player.animations.right:update(dt)
	end
end


--
--
function runEnvironment(sfWidth, sfHeight, dt)
	--All the functions to do with the environment
	doTrees(sfWidth, sfHeight, dt)
	doHouses(sfWidth, sfHeight, dt)
	rain()
end
--We're going to deal with the set dressing in this section
--Staring with the trees
function spawnTree(groundY, sfWidth, sfHeight)
	setDressing = setDressing+1
	
	treeDecider = math.random(1, 3)
	if treeDecider == 1 then
		currentImg = love.graphics.newImage("graphics/blackTree.png")
	elseif treeDecider == 2 then
		currentImg = love.graphics.newImage("graphics/blackTree2.png")
	else
		currentImg = love.graphics.newImage("graphics/whiteTree.png")
	end
	
	instance = setmetatable({}, bgTrees)
	instance.width = 200 * sfWidth
	instance.height = 200* sfHeight
	instance.x = wWidth
	instance.y = groundY - instance.height
	instance.img = currentImg
	table.insert(bgTrees, instance)
	
	treeSpawnWait = math.random(4, 10)
end
function doTrees(sfWidth, sfHeight, dt)
	--Progress the game by moving forward
	if player.movingForward and player.centred then
		--Only increment the tree spawner as the player moves
		--That way we wont get weird overlapping trees if the player stands still for too long
		treeSpawnWait = treeSpawnWait - (1*dt)
	end
	
	if setDressing == 0 or treeSpawnWait <= 0 then
		spawnTree(groundY, sfWidth, sfHeight)
	end
	
	if player.movingForward and player.centred then
		for i, tree in ipairs(bgTrees) do
			print(tree.x)
			tree.x = tree.x - player.speed*dt
		end
	end
	
	for i, tree in ipairs(bgTrees) do
		if tree.x < 0 - tree.width then
			table.remove(bgTrees, 1)
		end
	end
end

--
--
--Then the houses
function spawnHouse()
	setDressing = setDressing+1
	
	houseDecider = math.random(1, 2)
	if houseDecider == 1 then
		currentImg = love.graphics.newImage("graphics/house1.png")
	elseif houseDecider == 2 then
		currentImg = love.graphics.newImage("graphics/house2.png")
	end
	
	instance = setmetatable({}, houseTable)
	instance.width = 200 * sfWidth
	instance.height = 200* sfHeight
	instance.x = wWidth
	instance.y = groundY - instance.height
	instance.img = currentImg
	table.insert(houseTable, instance)
	
	houseSpawnWait = math.random(5, 12)
end
function doHouses(sfWidth, sfHeight, dt)
	if player.movingForward and player.centred then
		houseSpawnWait = houseSpawnWait - (1*dt)
	end
	
	if setDressing == 0 or houseSpawnWait <= 0 then
		spawnHouse(groundY, sfWidth, sfHeight)
	end
	
	if player.movingForward and player.centred then
		for i, house in ipairs(houseTable) do
			print(house.x)
			house.x = house.x - (player.speed*1.3)*dt
		end
	end
	
	for i, house in ipairs(houseTable) do
		if house.x < 0 - house.width then
			table.remove(houseTable, 1)
		end
	end
end


--
--
--Now the rain
function rain(sfWidth, sfHeight)
	--Control which rain sprite is active
	if rainWait <= 0 and not rainState then
		rainWait = 10
		rainState = true
	elseif rainWait <= 0 and rainState then
		rainWait = 10
		rainState = false
	else
		rainWait = rainWait - 0.2
		print("Rain Wait:".. rainWait)
	end
end