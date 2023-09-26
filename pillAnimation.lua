import "CoreLibs/sprites"
import "CoreLibs/object"

import "constants"

local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D

-- how many pixels of on screen movement before showing next frame in animation
local imageAnimationOffset = 2

local images = {
	[NORTH] = gfx.imagetable.new("images/pill-north"),
	[EAST] = gfx.imagetable.new("images/pill-east"),
	[SOUTH] = gfx.imagetable.new("images/pill-south"),
	[WEST] = gfx.imagetable.new("images/pill-west"),
}
local nAnimationFrames, _ = images[NORTH]:getSize()

class('PillAnimation').extends()

function PillAnimation:init()
	PillAnimation.super.init(self)
	return self
end

function PillAnimation:getImage(state)
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
	
	-- FIXME FIXME FIXME FIXME FIXME
	animationSet = 1
	
	return images:getImage(animationFrame, animationSet)
end
