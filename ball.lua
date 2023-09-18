import "CoreLibs/sprites"
import "CoreLibs/object"

local helpers = import("helpers")
local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D

local friction = 0.95
local sensitivity = 0.5

-- how many pixels of on screen movement before showing next frame
-- in animation
local imageAnimationOffset = 5

local sound = playdate.sound.sampleplayer.new("/sounds/beep.wav")
local images = {
	gfx.image.new("images/ball1.png"),
	gfx.image.new("images/ball2.png"),
	gfx.image.new("images/ball3.png")
}

class('PlayerBall').extends(playdate.graphics.sprite)

function PlayerBall:init()
	PlayerBall.super.init(self)
	
	self:setImage(images[1])
	
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
	local chunks = math.ceil(self.position.dx / imageAnimationOffset) - 1
	local offset = (chunks % #images) + 1
	
	print("chunks: " .. chunks)
	print("offset: " .. offset)
	
	self:setImage(images[offset])
end
