-- Bombing Boy - v.0.8
-- Last Update: 16/06/2020

-- Programming and SFX by Alex FC (@ALEX_FC3)
-- Sprites: https://bit.ly/2YL8kbv
-- Music: https://freemusicarchive.org/music/A_Smile_for_Timbuctu

require('load_resources')
require('game_stuff')
require('collisions')

require('player')
require('enemy')
require('block')
require('bomb')
require('flame')
require('power')
require('gate')
require('effect')

function love.load()
	-- Randomize
	math.randomseed(os.clock()*100000000)

	-- Window Setup
	love.window.setMode(1280, 720, {resizable=false, vsync=true, minwidth=1280, minheight=720})
	love.window.setTitle("Bombing Boy - v.0.8")
	
	-- Load resources (Sprites, Backgrounds, sfx and musics)
	load_resources()
	
	-- Globals initialize
	global_init()
	
	-- Fade In-Out
	fade_alpha = 1						-- Opacicity
	fade_color = {r = 0, g = 0, b = 0}	-- Color
	fade_speed = 0.05					-- Fade Speed
	fade_index = -4						-- Scene Index
	
	-- Keyboard
	key_left = 0
	key_right = 0
	key_up = 0
	key_down = 0
	key_a = 0
	
	-- Joystick
	joysticks = love.joystick.getJoysticks()
	
	-- Initialize or reset tables 
	reset_tables()	
end

function love.update()
	-- check keyboard and joystick 
	check_keys_and_buttons()

	-- MENU
	if scene_index == 0 then
		if key_a == 1 and fade_alpha == 0 then
			-- Go to level scene
			fade_index = 1
			
			-- generate_level(% block quantity, % enemy quantity, power up quantity)
			generate_level(0.45, 0.05, 3)
			
			-- Sfx
			love.audio.play(sd_power)
		end
	-- LEVEL
	elseif scene_index == 1 then
		-- Main Game Timer
		if timer > 0.01 and next(player) ~= nil then
			timer = timer - 0.01 
		end
		
		-- Times's Out
		if timer <= 0 then 
			lives = 0
			player.dead = true
		end
		
		-- Respawn
		if respawn >= 0 then respawn = respawn - 1 end
		if respawn == 0 and lives > 0 then 
			-- Reset player
			player_load(96, 80)
		-- Game Over
		elseif respawn == 0 then 
			-- Go back to menu
			fade_index = 0
		end
		
		-- Win
		if level_clear == true then
			if clear_timer >= 0 then clear_timer = clear_timer - 1 end
			if clear_timer == 0 then
				fade_index = 1
			end
			if fade_alpha == 1 then
				level_clear = false
				timer = 200
				reset_tables()
				level = level + 1
				generate_level(0.45, 0.04 + (level*0.01), 3)
			end
		end
		
		-- Music
		if ms_level:isPlaying() == false then
			love.audio.play(ms_level)
		end
		
		-- Player (player.lua)
		player_update()
		
		-- Enemies (enemy.lua)
		enemy_update()
		
		-- Bombs (bomb.lua)
		bomb_update()
		
		-- Flames (flame.lua)
		flame_update()
		
		-- Power Ups (powers.lua)
		power_update()
		
		-- Portal (gate.lua)
		gate_update()
		
		-- Effects (effect.lua)
		effect_update()
	end
	
	-- Reset game over 
	if fade_alpha == 1 and lives == 0 then
		global_init()
		reset_tables()
	end
end

function love.draw()
	-- MENU
	if scene_index == 0 then
		love.graphics.draw(bg_menu, 0, 0)
		love.graphics.setFont(font_kid)
		love.graphics.printf("PRESS SPACE OR (A) TO START\n\nHOW TO PLAY:\n\nUSE ARROWS OR DPAD TO MOVE.\nSPACE OR (A) TO PLANT A BOMB.", 0, 320, 1280, "center")
	-- LEVEL
	elseif scene_index == 1 then
		-- Background
		love.graphics.draw(bg_grass, bg_grass_quad, 96, 80)
		
		-- Power Ups (powers.lua)
		power_draw()
		
		-- Portal (gate.lua)
		gate_draw()
		
		-- Flames (flame.lua)
		flame_draw()
		
		-- Blocks (block.lua)
		block_draw()
		
		-- Bombs (bomb.lua)
		bomb_draw()
		
		-- Enemies (enemy.lua)
		enemy_draw()
		
		-- Player (player.lua)
		player_draw()
		
		-- Effects (effect.lua)
		effect_draw()
		
		-- HUD
		love.graphics.draw(spr_hud, 0, 0)
		love.graphics.setFont(font_kid)
		love.graphics.print("LIVES: " .. lives, 48, 10)
		love.graphics.print("LEVEL: " .. level, 240, 10)
		love.graphics.print("TIME: " .. math.floor(timer), 480, 10)
		love.graphics.print("SCORE: " .. score, 960, 10)
		
		-- Win
		if level_clear == true then
			love.graphics.setColor(0, 0, 0, 0.5)
			love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
			love.graphics.setColor(1, 1, 1, 1)
			
			love.graphics.printf("LEVEL CLEAR!", 0, 360, 1280, "center")
		end
		
		-- Game Over
		if lives == 0 then
			love.graphics.setColor(0, 0, 0, 0.5)
			love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
			
			love.graphics.setColor(1, .1, .1, 1)
			love.graphics.printf("GAME OVER!", 0, 360, 1280, "center")
			love.graphics.setColor(1, 1, 1, 1)
		end
	end
	
	-- Change fade opacity
	fade_alpha = fade_alpha + (fade_speed * sign(fade_index+1))
	
	-- Limit fade opacity
	if fade_alpha > 1 then fade_alpha = 1 elseif fade_alpha < 0 then fade_alpha = 0 end

	-- Chance scene when fade is 100% opaque
	if fade_alpha == 1 and fade_index ~= -4 then
		scene_index = fade_index
		fade_index = -4
		love.audio.stop(ms_level)
	end
	 
	-- Draw fade
	love.graphics.setColor(fade_color.r, fade_color.g, fade_color.b, fade_alpha)
		if fade_alpha > 0 then
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		end
	love.graphics.setColor(1, 1, 1, 1)

end

function love.keypressed(key, scancode, isrepeat)
	-- Exit
	if key == "escape" then
		love.event.quit()
	end
end