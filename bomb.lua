function bomb_update()
	-- Execute only if have instances
	if next(bombs) == nil then return nil end
	
	for i, v in ipairs(bombs) do
		if v.sprite ~= nil then
			if collisionRect(player, v.x, v.y, v.x +v.w, v.y + v.h) == false and v.create_block == nil then
				v.create_block = #blocks + 1000000
				table.insert(blocks, {
					id = #blocks + 1000000,
					x = v.x,
					y = v.y,
					w = 64,
					h = 64,
					color = {r = 1, g = 1, b = 1},
					sprite = spr_blocks_exp,
					visible = false
				})
			end
			
			v.img_index = v.img_index + v.img_speed
			v.img_index = v.img_index % v.img_number
			
			if v.timer > 0 then v.timer = v.timer - 1 end
			
			if v.timer == 0 then
				bomb_count = bomb_count + 1
				
				create_explosion(v.x, v.y)
				table.remove(bombs, i)
			end
		end
	end
end

function bomb_draw()
	-- Execute only if have instances
	if next(bombs) == nil then return nil end
	
	for i, v in ipairs(bombs) do
		if v.sprite ~= nil then
			
			love.graphics.setColor(1, 1, 1)
			local b_quad = love.graphics.newQuad(math.floor(v.img_index) * 64, 0, 64, 64, v.sprite:getDimensions())
			local shk = math.cos(math.deg(love.timer.getTime() * 0.25)) * 0.25
			love.graphics.draw(v.sprite, b_quad, v.x + 32, v.y + 32, 0, 0.75 + shk, 0.75 + shk, 32, 32)
		end
    end
end