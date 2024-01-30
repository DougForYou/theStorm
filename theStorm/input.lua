function getKeyboardInput(player, wWidth, wHeight, dt)
	--Basic movement controls
	-- A = left
	-- D = right
	if love.keyboard.isDown("a") then
		--Dont let the player go off the side of the screen
		if player.x > 0 then
			player.x = player.x - player.speed*dt
			player.movingBackward = true
			print("Player is moving backward")
			player.centred = false
		end
	else
		player.movingBackward = false
	end
	
	if love.keyboard.isDown("d") then
		--Dont let the player go off the side of the screen
		if player.x < wWidth*0.4 then
			player.centred = false
			player.x = player.x + player.speed*dt
		else
			player.centred = true
		end
		player.movingForward = true
		print("Player is moving forward")
	else
		player.movingForward = false
	end
	
	if not player.movingBackward and not player.movingForward then
		print("Player is not moving")
	end
		
	--We'll make this more user friendly soon, but just for now
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end