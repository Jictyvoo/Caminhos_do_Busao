local LetterboardTimer = {}

LetterboardTimer.__index = LetterboardTimer
local sprite = love.graphics.newImage("assets/sprites/misc/letterboard_timer.png")
function LetterboardTimer:draw(timer)
    love.graphics.setFont(gameDirector:getFonts().letterboard)
    love.graphics.draw(sprite, 604, 0, 0)
    love.graphics.print(string.format("%d", timer), 684, 20, 0)
    love.graphics.setFont(gameDirector:getFonts().default)
end

return LetterboardTimer
