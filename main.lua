import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

import "ball"

local gfx <const> = playdate.graphics
-- math.randomseed(2018)
playdate.startAccelerometer()

local ball = PlayerBall()
ball:setPosition(100, 100)
ball:add()

-- Main game loop
function playdate.update()
    updateWithAccelerometer()
    ball:update()
    playdate.graphics.sprite.update()
end

function updateWithAccelerometer()
    local ax, ay, az = playdate.readAccelerometer()
    ball:setAcceleration(ax, ay)
end


