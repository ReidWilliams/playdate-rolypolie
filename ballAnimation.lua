import "CoreLibs/sprites"
import "CoreLibs/object"

import "constants"

local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D

-- how many pixels of on screen movement before showing next frame in animation
local imageAnimationOffset = 2

local images = gfx.imagetable.new("images/ball")
-- in the sprite sheet, each col is an animation frame, each row is a set of animations for
-- a rolling direction, e.g. rolling to the right, rolling down, etc.
-- row 1 is rolling in the x direction, row 2 is rolling in the y direction
local nAnimationFrames, _ = images:getSize()

class('BallAnimation').extends()

function BallAnimation:init()
	BallAnimation.super.init(self)
	return self
end

function BallAnimation:getImage(state)
	-- use horizontal or vertical animation
	local animationSet, position = nil
	
	if math.abs(state[VELOCITY].dx) > math.abs(state[VELOCITY].dy) then
		animationSet = 1
		position = state[POSITION].dx
	else
		animationSet = 2
		position = state[POSITION].dy
	end
	
	local chunks = math.ceil(position / imageAnimationOffset) - 1
	local animationFrame = (chunks % nAnimationFrames) + 1
	
	return images:getImage(animationFrame, animationSet)
end
