-- Box to Box collision checking
function collisionB2B(obj1, obj2, xx, yy)
	
	if #obj2 == 0 then return nil end
	
	local c = false
	
	for i, _b in ipairs(obj2) do
		if (obj1.x + obj1.w + xx > _b.x
		and obj1.x + xx < _b.x + _b.w
		and obj1.y + obj1.h + yy > _b.y
		and obj1.y + yy < _b.y + _b.h) then
			c = i
			break
		else
			c = nil
		end
	end
	
	return c
end

-- Rectangle collision checking
function collisionRect(obj1, xx, yy, xx2, yy2)
	
	if next(obj1) == nil then return nil end
	
	return (obj1.x + obj1.w > xx
	and obj1.x < xx2
	and obj1.y + obj1.h > yy
	and obj1.y < yy2)
end

-- Rectangle collision checking - table mode
function collisionRectTable(obj1, xx, yy, xx2, yy2)

	if #obj1 == 0 then return nil end
	
	for i, _inst in ipairs(obj1) do
		local _col = (_inst.x + _inst.w > xx
		and _inst.x < xx2
		and _inst.y + _inst.h > yy
		and _inst.y < yy2)
		
		if _col == true then return i end
	end
	
	return nil
end