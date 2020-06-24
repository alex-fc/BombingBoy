function power_load(xx, yy, pid)

	table.insert(powers, {
		id = #powers + 1000000,
		x = xx,
		y = yy,
		w = 64,
		h = 64,
		color = {r = 1, g = 1, b = 1},
		sprite = spr_powers,
		visible = false,
		power_index = pid or 0,
		delay = 60
	})

end

function power_update()
	-- Execute only if have instances
	if next(powers) == nil then return nil end

	for i, v in ipairs(powers) do
		if collisionB2B(v, flames, 0, 0) ~= nil and v.delay == 0 then
			table.remove(powers, i)
		end
		
		-- Turn it visible if not colliding with blocks
		if collisionB2B(v, blocks, 0, 0) == nil then
			v.visible = true
		end
		
		if v.delay > 0 and v.visible == true then v.delay = v.delay - 1 end
    end
end

function power_draw()
	-- Execute only if have instances
	if next(powers) == nil then return nil end

	for i, v in ipairs(powers) do
		if v.sprite ~= nil and v.visible then

			love.graphics.setColor(v.color.r, v.color.g, v.color.b)
			local p_quad = love.graphics.newQuad(math.floor(v.power_index) * 64, 0, 64, 64, v.sprite:getDimensions())
			love.graphics.draw(v.sprite, p_quad, v.x, v.y, 0, 1, 1, 0, 0)
		end
    end
end