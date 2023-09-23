import "CoreLibs/sprites"
import "CoreLibs/object"

local helpers = import("helpers")
local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D

local friction = 0.95
local sensitivity = 0.5

-- how many pixels of on screen movement before showing next frame in animation
local imageAnimationOffset = 2

local sound = playdate.sound.sampleplayer.new("/sounds/beep.wav")
local images = gfx.imagetable.new("images/ball")
-- in the sprite sheet, each col is an animation frame, each row is a set of animations for
-- a rolling direction, e.g. rolling to the right, rolling down, etc.
-- row 1 is rolling in the x direction, row 2 is rolling in the y direction
local nAnimationFrames, _ = images:getSize()

class('PlayerBall').extends(playdate.graphics.sprite)

function PlayerBall:init()
	PlayerBall.super.init(self)
	
	self:setImage(images:getImage(1))
	
	self.position = vector2D.new(0, 0)
	self.velocity = vector2D.new(0, 0)
	self.acceleration = vector2D.new(0, 0)

	return self
end

function PlayerBall:setPosition(x, y)
	self.position = vector2D.new(x, y)
end

function PlayerBall:setAcceleration(x, y)
	self.acceleration = vector2D.new(x, y)
end

function PlayerBall:update()
	self.velocity = (self.velocity + (self.acceleration * sensitivity)) * friction
	local np = self.position + self.velocity -- new position
	  
	if np.dx > 400 or np.dx < 0 then
		self.velocity.dx = -self.velocity.dx
		sound:play(1)
	end
	np.dx = helpers.clip(np.dx, 0, 400)
	
	if np.dy > 240 or np.dy < 0 then
		self.velocity.dy = -self.velocity.dy
		sound:play(1)
	end
	np.dy = helpers.clip(np.dy, 0, 240)
	
	self.position = np
	self:moveTo(self.position.dx, self.position.dy)
	self:updateImage()
end

function PlayerBall:updateImage()
	-- use horizontal or vertical animation
	local animationSet, position = nil
	
	if math.abs(self.velocity.dx) > math.abs(self.velocity.dy) then
		animationSet = 1
		position = self.position.dx
	else
		animationSet = 2
		position = self.position.dy
	end
	
	local chunks = math.ceil(position / imageAnimationOffset) - 1
	local animationFrame = (chunks % nAnimationFrames) + 1
	
	self:setImage(images:getImage(animationFrame, animationSet))
end
