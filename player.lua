import "CoreLibs/sprites"
import "CoreLibs/object"

import "ballAnimation"
import "pillAnimation"
import "playerTransitionAnimation"
import "constants"
import "helpers"

local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D

local BALL = 1
local PILL = 2
local TRANSITION = 3

local friction = {
	[BALL] = 0.95,
	[PILL] = 0.75,
	[TRANSITION] = 0.95
}

local sensitivity = {
	[BALL] = 0.5,
	[PILL] = 0.5,
	[TRANSITION] = 0.5
}

local animations = {
	[BALL] = BallAnimation(),
	[PILL] = PillAnimation(),
	[TRANSITION] = PlayerTransitionAnimation()
}

local sound = playdate.sound.sampleplayer.new("/sounds/beep.wav")

class('Player').extends(playdate.graphics.sprite)

function Player:init()
	Player.super.init(self)
	
	self.mode = PILL
	self.nextMode = BALL -- used to track what player should become after transition
	
	self.state = {
		[POSITION] = vector2D.new(0, 0),
		[VELOCITY] = vector2D.new(0.01, 0),
		[ACCELERATION] = vector2D.new(0, 0)
	}
	
	return self
end

function Player:setPosition(x, y)
	self.state[POSITION] = vector2D.new(x, y)
end

function Player:updateInput(x, y, direction)	
	if self.mode == BALL then
		self.state[ACCELERATION] = vector2D.new(x, y)
	else -- PILL or TRANSITION
		if direction == nil then 
			self.state[ACCELERATION] = vector2D.new(0, 0)
		elseif direction == NORTHEAST or direction == EAST or direction == SOUTHEAST then
			self.state[ACCELERATION] = vector2D.new(1, 0)
		elseif direction == NORTHWEST or direction == WEST or direction == SOUTHWEST then
			self.state[ACCELERATION] = vector2D.new(-1, 0)
		elseif direction == NORTH then
			self.state[ACCELERATION] = vector2D.new(0, -1)
		else
			self.state[ACCELERATION] = vector2D.new(0, 1)
		end
	end		
end

function Player:toggleMode()
	if self.mode == BALL then
		self.nextMode = PILL
		self.mode = TRANSITION
		animations[TRANSITION]:startBallToPill()
	end
	
	if self.mode == PILL then
		self.nextMode = BALL
		self.mode = TRANSITION
		animations[TRANSITION]:startPillToBall()
	end
end

function Player:update()
	self.state[VELOCITY] = (self.state[VELOCITY] + (self.state[ACCELERATION] * sensitivity[self.mode])) * friction[self.mode]
	local np = self.state[POSITION] + self.state[VELOCITY]
	
	if np.dx > 400 or np.dx < 0 then
		self.state[VELOCITY].dx = -self.state[VELOCITY].dx
		sound:play(1)
	end
	np.dx = helpers.clip(np.dx, 0, 400)
	
	if np.dy > 240 or np.dy < 0 then
		self.state[VELOCITY].dy = -self.state[VELOCITY].dy
		sound:play(1)
	end
	np.dy = helpers.clip(np.dy, 0, 240)
	
	self.state[POSITION] = np
	 -- new position
	
	if self.mode == TRANSITION then
		self:updateAsTransition()
	end
	
	self:moveTo(self.state[POSITION].dx, self.state[POSITION].dy)
	
	if helpers.nonZero(self.state[VELOCITY]) then
		self:setImage(animations[self.mode]:getImage(self.state))
	end
end

function Player:updateAsTransition()	
	if animations[TRANSITION]:isDone() then
		self.mode = self.nextMode
	end
end


