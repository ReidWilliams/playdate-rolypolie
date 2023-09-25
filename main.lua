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
    updateWithAccelerometer()
    player:update()
    playdate.timer.updateTimers()
    playdate.graphics.sprite.update()
end

function updateWithAccelerometer()
    local ax, ay, az = playdate.readAccelerometer()
    player:setAcceleration(ax, ay)
end


