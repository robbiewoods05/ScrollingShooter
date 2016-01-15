debug = true

Player = require "player"
Enemies = require "enemies"

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImage = nil
bullets = {}

background = nil

explosionSound = nil
backgroundMusic = nil

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
         x2 < x1 + w1 and
         y1 < y2 + h2 and
         y2 < y1 + h1
end


function love.load(arg)
  Player:Initialise()
  Enemies:Initialise()

  bulletImage = love.graphics.newImage('assets/bullet.png')
  background = love.graphics.newImage('assets/stars.png')

  backgroundMusic = love.audio.newSource('assets/bgmusic.ogg', 'stream')
end

function love.update(dt)
    love.audio.play(backgroundMusic)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if not isAlive and love.keyboard.isDown('r') then
      Player:Initialise()
  end

  --Movement
  if love.keyboard.isDown('left', 'a') and Player.x > 0 then
    Player:Move("left", dt)
  elseif love.keyboard.isDown('right', 'd') and Player.x  < love.graphics.getWidth() - Player.img:getWidth() then
    Player:Move("right", dt)
  elseif love.keyboard.isDown('up', 'w') and Player.y > 0 then
    Player:Move("up", dt)
  elseif love.keyboard.isDown('down', 's') and Player.y < love.graphics.getHeight() - Player.img:getHeight() then
    Player:Move("down", dt)
  end

  canShootTimer = canShootTimer - (1 * dt)
  if canShootTimer < 0 then
    canShoot = true
  end

  --Shooting
  if love.keyboard.isDown('space', 'lctrl', 'rctrl') and canShoot and Player.isAlive then
    love.audio.play(Player.shootSound)
    newBullet = { x = Player.x  + (Player.img:getWidth() / 2), y = Player.y, img = bulletImage }
    table.insert(bullets, newBullet)
    canShoot = false
    canShootTimer = canShootTimerMax
  end

  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)

    if bullet.y < 0 then
      table.remove(bullets, i)
    end
  end

  Enemies:Create(dt)


  -- Check for collision between enemy and bullet
  for i, enemy in ipairs(Enemies.enemies) do
    for j, bullet in ipairs(bullets) do
      if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
        table.remove(bullets, j)
        table.remove(Enemies.enemies, i)
        love.audio.play(Enemies.deathSound)
        Player.score = Player.score + 10
      end
    end

    if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), Player.x, Player.y, Player.img:getWidth(), Player.img:getHeight()) and Player.isAlive then
      table.remove(Enemies.enemies, i)
      Player.health = Player.health - 10
      love.audio.play(Enemies.deathSound)
      if Player.health == 0 then
          Player.isAlive = false
      end
    end
  end

function love.draw()
    love.graphics.draw(background, 0, 0)
    if Player.isAlive then
        love.graphics.print("Score: " .. Player.score)
        love.graphics.print("Health remaining: " .. Player.health, love.graphics.getWidth() - 120, 0)

        --Debug
        love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 400)
        love.graphics.print("Delta Time: " .. string.format("%4.3f", love.timer.getDelta()), 0 , 412)
        love.graphics.print("Enemies: " .. #enemies, 0, 427)
        love.graphics.print("Up: " ..  tostring(love.keyboard.isDown("w", "up")), 0, 442)
        love.graphics.print("Down: " .. tostring(love.keyboard.isDown("s", "down")), 0, 457)
        love.graphics.print("Left: " .. tostring(love.keyboard.isDown("a", "left")), 0, 472)
        love.graphics.print("Right: " .. tostring(love.keyboard.isDown("d", "right")), 0, 487)

        love.graphics.draw(Player.img, Player.x, Player.y)

        for i, bullet in ipairs(bullets) do
            love.graphics.draw(bullet.img, bullet.x, bullet.y)
        end

        Enemies:Draw()

    else
        love.graphics.printf("You are dead. Press R to restart.", 170, (love.graphics.getHeight()/2), 500, "center")
    end
end
end
