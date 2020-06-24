function effect_load(xx, yy, spp, number)

	table.insert(effects, {
		x = xx,
		y = yy,
		sprite = spp,
		img_index = 0,
		img_speed = 0.5,
		img_number = number,
	})

end

function effect_update()
	-- Execute only if have instances
	if next(effects) == nil then return nil end
	
	-- Effects
	for i, v in ipairs(effects) do
		
		if v.sprite ~= nil then
			if v.img_index == v.img_number-1 then
				table.remove(effects, i)
			end
			v.img_index = v.img_index + v.img_speed
			v.img_index = v.img_index % v.img_number
		end
    end
end

function effect_draw()
	-- Execute only if have instances
	if next(effects) == nil then return nil end
	
	for i, v in ipairs(effects) do
		if v.sprite ~= nil then
			
			love.graphics.setColor(1, 1, 1)
			local b_quad = love.graphics.newQuad(math.floor(v.img_index) * 64, 0, 64, 64, v.sprite:getDimensions())
			love.graphics.draw(v.sprite, b_quad, v.x + 32, v.y + 32, 0, 1, 1, 32, 32)
		end
    end
end