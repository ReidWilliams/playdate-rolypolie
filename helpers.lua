helpers = {}
	
function helpers.clip(val, min, max)
	if val > max then return max end
	if val < min then return min end
	return val
end

-- given x and y components of a vector, return the constant
-- for the direction it mostly points (north, east, etc)
function helpers.compassDirection(x, y)
	if math.abs(x) > math.abs(y) then
		if x > 0 then return EAST else return WEST end
	else
		if y > 0 then return SOUTH else return NORTH end
	end
end

function helpers.nonZero(v)
	return v.dx ~= 0 or v.dy ~= 0
end