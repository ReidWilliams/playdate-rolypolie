import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics
-- math.randomseed(2018)
playdate.startAccelerometer()

local sensitivity = {2.0, 2.0}

local image = gfx.image.new("images/circle.png")
local sprite = playdate.graphics.sprite.new(image)
sprite:moveTo(100, 100)
sprite:add()

local spriteVelocity = {0, 0}

local sound = playdate.sound.sampleplayer.new("/sounds/beep.wav")

-- Main game loop
function playdate.update()
   updateSprite()
   playdate.graphics.sprite.update()
end

function updateSprite()
   local ax, ay, az = playdate.readAccelerometer()

   local friction = 0.95
   
   spriteVelocity[1] = (spriteVelocity[1] + ax * sensitivity[1]) * friction
   spriteVelocity[2] = (spriteVelocity[2] + ay * sensitivity[2]) * friction
      
   local x = sprite.x + spriteVelocity[1]
   if x > 400 or x < 0 then
      spriteVelocity[1] = -spriteVelocity[1]
      sound:play(1)
   end
   x = clip(x, 0, 400)
    
   local y = sprite.y + spriteVelocity[2]
   if y > 240 or y < 0 then
      spriteVelocity[2] = -spriteVelocity[2]
      sound:play(1)
   end
   y = clip(y, 0, 240)
   
   sprite:moveTo(x, y)
end

function clip(val, min, max)
   if val > max then return max end
   if val < min then return min end
   return val
end

function round(num, decimalPlaces)
   local mult = 10^(decimalPlaces or 1)
   return math.floor(num * mult + 0.5) / mult
end


