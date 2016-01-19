

local Player = { score = 0, health = 0, x = 0,
           y = 0, speed = 0,  img = nil, shootSound = nil, deathSound = nil, isAlive = true, canShoot = true, canShootTimerMax = 0.2,
           canShootTimer = 0.2 }

 function Player.Initialise()
  Player.score = 0
  Player.health = 100
  Player.x = 100
  Player.y = 100
  Player.speed = 500
  Player.isAlive = true

  if Player.img == nil then
    Player.img = love.graphics.newImage('assets/ship.png')
  end
  if Player.shootSound == nil then
    Player.shootSound = love.audio.newSource('assets/laser.wav', 'stream')
  end
  if Player.deathSound == nil then
    Player.deathSound = love.audio.newSource('assets/explosion.wav', 'stream')
  end
end

function Player.Move(direction, dt)
  if direction == "up" then
    Player.y = Player.y - (Player.speed * dt)
  elseif direction == "down" then
    Player.y = Player.y + (Player.speed * dt)
  elseif direction == "left" then
    Player.x = Player.x - (Player.speed * dt)
  elseif direction == "right" then
    Player.x = Player.x + (Player.speed * dt)
  end
end

function Player.Fire(dt)
  for i, bullet in ipairs(Bullets.bullets) do
    bullet.y = bullet.y - (250 * dt)

    if bullet.y < 0 then
      table.remove(Bullets.bullets, i)
    end
  end
end

function Player.Die()
  love.audio.play(Player.deathSound)
  Player.isAlive = false
end

function Player.Draw()
    love.graphics.draw(Player.img, Player.x, Player.y)
end

return Player
