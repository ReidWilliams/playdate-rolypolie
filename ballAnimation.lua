import "CoreLibs/sprites"
import "CoreLibs/object"

import "constants"
import "helpers"

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
	local direction = helpers.compassDirection(state[VELOCITY].x, state[VELOCITY].y)
	local animationSet, majorPosition = nil
	
	if direction == EAST or direction == WEST then
		animationSet = 1
		majorPosition = state[POSITION].dx
	else
		animationSet = 2
		majorPosition = state[POSITION].dy
	end
	
	local chunks = math.ceil(majorPosition / imageAnimationOffset) - 1
	local animationFrame = (chunks % nAnimationFrames) + 1
	
	return images:getImage(animationFrame, animationSet)
end
