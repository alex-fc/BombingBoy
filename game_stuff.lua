function global_init()
	level = 1				-- Initial level
	score = 0				-- Score
	timer = 200				-- Main timer
	lives = 3				-- Lifes
	bomb_count = 1			-- Bomb quantity
	bomb_force = 1			-- Bomb range
	
	respawn = -1			-- Respawn Timer
	level_clear = false		-- Level is clear?
	clear_timer = -1		-- Clear level timer
	scene_index = 0			-- 0 = menu, 1 = level
end

function check_keys_and_buttons()
	-- joysticks
	local joy_left = false 
	local joy_right = false
	local joy_up = false
	local joy_down = false
	local joy_a = false
	
	if joysticks[1] ~= nil then
		joy_left = joysticks[1]:isGamepadDown("dpleft")
		joy_right = joysticks[1]:isGamepadDown("dpright")
		joy_up = joysticks[1]:isGamepadDown("dpup")
		joy_down = joysticks[1]:isGamepadDown("dpdown")
		joy_a = joysticks[1]:isGamepadDown("a")
	end	
	
	-- Keyboard
	if love.keyboard.isDown("left") or joy_left then 
		key_left = key_left + 1 
	else key_left = 0 end
	
	if love.keyboard.isDown("right") or joy_right then 
		key_right = key_right + 1 
	else key_right = 0 end
	
	if love.keyboard.isDown("up") or joy_up then 
		key_up = key_up + 1 
	else key_up = 0 end
	
	if love.keyboard.isDown("down") or joy_down then 
		key_down = key_down + 1 
	else key_down = 0 end
	
	if love.keyboard.isDown("space") or joy_a then 
		key_a = key_a + 1 
	else key_a = 0 end
end

function reset_tables()
	-- Table - blocks
	blocks = {}
	
	-- Table - bombs
	bombs = {}
	
	-- Table - Flames
	flames = {}
	
	-- Table - enemies
	enemies = {}
	
	-- Table - player
	player = {}
	
	-- Table - power ups
	powers = {}
	
	-- Table - portal
	gates = {}
	
	-- Table - effects
	effects = {}
end

function generate_level(bcs, ens, pws)
	
	-- level model
	local level_00 = {}
	level_00[0] =	"###################"
	level_00[1] =	"#PN               #"
	level_00[2] =	"#N# # # # # # # # #"
	level_00[3] =	"#                 #"
	level_00[4] =	"# # # # # # # # # #"
	level_00[5] =	"#                 #"
	level_00[6] =	"# # # # # # # # # #"
	level_00[7] =	"#                 #"
	level_00[8] =	"# # # # # # # # # #"
	level_00[9] =	"#                 #"
	level_00[10] = 	"###################"
	
	-- Empty spaces count (It's fixed in this samples, but if necessary, this is how you do it)
	local spcs = 0;
	for i = 0, 10 do
		spcs = spcs + string_count(level_00[i], " ")
	end
	
	local qt_blocks = math.floor(bcs * spcs)
	local qt_enys = math.floor(ens * spcs)
	local qt_spaces = spcs - qt_blocks - qt_enys
	
	-- Table - game objects
	local table_string = {}
	for i = 0, spcs-1 do
		if i < qt_blocks then
			if i < pws then
				table.insert(table_string, "S") -- Power Up
			elseif i < qt_blocks-1 then
				table.insert(table_string, "O") -- Normal block
			else
				table.insert(table_string, "G") -- Gate
			end
		end
		if i < qt_enys then
			table.insert(table_string, "I")		-- Enemy
		end
		if i < qt_spaces then
			table.insert(table_string, " ")		-- Empty space
		end
	end
	
	-- Shuffle
	table_string = shuffle(table_string)
	
	-- Generate level with string above
	local my_spaces = spcs
	local my_powers = pws
	
	-- Filling the spaces
	for j = 0, 10 do
		for i = 1, 19 do
			-- Char
			local level_char = level_00[j]:sub(i, i)
			-- Game Object Position
			local xl = 32 + ((i-1) * 64)
			local yl = 16 + (j * 64)
			
			-- We find a empty space
			if level_char == " " then
				-- Get one char from the randomized string
				local table_char = table_string[118-my_spaces]
				my_spaces = my_spaces - 1
				
				-- Normal Blocks
				if table_char == "O" then
					block_load(xl, yl, spr_blocks_exp)
				-- Power Ups
				elseif table_char == "S" then
					block_load(xl, yl, spr_blocks_exp)
					-- Power Ups
					power_load(xl, yl, round(math.random()))
				-- GOAL
				elseif table_char == "G" then
					block_load(xl, yl, spr_blocks_exp)
					-- GOAL
					gate_load(xl, yl)
				-- Enemies
				elseif table_char == "I" then
					enemy_load(xl, yl)
				end
			-- Solid Blocks
			elseif level_char == "#" then
				block_load(xl, yl)
			-- Player
			elseif level_char == "P" then
				player_load(xl, yl)
			end
		end
	end
end

-- Generate Explosions
function create_explosion(xc, yc)
	
	local _l = 0	-- Left
	local _r = 0	-- Right
	local _u = 0	-- Up
	local _d = 0	-- Down
	
	-- Sfx
	love.audio.stop(sd_explosion)
	love.audio.play(sd_explosion)
	
	-- Checking if the positions are free to place the flames
	
	-- Right
	while collisionRectTable(blocks, xc + 64, yc, xc + 64 + (64 * _r), yc + 64) == nil 
	and _r < bomb_force do  
		_r = _r + 1
	end
		
	-- Left
	while collisionRectTable(blocks, xc - (64 * _l), yc, xc, yc + 64) == nil 
	and _l < bomb_force do 
		_l = _l + 1
	end
	
	-- Down 
	while collisionRectTable(blocks, xc, yc + 64, xc + 64, yc + 64 + (64 * _d)) == nil 
	and _d < bomb_force do 
		_d = _d + 1
		col_d = collisionRectTable(blocks, xc, yc + 64, xc + 64, yc + 64 + (64 * _d))
	end
	
	-- Up
	while collisionRectTable(blocks, xc, yc - (64 * _u), xc + 64, yc) == nil 
	and _u < bomb_force do 
		_u = _u + 1
		col_u = collisionRectTable(blocks, xc, yc - (64 * _u), xc + 64, yc)
	end
	
	-- Creating the flames
	
	-- Center flame
	flame_load(xc + 16, yc + 16)
	
	-- Respect the range limit
	for i = 1, bomb_force do
		-- Right
		if i <= _r then
			flame_load(xc + (i*64) + 16, yc + 16)
		end	
		-- Left
		if i <= _l then
			flame_load(xc - (i*64) + 16, yc + 16)
		end
		-- Up
		if i <= _u then
			flame_load(xc + 16, yc - (i*64) + 16)
		end
		-- Down
		if i <= _d then
			flame_load(xc + 16, yc + (i*64) + 16)
		end
	end
end

-- Calculate the distance between two points
function point_distance(_x1, _y1, _x2, _y2)
	local a = _x1 - _x2
	local b = _y1 - _y2

	return math.sqrt( a*a + b*b )
end

-- Calculate the direction between two points
function point_direction(_x1, _y1, _x2, _y2)
	return math.deg(math.atan2(-_y2 - -_y1, _x2 - _x1)) % 360
end

-- Returns the singular value
function sign(_val)
	if (_val == 0) then 
		return 0
	elseif (_val > 0) then
		return _val / _val
	else 
		return -(_val / _val)
	end
end

-- Table Shuffle by XeduR- https://gist.github.com/Uradamus/10323382
function shuffle(t)
	
	local tbl = {}
	
	for i = 1, #t do
		tbl[i] = t[i]
	end
	
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	
	return tbl
end

-- Counting substrinfs by Abhishek Kumar - https://stackoverflow.com/questions/11152220/counting-number-of-string-occurrences/11158158
function string_count(base, pattern)
    return select(2, string.gsub(base, pattern, ""))
end

-- Round a number
function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end