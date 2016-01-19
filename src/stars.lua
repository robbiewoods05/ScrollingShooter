local Stars = {}

local frontStars = { radius = 2, speed = 100 }
local backStars = { radius = 1, speed = 50 }

local createStarTimer = 500

function Stars.Update(dt)
    createStarTimer = createStarTimer - (1 * dt)

    if createStarTimer < 0 then
        createStarTimer = 500
    end

    local rand = love.math.random(3, love.graphics.getWidth() - 3)
    local rand2 = love.math.random(3, love.graphics.getWidth() - 3)

    if rand > 0 then
        newStar = { x = rand, y = -10 }
        table.insert(frontStars, newStar)
    end

    if rand2 > 0 then
        newStar = { x = rand2, y = -10 }
        table.insert(backStars, newStar)
    end

    for i, star in ipairs(frontStars) do
        star.y = star.y + (frontStars.speed * dt)

        if star.y > 650 then
            table.remove(frontStars, i)
        end
    end

    for i, star in ipairs(backStars) do
        star.y = star.y + (backStars.speed * dt)

        if star.y > 650 then
            table.remove(backStars, i)
        end
    end
end

function Stars.Draw()
    love.graphics.setColor(236, 240, 192)
    for i, star in ipairs(frontStars) do
        love.graphics.circle("fill", star.x, star.y, frontStars.radius, 100)
    end
    for i, stars in ipairs(backStars) do
        love.graphics.circle("fill", stars.x, stars.y, backStars.radius, 100)
    end
    love.graphics.setColor(255, 255, 255)
end

return Stars
