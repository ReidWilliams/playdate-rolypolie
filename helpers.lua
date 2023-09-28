helpers = {}
	
function helpers.clip(val, min, max)
	if val > max then return max end
	if val < min then return min end
	return val
end

-- given x and y components of a vector, return the constant
-- for the direction it mostly points (north, east, etc)
function helpers.compassDirection(x, y)
	if -y > x then
		return NORTH
	elseif x > y then
		return EAST
	elseif y > x then
		return SOUTH
	else
		return WEST
	end
end