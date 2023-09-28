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

local friction = 0.95
local sensitivity = 0.5
-- how many pixels of on screen movement before showing next frame in animation
local imageAnimationOffset = 2

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
		[VELOCITY] = vector2D.new(0, 0),
		[ACCELERATION] = vector2D.new(0, 0)
	}

	return self
end

function Player:setPosition(x, y)
	self.state[POSITION] = vector2D.new(x, y)
end

function Player:setAcceleration(x, y)
	self.state[ACCELERATION] = vector2D.new(x, y)
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
	if self.mode == BALL then 
		self:updateAsBall()
	end
	
	if self.mode == PILL then 
		self:updateAsPill() 
	end
	
	if self.mode == TRANSITION then
		self:updateAsTransition()
	end
	
	self:moveTo(self.state[POSITION].dx, self.state[POSITION].dy)
	self:setImage(animations[self.mode]:getImage(self.state))
end

function Player:updateAsBall()
	self.state[VELOCITY] = (self.state[VELOCITY] + (self.state[ACCELERATION] * sensitivity)) * friction
	local np = self.state[POSITION] + self.state[VELOCITY] -- new position
	  
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
end

function Player:updateAsPill()
	self:updateAsBall()
end

function Player:updateAsTransition()
	self:updateAsBall()
	
	if animations[TRANSITION]:isDone() then
		self.mode = self.nextMode
	end
end


