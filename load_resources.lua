-- Load the game resources
function load_resources()

	-- Load Backgrounds
	bg_grass = love.graphics.newImage("backgrounds/grass.png")
	bg_grass:setWrap("repeat", "repeat") -- horizontal and vertical repeat
	bg_grass_quad = love.graphics.newQuad(0, 0, 1280-192, 720-144, bg_grass:getDimensions())
	bg_menu = love.graphics.newImage("backgrounds/menu.png")
	
	-- Load Sprites
	spr_blocks = love.graphics.newImage("sprites/block.png")
	spr_blocks_exp = love.graphics.newImage("sprites/block_exp.png")
	spr_portal = love.graphics.newImage("sprites/portal.png")
	spr_flame = love.graphics.newImage("sprites/flame.png")
	spr_bomb = love.graphics.newImage("sprites/bomb.png")
	spr_power_ups = love.graphics.newImage("sprites/block_exp.png")
	spr_powers = love.graphics.newImage("sprites/power_ups.png")
	
	spr_player_side = love.graphics.newImage("sprites/player_side.png")
	spr_player_down = love.graphics.newImage("sprites/player_down.png")
	spr_player_up = love.graphics.newImage("sprites/player_up.png")
	spr_enemy = love.graphics.newImage("sprites/enemy.png")
	spr_hud = love.graphics.newImage("sprites/hudbar.png")
	
	fx_death = love.graphics.newImage("sprites/fx_death.png")
	fx_block = love.graphics.newImage("sprites/block_destroy.png")
	
	-- Load sfx
	sd_explosion = love.audio.newSource("sounds/explosion.wav", "static")
	sd_walk = love.audio.newSource("sounds/walk.wav", "static")
	sd_bomb = love.audio.newSource("sounds/bomb.wav", "static")
	sd_power = love.audio.newSource("sounds/power_up.wav", "static")
	sd_enemy = love.audio.newSource("sounds/enemy_dead.wav", "static")
	sd_death = love.audio.newSource("sounds/death.wav", "static")
	sd_win = love.audio.newSource("sounds/win.wav", "static")
	sd_go = love.audio.newSource("sounds/gameover.wav", "static")
	
	-- Load musics
	ms_level = love.audio.newSource("musics/level.mp3", "stream")
	ms_level:setVolume(0.3)
	
	-- Fonts
	font_consola = love.graphics.newFont("fonts/consola.ttf", 15)
	font_kid = love.graphics.newFont("fonts/KidGames.ttf", 24)
	
end