debug = true
isAlive = true

score = 0

lives = 3

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

createEnemyTimerMax = 0.9
createEnemyTimer = createEnemyTimerMax

enemyImage = nil
enemies = {}

bulletImage = nil
bullets = {}

player = { x = 100, y = 100, speed = 500, img = nil, damage = 5}
focus = true

background = nil

laserSound = nil
explosionSound = nil
backgroundMusic = nil

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function Restart()
    score = 0
    enemies = {}
    bullets = {}
    lives = 3
    player.x = 100
    player.y = 100
    isAlive = true
end

function love.load(arg)
  player.img = love.graphics.newImage('assets/ship.png')
  bulletImage = love.graphics.newImage('assets/bullet.png')
  enemyImage = love.graphics.newImage('assets/enemy.png')
  background = love.graphics.newImage('assets/stars.png')
  laserSound = love.audio.newSource('assets/laser.wav', 'stream')
  explosionSound = love.audio.newSource('assets/explosion.wav', 'stream')
  backgroundMusic = love.audio.newSource('assets/bgmusic.ogg', 'stream')
end

function love.update(dt)
    love.audio.play(backgroundMusic)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if not isAlive and love.keyboard.isDown('r') then
      Restart();
  end

  --Movement
  if love.keyboard.isDown('left', 'a') and player.x > 0 then
    player.x = player.x - (player.speed * dt)
  elseif love.keyboard.isDown('right', 'd') and player.x  < love.graphics.getWidth() - player.img:getWidth() then
    player.x = player.x + (player.speed * dt)
  elseif love.keyboard.isDown('up', 'w') and player.y > 0 then
    player.y = player.y - (player.speed * dt)
  elseif love.keyboard.isDown('down', 's') and player.y < love.graphics.getHeight() - player.img:getHeight() then
    player.y = player.y + (player.speed * dt)
  end

  canShootTimer = canShootTimer - (1 * dt)
  if canShootTimer < 0 then
    canShoot = true
  end

  --Shooting
  if love.keyboard.isDown('space', 'lctrl', 'rctrl') and canShoot and isAlive then
    love.audio.play(laserSound)
    newBullet = { x = player.x  + (player.img:getWidth() / 2), y = player.y, img = bulletImage }
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

  createEnemyTimer = createEnemyTimer - (1 * dt)

  if createEnemyTimer < 0 then
    createEnemyTimer = createEnemyTimerMax

    randomNumber = love.math.random(10, love.graphics.getWidth() - 10)
    newEnemy = { x = randomNumber, y = -10, img = enemyImage }
    table.insert(enemies, newEnemy)
  end

  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (140 * dt)

    if enemy.y > 650 then
      table.remove(enemies, i)
    end
  end

  for i, enemy in ipairs(enemies) do
    for j, bullet in ipairs(bullets) do
      if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
        table.remove(bullets, j)
        table.remove(enemies, i)
        love.audio.play(explosionSound)
        score = score + 10
      end
    end

    if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
      table.remove(enemies, i)
      lives = lives - 1
      if lives == 0 then
          love.audio.play(explosionSound)
          isAlive = false
      end
    end
  end

function love.draw()
    love.graphics.draw(background, 0, 0)
    if isAlive then
        love.graphics.print("Score: " .. score)
        love.graphics.print("Lives remaining: " .. lives, love.graphics.getWidth() - 120, 0)

        love.graphics.draw(player.img, player.x, player.y)

        for i, bullet in ipairs(bullets) do
            love.graphics.draw(bullet.img, bullet.x, bullet.y)
        end

        for i, enemy in ipairs(enemies) do
            love.graphics.draw(enemy.img, enemy.x, enemy.y)
        end
    else
        love.graphics.printf("You are dead. Press R to restart.", 170, (love.graphics.getHeight()/2), 500, "center")
    end
end
end
