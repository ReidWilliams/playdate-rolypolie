import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/timer"

import "constants"

local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D

local animationLength = 300

local images = gfx.imagetable.new("images/player-transition")
-- in the sprite sheet, each col is an animation frame, each row is a set of animations for
-- a rolling direction, e.g. rolling to the right, rolling down, etc.
-- row 1 is rolling in the x direction, row 2 is rolling in the y direction
local nAnimationFrames, _ = images:getSize()

class('PlayerTransitionAnimation').extends()

function PlayerTransitionAnimation:init()
	PlayerTransitionAnimation.super.init(self)
	return self
end

function PlayerTransitionAnimation:startPillToBall()
	self.timer = playdate.timer.new(animationLength, 1, nAnimationFrames)
end

function PlayerTransitionAnimation:startBallToPill()
	self.timer = playdate.timer.new(animationLength, nAnimationFrames, 1)
end

function PlayerTransitionAnimation:isDone()
	return self.timer.timeLeft == 0
end
	
function PlayerTransitionAnimation:getImage(state)
	local i = math.ceil(self.timer.value)
	return images:getImage(i)
end
