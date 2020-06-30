function love.load()
    myImage = love.graphics.newImage("images/sheep.png")
end

function love.update()
    
end

function love.draw()
    love.graphics.draw(myImage, 100, 100)
end