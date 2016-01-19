debug = false

Player = require "src/player"
Enemies = require "src/enemies"
Bullets = require "src/bullets"
Animation = require "src/Animation"
Menu = require "src/menu"
Gamestate = require "src/gamestate"
Stars = require "src/stars"

background = nil
backgroundMusic = nil

local explosionAnimation = nil

frame = 1

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
         x2 < x1 + w1 and
         y1 < y2 + h2 and
         y2 < y1 + h1
end

function love.load(arg)
    if arg[2] == "-d" then
        debug = true
    end

    love.audio.setVolume(0.2)
    Gamestate.SetState("menu")

    Player.Initialise()
    Enemies.Initialise()
    Bullets.Initialise()

    hudFont = love.graphics.newFont("assets/font.ttf", 16)
    splashFont = love.graphics.newFont("assets/font.ttf", 32)

    explosionSpritesheet = love.graphics.newImage('assets/explosion.png')
    explosionAnimation = Animation:CreateQuads(96, 96, 3, 5, explosionSpritesheet)

    backgroundMusic = love.audio.newSource('assets/bgmusic.ogg', 'stream')
end

function love.update(dt)
    love.audio.play(backgroundMusic)

    Stars.Update(dt)

    if Gamestate.IsState("menu") then
        if love.keyboard.isDown("return") then
            Gamestate.SetState("game")
        end

  elseif Gamestate.IsState("game") then
    if not Player.isAlive then
        Animation:Update(dt, 15)
      end
    if love.keyboard.isDown('escape') then
      love.event.push('quit')
    end
    if not Player.isAlive and love.keyboard.isDown('r') then
       Player.Initialise()
       Animation.Reset()
       Enemies.Initialise()
   end

   --Movement
   if love.keyboard.isDown('left', 'a') and Player.x > 0 and Player.isAlive then
     Player.Move("left", dt)
 elseif love.keyboard.isDown('right', 'd') and Player.x  < love.graphics.getWidth() - Player.img:getWidth() and Player.isAlive then
     Player.Move("right", dt)
 elseif love.keyboard.isDown('up', 'w') and Player.y > 0 and Player.isAlive then
     Player.Move("up", dt)
 elseif love.keyboard.isDown('down', 's') and Player.y < love.graphics.getHeight() - Player.img:getHeight() and Player.isAlive then
     Player.Move("down", dt)
   end

   Player.canShootTimer = Player.canShootTimer - (1 * dt)
   if Player.canShootTimer < 0 then
     Player.canShoot = true
   end

   --Shooting
   if love.keyboard.isDown('space', 'lctrl', 'rctrl') and Player.canShoot and Player.isAlive then
     love.audio.play(Player.shootSound)
     Bullets.Create()
     Player.canShoot = false
     Player.canShootTimer = Player.canShootTimerMax
   end

   Player.Fire(dt)

   Enemies.Create(dt)
   Enemies.Move(dt)

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
           Player.Die()
           for i, enemy in ipairs(Enemies.enemies) do
             for j, bullet in ipairs(Bullets.bullets) do
                 table.remove(Bullets.bullets, j)
                 table.remove(Enemies.enemies, i)
             end
         end
       end
     end
   end
 end
end

function love.draw(dt)
    Stars.Draw()

    if Gamestate.IsState("menu") then
      Menu.Draw(splashFont)

    elseif Gamestate.IsState("game") then
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(hudFont)

     if Player.isAlive then
        Player.Draw()
        Bullets.Draw()
        Enemies.Draw()
        if debug then
            Menu.DrawDebugPanel()
        end
        love.graphics.print("score: " .. Player.score)
        love.graphics.print("health: ", love.graphics.getWidth() - 300, 0)
        Menu.DrawHealthBar(Player.health)
    else
        Animation:PlayAnimation(explosionSpritesheet, Player.x, Player.y, splashFont)
    end
  end
end
