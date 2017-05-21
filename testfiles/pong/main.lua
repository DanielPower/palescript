local player1 = {
	x = 40,
	y = 100,
	width = 16,
	height = 80,
	speed = 450,
}
local player2 = {
	x = 744,
	y = 100,
	width = 16,
	height = 80,
	speed = 450,
}
local ball = {
	x = 396,
	y = 296,
	width = 8,
	height = 8,
	xVel = 600,
	yVel = 600,
}
local players = {player1, player2}
function love.update(dt)
	
	if love.keyboard.isDown('w') then
		player1.y = player1.y - player1.speed*dt
	elseif love.keyboard.isDown('s') then
		player1.y = player1.y + player1.speed*dt
	end
	
	if love.keyboard.isDown('up') then
		player2.y = player2.y - player2.speed*dt
	elseif love.keyboard.isDown('down') then
		player2.y = player2.y + player2.speed*dt
	end
	
	ball.x = ball.x + ball.xVel
	ball.y = ball.y + ball.yVel
	for _, player in ipairs(players) do
		if (ball.x + ball.width) > player.x
		and ball.x < (player.x + player.width) then
			ball.xVel = -ball.xVel
		end
		if (ball.y + ball.height) > player.y
		and ball.y < (player.y + player.width) then
			ball.yVel = -ball.yVel
		end
	end
end
function love.draw()
	love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
	love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
end
