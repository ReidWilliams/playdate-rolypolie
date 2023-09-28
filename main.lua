import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

import "player"
import "constants"

local gfx <const> = playdate.graphics
-- math.randomseed(2018)
playdate.startAccelerometer()

local player = Player()
player:setPosition(100, 100)
player:add()

function playdate.AButtonDown()
    player:toggleMode()
end

-- Main game loop
function playdate.update()
    updateWithDirectionalInputs()
    player:update()
    playdate.timer.updateTimers()
    playdate.graphics.sprite.update()
end

function updateWithDirectionalInputs()
    local ax, ay, az = playdate.readAccelerometer()
    
    local dPadDirection = nil
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            dPadDirection = NORTHEAST
        elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
            dPadDirection = NORTHWEST
        else
            dPadDirection = NORTH
        end
    elseif playdate.buttonIsPressed(playdate.kButtonDown) then
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            dPadDirection = SOUTHEAST
        elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
            dPadDirection = SOUTHWEST
        else
            dPadDirection = SOUTH
        end
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        dPadDirection = EAST
    elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
        dPadDirection = WEST
    end
    
    player:updateInput(ax, ay, dPadDirection)
end


