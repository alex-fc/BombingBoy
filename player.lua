function player_load(xx, yy)
	-- Player
	player = {
		x = xx,
		y = yy,
		xspeed = 0;
		yspeed = 0,
		w = 64,
		h = 64,
		xs = 1,
		ys = 1,
		sprite = spr_player_down,
		img_index = 0,
		img_speed = 0.5,
		img_number = 8,
		dead = false,
		shine_timer = 300
	}
end

function player_update()
	-- Execute only if have instances
	if next(player) == nil then return nil end
 
	player.img_speed = 0
	
	-- Drop bomb
	if key_a == 1 and bomb_count > 0 
	and collisionB2B(player, bombs, 0, 0) == nil then
		love.audio.stop(sd_bomb)
		love.audio.play(sd_bomb)
		table.insert(bombs, {
			x = 32 + (math.floor(player.x / 64) * 64),
			y = 16 + (math.floor(player.y / 64) * 64),
			w = 64,
			h = 64,
			sprite = spr_bomb,
			img_index = 0,
			img_speed = 0.5,
			img_number = 3,
			timer = 180,
			create_block = nil
		})
		
		bomb_count = bomb_count - 1
	end
	
	-- Movement
	
	-- Right
	if key_right > 0 and level_clear == false then
		local _col = collisionB2B(player, blocks, 4, 0) 
		
		if _col == nil then
			player.x = player.x + 4
		elseif key_up == 0 and key_down == 0 then
			if player.y + 32 < blocks[_col].y + 32
			and collisionB2B(player, blocks, 0, -4) == nil then
				player.y = player.y - 4
			elseif player.y + 32 > blocks[_col].y + 32
			and collisionB2B(player, blocks, 0, 4) == nil then
				player.y = player.y + 4
			end
		end
		
		player.sprite = spr_player_side
		player.img_speed = 0.5
		player.xs = 1
	-- Left
	elseif key_left > 0 and level_clear == false then
		local _col = collisionB2B(player, blocks, -4, 0) 
		
		if _col == nil then
			player.x = player.x - 4
		elseif key_up == 0 and key_down == 0 then
			if player.y + 32 < blocks[_col].y + 32
			and collisionB2B(player, blocks, 0, -4) == nil then
				player.y = player.y - 4
			elseif player.y + 32 > blocks[_col].y + 32
			and collisionB2B(player, blocks, 0, 4) == nil then
				player.y = player.y + 4
			end
		end
		
		player.sprite = spr_player_side
		player.img_speed = 0.5
		player.xs = -1
	end
	
	-- Up
	if key_up > 0 and level_clear == false then
		local _col = collisionB2B(player, blocks, 0, -4) 
		
		if _col == nil then
			player.y = player.y -4
		elseif key_right == 0 and key_left == 0 then
			if player.x + 32 < blocks[_col].x + 32
			and collisionB2B(player, blocks, -4, 0) == nil then
				player.x = player.x - 4
			elseif player.x + 32 > blocks[_col].x + 32
			and collisionB2B(player, blocks, 4, 0) == nil then
				player.x = player.x + 4
			end
		end
		
		player.sprite = spr_player_up
		player.img_speed = 0.5
	-- Down
	elseif key_down > 0 and level_clear == false then
		local _col = collisionB2B(player, blocks, 0, 4) 
		
		if _col == nil then
			player.y = player.y + 4
		elseif key_right == 0 and key_left == 0 then
			if player.x + 32 < blocks[_col].x + 32
			and collisionB2B(player, blocks, -4, 0) == nil then
				player.x = player.x - 4
			elseif player.x + 32 > blocks[_col].x + 32
			and collisionB2B(player, blocks, 4, 0) == nil then
				player.x = player.x + 4
			end
		end
		
		player.sprite = spr_player_down
		player.img_speed = 0.5
	end
	
	-- Animation
	player.img_index = player.img_index + player.img_speed
	player.img_index = player.img_index % player.img_number
	
	-- Walking sfx
	if player.img_speed ~= 0 and sd_walk:isPlaying() == false then
		love.audio.play(sd_walk)
	end
	
	-- Power Up
	local pw = collisionB2B(player, powers, 0, 0)
	if player.shine_timer == 0 and pw ~= nil then
		if point_distance(player.x + 32, player.y + 32, powers[pw].x + 32, powers[pw].y + 32) < 24 then
			if powers[pw].power_index == 0 then
				bomb_count = bomb_count + 1
			else
				bomb_force = bomb_force + 1
			end
			
			love.audio.play(sd_power)
			table.remove(powers, pw)
		end
	end
	
	-- Portal colliding
	local gt = collisionB2B(player, gates, 0, 0)
	if player.shine_timer == 0 and gt ~= nil and #enemies == 0 and level_clear == false then
		if point_distance(player.x + 32, player.y + 32, gates[gt].x + 32, gates[gt].y + 32) < 16 then
			level_clear = true
			clear_timer = 120
			love.audio.play(sd_win)
		end
	end
	
	-- Killed by flames
	local fl = collisionB2B(player, flames, 0, 0)
	if player.shine_timer == 0 and fl ~= nil then
		if flames[fl].timer > 20 then
			player.dead = true
		end
	end
	
	-- Killed by enemies
	local ini = collisionB2B(player, enemies, 0, 0)
	if player.shine_timer == 0 and ini ~= nil then
		if point_distance(player.x + 32, player.y + 32, enemies[ini].x + 32, enemies[ini].y + 32) < 24 then
			player.dead = true
		end
	end
	
	-- Remove player - Reset the table 
	if player.dead == true then
		lives = lives - 1
		respawn = 180
		if lives > 0 then
			love.audio.play(sd_death)
		else
			love.audio.play(sd_go)
		end
		effect_load(player.x, player.y, fx_death, 10)
		player = {}
	end
 
end
 
function player_draw()
	-- Execute only if have instances
	if next(player) == nil then return nil end
	
	local p_alpha = 1
	if player.shine_timer > 0 then
		player.shine_timer = player.shine_timer - 1
		p_alpha = 0.5 + math.cos(math.deg(love.timer.getTime() * 0.25))
	end
	
	love.graphics.setColor(1, 1, 1, p_alpha)
	local p_quad = love.graphics.newQuad(math.floor(player.img_index) * 64, 0, 64, 96, player.sprite:getDimensions())
	love.graphics.draw(player.sprite, p_quad, player.x + 32, player.y - 32, 0, player.xs, player.ys, 32, 0)
	love.graphics.setColor(1, 1, 1, 1)
end