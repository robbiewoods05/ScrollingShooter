local Animation = {}

function Animation:CreateQuads(spriteWidth, spriteHeight, rows, columns, img)
  local frame = 1
  local Animation = {}
  local xPos = 0
  local yPos = 0

  for _ = 1, rows do
    for __ = 1, columns do
      Animation[frame] = love.graphics.newQuad(xPos, yPos, spriteWidth, spriteHeight, img:getWidth(), img:getHeight())
      xPos = xPos + spriteWidth
      frame = frame + 1
    end
    xPos = 0
    yPos = yPos + spriteHeight
  end

  return Animation
end

function Animation:PlayAnimation(animationArray, x, y, img)
  for frame = 1, #animationArray do
    love.graphics.draw(img, animationArray[frame], x, y)
  end
end

return Animation
