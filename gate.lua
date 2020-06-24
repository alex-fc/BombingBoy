function gate_load(xx, yy, pid)

	table.insert(gates, {
		id = #gates + 1000000,
		x = xx,
		y = yy,
		w = 64,
		h = 64,
		color = {r = 1, g = 1, b = 1},
		sprite = spr_portal,
		visible = false,
		spawn_timer = 60
	})

end

function gate_update()
	-- Execute only if have instances
	if next(gates) == nil then return nil end

	for i, v in ipairs(gates) do
	
		-- Generate enemies when colides with flames
		local ff = collisionB2B(v, flames, 0, 0) 
		if ff  ~= nil and v.spawn_timer == 0 then
			table.remove(flames, ff)
			local ee = enemy_load(v.x, v.y)
			enemies[ee+1].shine_timer = 120
			v.spawn_timer = 60
		end
		
		-- Turn it visible
		if collisionB2B(v, blocks, 0, 0) == nil then
			v.visible = true
		end
		
		-- Timer
		if v.spawn_timer > 0 and v.visible == true then v.spawn_timer = v.spawn_timer - 1 end
    end
end

function gate_draw()
	-- Execute only if have instances
	if next(gates) == nil then return nil end

	for i, v in ipairs(gates) do
		if v.sprite ~= nil and v.visible then
			local g_quad = love.graphics.newQuad(0, 0, 64, 64, v.sprite:getDimensions())
			love.graphics.setColor(v.color.r, v.color.g, v.color.b)
			
			local rot = (love.timer.getTime() * 8) % 360
			love.graphics.draw(v.sprite, g_quad, v.x + 32, v.y + 32, -rot, 1, 1, 32, 32)
		end
    end
end