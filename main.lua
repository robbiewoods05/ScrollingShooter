debug = true

Player = require "src/player"
Enemies = require "src/enemies"
Bullets = require "src/bullets"
Animation = require "src/Animation"


background = nil
backgroundMusic = nil

local explosionAnimation = nil

frame = 1

gamestate = "menu"

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
         x2 < x1 + w1 and
         y1 < y2 + h2 and
         y2 < y1 + h1
end

function love.load(arg)
  Player:Initialise()
  Enemies:Initialise()
  Bullets:Initialise()

  explosionSpritesheet = love.graphics.newImage('assets/explosion.png')
  background = love.graphics.newImage('assets/stars.png')
  backgroundMusic = love.audio.newSource('assets/bgmusic.ogg', 'stream')

  explosionAnimation = Animation:CreateQuads(96, 96, 3, 5, explosionSpritesheet)

end

function love.update(dt)
    love.audio.play(backgroundMusic)

    if gamestate == "menu" then
      if love.keyboard.isDown("return") then
        gamestate ="game"
      end

  elseif gamestate == "game" then
      if not Player.isAlive then
        Animation:Update(dt)
      end
    if love.keyboard.isDown('escape') then
      love.event.push('quit')
    end

    if not isAlive and love.keyboard.isDown('r') then
       Player:Initialise()
       Animation.Reset()
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

   if love.keyboard.isDown('e') then
     Player.isAlive = false
   end

   Player.canShootTimer = Player.canShootTimer - (1 * dt)
   if Player.canShootTimer < 0 then
     Player.canShoot = true
   end

   --Shooting
   if love.keyboard.isDown('space', 'lctrl', 'rctrl') and Player.canShoot and Player.isAlive then
     love.audio.play(Player.shootSound)
     Bullets:Create()
     Player.canShoot = false
     Player.canShootTimer = Player.canShootTimerMax
   end

   Player:Fire(dt)

   Enemies:Create(dt)
   Enemies:Move(dt)

   -- Check for collision between enemy and bullet
   for i, enemy in ipairs(Enemies.enemies) do
     for j, bullet in ipairs(Bullets.bullets) do
       if CheckCollision(enemy.x, enemy.y, Enemies.img:getWidth(), Enemies.img:getHeight(), bullet.x, bullet.y, Bullets.img:getWidth(), Bullets.img:getHeight()) then
         table.remove(Bullets.bullets, j)
         table.remove(Enemies.enemies, i)
         love.audio.play(Enemies.deathSound)
         Player.score = Player.score + 10
       end
     end

     -- Check for collision between enemy and player
     if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), Player.x, Player.y, Player.img:getWidth(), Player.img:getHeight()) and Player.isAlive then
       table.remove(Enemies.enemies, i)
       Player.health = Player.health - 10
       love.audio.play(Enemies.deathSound)
       if Player.health == 0 then
           Player:Die()
       end
     end
   end
 end
end

function love.draw(dt)
    love.graphics.draw(background, 0, 0)

    if gamestate == "menu" then
      love.graphics.print("Star Shooter", love.graphics.getWidth()/2 - 30, 20)

      love.graphics.print("Press enter to start...", x, y, r, sx, sy, ox, oy, kx, ky)

    elseif gamestate == "game" then
     if Player.isAlive then
        love.graphics.print("Score: " .. Player.score)
        love.graphics.print("Health remaining: " .. Player.health, love.graphics.getWidth() - 140, 0)

        --Debug
        if Animation.frame ~= nil then
          love.graphics.print("Frame: " .. Animation.frame, 0, 387)
        end
        love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 400)
        love.graphics.print("Delta Time: " .. string.format("%4.3f", love.timer.getDelta()), 0 , 412)
        love.graphics.print("Enemies: " .. #Enemies.enemies, 0, 427)
        love.graphics.print("Up: " ..  tostring(love.keyboard.isDown("w", "up")), 0, 442)
        love.graphics.print("Down: " .. tostring(love.keyboard.isDown("s", "down")), 0, 457)
        love.graphics.print("Left: " .. tostring(love.keyboard.isDown("a", "left")), 0, 472)
        love.graphics.print("Right: " .. tostring(love.keyboard.isDown("d", "right")), 0, 487)


        love.graphics.draw(Player.img, Player.x, Player.y)

        Bullets:Draw()

        Enemies:Draw()

    else
        Animation:PlayAnimation(explosionSpritesheet, Player.x, Player.y)
    end
  end
end
