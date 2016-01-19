local Animation = {}

timer = 0
frame = 1
frames = nil

function Animation:CreateQuads(spriteWidth, spriteHeight, rows, columns, img)
  local index = 1
  Animations = {}
  local xPos = 0
  local yPos = 0

  for _ = 1, rows do
    for __ = 1, columns do
      Animation[index] = love.graphics.newQuad(xPos, yPos, spriteWidth, spriteHeight, img:getWidth(), img:getHeight())
      xPos = xPos + spriteWidth
      index = index + 1
    end
    xPos = 0
    yPos = yPos + spriteHeight
  end
end

function Animation:Update(dt, totalFrames)
  timer = timer - dt
  frames = totalFrames
  if timer < 0 and frame ~= frames then
    frame = (frame % frames) + 1
    timer = timer + 0.13
  end
end

function Animation:PlayAnimation(img, x, y, font)
    love.graphics.draw(img, Animation[frame], x, y)
    if frame == frames then
        love.graphics.setFont(font)
        love.graphics.printf("You are dead. Press R to restart.", 170, (love.graphics.getHeight()/2), 500, "center")
    end
end

function Animation.Reset()
  timer = 0
  frame = 1
end

return Animation
