
local Bullets = { img = nil, bullets = {} }

function Bullets:Initialise()
    Bullets.img = love.graphics.newImage('assets/bullet.png')
end

function Bullets:Create()
  newBullet = { x = Player.x  + (Player.img:getWidth() / 2), y = Player.y, img = bulletImage }
  table.insert(Bullets.bullets, newBullet)
end

function Bullets:Draw()
  for i, bullet in ipairs(Bullets.bullets) do
      love.graphics.draw(Bullets.img, bullet.x, bullet.y)
  end
end

return Bullets
