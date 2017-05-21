local player1 = {
	x = 40,
	y = 100,
	width = 16,
	height = 80,
	speed = 500,
}
local player2 = {
	x = 744,
	y = 100,
	width = 16,
	height = 80,
	speed = 500,
}
local ball = {
	x = 400,
	y = 300,
	radius = 8,
	xVel = 250,
	yVel = 250,
}
function love.update(dt)
	print(ball.x, ball.y)
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
	ball.x = ball.x + ball.xVel*dt
	ball.y = ball.y + ball.yVel*dt
	if (ball.x - ball.radius) < (player1.x + player1.width)
	and (ball.x + ball.radius) > player1.x
	and (ball.y + ball.radius) > player1.y
	and (ball.y - ball.radius) < (player1.y + player1.height) then
		ball.xVel = -ball.xVel
	end
	if (ball.x + ball.radius) > player2.x
	and (ball.x - ball.radius) < (player2.x + player2.width)
	and (ball.y + ball.radius) > player2.y
	and (ball.y - ball.radius) < (player2.y + player2.height) then
		ball.xVel = -ball.xVel
	end
	if ball.y - ball.radius < 0 then
		ball.yVel = -ball.yVel
	elseif ball.y + ball.radius > 600 then
		ball.yVel = -ball.yVel
	end
end
function love.draw()
	love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
	love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
	love.graphics.circle('fill', ball.x, ball.y, ball.radius)
end
