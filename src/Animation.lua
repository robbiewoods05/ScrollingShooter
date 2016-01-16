local Animation = {}

timer=0
frame = 1
frames = 15


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

function Animation:Update(dt)
  timer = timer - dt

  if timer < 0 and frame ~= 15 then
    frame = (frame % frames) + 1
    timer = timer + 0.13
  end


end

function Animation:PlayAnimation(img, x, y)
    love.graphics.draw(img, Animation[frame], x, y)
    if frame == 15 then
      love.graphics.printf("You are dead. Press R to restart.", 147, (love.graphics.getHeight()/2), 500, "center")
    end
end

function Animation.Reset()
  timer = 0
  frame = 1
  frames = 15
end

return Animation
