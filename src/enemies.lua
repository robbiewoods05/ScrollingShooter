local Enemies = { img = nil, enemies = {}, createEnemyTimerMax = 0.9, createEnemyTimer = 0, deathSound = nil }

function Enemies:Initialise()
  Enemies.createEnemyTimerMax = 0.9
  Enemies.createEnemyTimer = Enemies.createEnemyTimerMax
  Enemies.img = love.graphics.newImage('assets/enemy.png')
  Enemies.deathSound = love.audio.newSource('assets/explosion.wav', 'stream')
end

function Enemies:Create(dt)
  Enemies.createEnemyTimer = Enemies.createEnemyTimer - (1 * dt)

  if Enemies.createEnemyTimer < 0 then
    Enemies.createEnemyTimer = Enemies.createEnemyTimerMax

    local randomNumber = love.math.random(10, love.graphics.getWidth() - 10)
    if randomNumber > 0 and randomNumber < love.graphics.getWidth() - Player.img:getWidth() then
      newEnemy = { x = randomNumber, y = -10, img = Enemies.img }
      table.insert(Enemies.enemies, newEnemy)
    end
  end
end

function Enemies:Move(dt)
  for i, enemy in ipairs(Enemies.enemies) do
    enemy.y = enemy.y + (140 * dt)

    if enemy.y > 650 then
      table.remove(Enemies.enemies, i)
    end
  end
end

function Enemies:Draw()
  for i, enemy in ipairs(Enemies.enemies) do
      love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end
end

function Enemies:Die()
  local x = i.x
  local y = i.y
  table.remove(Bullets.bullets, j)
  table.remove(Enemies.enemies, i)

  Animation:PlayAnimation(explosionSpritesheet, x, y)

  love.audio.play(Enemies.deathSound)
end

return Enemies
