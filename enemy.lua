function enemy_load(xx, yy)
	-- Enemy
	table.insert(enemies, {
		x = xx,
		y = yy,
		xspeed = 0;
		yspeed = 0,
		w = 64,
		h = 64,
		xs = 1,
		ys = 1,
		sprite = spr_enemy,
		img_index = 0,
		img_speed = 0.5,
		img_number = 6,
		shine_timer = 0,
		change_timer = 1,
		change_direction = 0,
		dead = false,
		speed = 2,
		direction = 0
	})
	
	return #enemies - 1
end

function enemy_update()
	-- Execute only if have instances
	if next(enemies) == nil then return nil end
	
	for idx, enys in ipairs(enemies) do
	
		-- Timer
		if enys.change_timer >= 0 then enys.change_timer = enys.change_timer - 1 end
		
		if enys.change_timer == 0 then
			repeat 
				enys.change_direction =  math.random(0, 3) * 90
			until (enys.change_direction ~= enys.direction 
			and enys.change_direction ~= (enys.direction + 180) % 360)
			
			enys.change_timer = 180
		end
		
		-- Change direction
		if enys.direction ~= enys.change_direction 
		and enys.direction ~= (enys.change_direction + 180) % 360 then
			-- Check if position is free
			local xfree = (math.cos(math.rad(enys.change_direction)) * enys.speed)
			local yfree = -(math.sin(math.rad(enys.change_direction)) * enys.speed)
			if collisionB2B(enys, blocks, xfree, yfree) == nil 
			and collisionB2B(enys, bombs, xfree, yfree) == nil then
				enys.direction = enys.change_direction
			end
		end
		
		-- Velocity
		local xsp = (math.cos(math.rad(enys.direction)) * enys.speed)
		local ysp = -(math.sin(math.rad(enys.direction)) * enys.speed)
	
		-- Bounce
		local bb = collisionB2B(enys, bombs, 0, 0)
		if collisionB2B(enys, blocks, xsp, ysp) ~= nil 
		or (collisionB2B(enys, bombs, xsp, ysp) ~= nil and bb == nil) then
			enys.direction = (enys.direction + 180) % 360
			xsp = (math.cos(math.rad(enys.direction)) * enys.speed)
			ysp = -(math.sin(math.rad(enys.direction)) * enys.speed)
			enys.change_timer = 1
		elseif bb ~= nil then 
			local dd = point_direction(bombs[bb].x, bombs[bb].y, enys.x, enys.y)
			enys.x = enys.x + ((math.cos(math.rad(dd)) * enys.speed) * 2)
			enys.y = enys.y + (-(math.sin(math.rad(dd)) * enys.speed) * 2)
		-- Move
		else
			enys.x = enys.x + xsp
			enys.y = enys.y + ysp
		end
	
		-- Animation
		enys.img_index = enys.img_index + enys.img_speed
		enys.img_index = enys.img_index % enys.img_number
		
		-- Killed by flames
		local fl = collisionB2B(enys, flames, 0, 0)
		if fl ~= nil and enys.shine_timer == 0 then
			if flames[fl].timer > 20 then
				enys.dead = true
			end
		end
		
		-- Destroy - remove from table
		if enys.dead == true then
			score = score + 100
			love.audio.play(sd_enemy)
			effect_load(enys.x, enys.y, fx_death, 10)
			table.remove(enemies, idx)
		end
	end
 
end

function enemy_draw()
	-- Execute only if have instances
	if next(enemies) == nil then return nil end
	
	for idx, enys in ipairs(enemies) do
		local e_alpha = 1
		if enys.shine_timer > 0 then
			enys.shine_timer = enys.shine_timer - 1
			e_alpha = 0.5 + math.cos(math.deg(love.timer.getTime() * 0.25))
		end
		
		love.graphics.setColor(1, 1, 1, e_alpha)
		local e_quad = love.graphics.newQuad(math.floor(enys.img_index) * 64, 0, 64, 96, enys.sprite:getDimensions())
		love.graphics.draw(enys.sprite, e_quad, enys.x + 32, enys.y + 32, 0, enys.xs, enys.ys, 32, 32)
		love.graphics.setColor(1, 1, 1, 1)
		
		--love.graphics.print(enys.direction .. " - " .. enys.change_direction, enys.x, enys.y)
	end 
end