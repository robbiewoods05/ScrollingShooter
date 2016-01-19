local Menu = {}

function Menu.Draw(font)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font)
    love.graphics.print("star shooter", love.graphics.getWidth()/2 - 170, 20)
    love.graphics.print("press enter to start", love.graphics.getWidth()/2 - 270, (love.graphics.getHeight()/2))

end

function Menu.DrawHealthBar(health)
    if health > 51 then
        love.graphics.setColor(0, 255, 0)
    elseif health > 25 and health <= 50 then
        love.graphics.setColor(245, 255, 133)
    elseif health < 25 then
        love.graphics.setColor(255, 0, 0)
    end
    love.graphics.rectangle("fill", love.graphics.getWidth() - 202, 2, health * 2, 15)
    love.graphics.setColor(255, 255, 255)
end

function Menu.DrawDebugPanel()
    --Debug
    love.graphics.print("fps: " .. love.timer.getFPS(), 0, 400)
    love.graphics.print("delta time: " .. string.format("%4.3f", love.timer.getDelta()), 0 , 412)
    love.graphics.print("enemies: " .. #Enemies.enemies, 0, 427)
    love.graphics.print("up: " ..  tostring(love.keyboard.isDown("w", "up")), 0, 442)
    love.graphics.print("down: " .. tostring(love.keyboard.isDown("s", "down")), 0, 457)
    love.graphics.print("left: " .. tostring(love.keyboard.isDown("a", "left")), 0, 472)
    love.graphics.print("right: " .. tostring(love.keyboard.isDown("d", "right")), 0, 487)
end

return Menu
