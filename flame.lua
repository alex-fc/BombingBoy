function flame_load(xx, yy)

	table.insert(flames, {
		x = xx,
		y = yy,
		w = 32,
		h = 32,
		xs = 1,
		ys = 1,
		sprite = spr_flame,
		img_index = 0,
		img_speed = 0.5,
		img_number = 5,
		timer = 40
	})

end

function flame_update()
	-- Execute only if have instances
	if next(flames) == nil then return nil end
	
	-- Flames
	for i, v in ipairs(flames) do
	
		-- Coliding with blocks
		local bc = collisionB2B(v, blocks, 0, 0) 
		if bc ~= nil then
			if blocks[bc].visible then
				table.remove(flames, i)
			end
			-- Normal block (Explode)
			if blocks[bc].sprite == spr_blocks_exp then
				if blocks[bc].visible then 
					effect_load(blocks[bc].x, blocks[bc].y, fx_block, 8)
				end
				table.remove(blocks, bc)
			end
			
		end
		
		-- Make bombs explode
		local bb = collisionB2B(v, bombs, 0, 0)
		if bb ~= nil then
			bombs[bb].timer = 0
		end
		
		if v.sprite ~= nil then
			v.img_index = v.img_index + v.img_speed
			v.img_index = v.img_index % v.img_number
			
			if v.timer > 0 then v.timer = v.timer - 2 end
			
			if v.timer == 0 then
				table.remove(flames, i)
			end
		end
    end
end

function flame_draw()
	-- Execute only if have instances
	if next(flames) == nil then return nil end
	
	for i, v in ipairs(flames) do
		if v.sprite ~= nil then
			
			love.graphics.setColor(1, 1, 1)
			local b_quad = love.graphics.newQuad(math.floor(v.img_index) * 64, 0, 64, 64, v.sprite:getDimensions())
			love.graphics.draw(v.sprite, b_quad, v.x + 16, v.y + 16, 0, v.timer/40, v.timer/40, 32, 32)
		end
    end
end