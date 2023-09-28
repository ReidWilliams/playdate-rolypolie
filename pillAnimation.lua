import "CoreLibs/sprites"
import "CoreLibs/object"

import "constants"
import "helpers"

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
	printTable(state[VELOCITY])
	local direction = helpers.compassDirection(state[VELOCITY].x, state[VELOCITY].y)
	-- use horizontal or vertical animation
	local majorPosition = nil
	
	if direction == EAST or direction == WEST then
		majorPosition = state[POSITION].dx
	else
		majorPosition = state[POSITION].dy
	end
	
	local chunks = math.ceil(majorPosition / imageAnimationOffset) - 1
	local animationFrame = (chunks % nAnimationFrames) + 1
		
	return images[direction]:getImage(animationFrame)
end
