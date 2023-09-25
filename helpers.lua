helpers = {}
	
function helpers.clip(val, min, max)
	if val > max then return max end
	if val < min then return min end
	return val
end
