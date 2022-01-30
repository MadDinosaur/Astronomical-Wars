alignment = {
	left_align = 44,
	middle_align = 104,
	right_align = 174,
	upper_margin = 20,
	bottom_margin = 128,
	right_margin = 230,
	left_margin = 0
}

yoda =  {
	x = alignment.middle_align,
	y = 20,
	sprite = 256,
	length = 2,
    width = 2
}

fire_right = {
	x = alignment.right_align,
	y = 30,
	sprite = 268,
	length = 1,
    width = 1,
	size = 3,
	animation_frames = 4
}

fire_left = {
	x = alignment.left_align,
	y = 30,
	sprite = 268,
	length = 1,
    width = 1,
	size = 3,
	animation_frames = 4
}

lightsaber = {
    x = alignment.middle_align + 10,
    y = 50,
    sprite = 258,
    length =  2,
    width = 1,
	size = 2,
	animation_frames = 2,
	hitbox = 10
}

player = {
	x = alignment.middle_align,
	y = 90,
	sprite,
	sprite_idle = 292,
	sprite_walk = 288,
	sprite_attack = 352,
	sprite_dead = 356,
	switch_saber = 8,
	switch_sides = 32,
	lightsaber = false,
	direction = 0,
	length = 2,
	width = 2,
	size = 2,
	animation_frames = 2,
	hitbox = 10,
	vision = 20,
	range = 15,
	life = 3,
	max_life = 3,
	sith_kill_count = 0,
	jedi_kill_count = 0
}

enemy_dark = { 
	x,
	y,
	sprite = 420,
	sprite_idle = 420,
	sprite_walk = 416,
	sprite_attack = 424,
	direction = 0,
	length = 2,
	width = 2,
	size = 2,
	animation_frames = 2
}

enemy_light = { 
	x,
	y,
	sprite = 452,
	sprite_idle = 452,
	sprite_walk = 448,
	sprite_attack = 456,
	direction = 0,
	length = 2,
	width = 2,
	size = 2,
	animation_frames = 2
}

enemies = {}
num_enemies = 0
max_enemies = 2

header_text = {
	x = 44,
	y = 10
}

screen_manager = { 
	screen = 0,
	transition_counter = 0,
	transition_speed = 100,
	map_coord_x = 0,
	map_coord_y = 0
}

GUI = {
	hp_bar = {
		right_border = 287,
		left_border = 283,
		red = 285,
		blue = 284,
		empty = 286,
		x = 0,
		y = 0,
		width = 1,
		length = 1
	} 
}

-- RENDERING AND ANIMATING --
function generate_sprite(name, sprite, flip, scale, x, y)
	sx = nil
	sy = nil
	ssprite = nil
	sscale = nil
	sflip = nil

	if x ~= nil then sx = x else sx = name.x end
	if y ~= nil then sy = y else sy = name.y end
	if sprite ~= nil then ssprite = sprite else ssprite = name.sprite end
	if scale ~= nil then sscale = scale else sscale = 2 end
	if flip ~= nil then sflip = flip else sflip = 0 end
	
	spr(ssprite, sx, sy, 0, sscale, sflip, 0, name.width, name.length)
end

function animate_sprite(name, flip, x, y)
    t = (time()//10)%60//(60/name.animation_frames)
    generate_sprite(name, name.sprite + (t*name.width), flip, name.size, x, y)
end

-- PLAYER INPUT --
function input() 
	if player.lightsaber then player.sprite = player.sprite_walk + player.switch_saber else player.sprite = player.sprite_walk end

	if btn(0) then player.y=player.y-1 return end
	if btn(1) then player.y=player.y+1 return end
	if btn(2) then 
		player.x=player.x-1 
		player.direction = 0
		return 
		end
	if btn(3) then 
		player.x=player.x+1 
		player.direction = 1
		return 
		end	
	if btn(4) then
		if player.lightsaber then player.sprite = player.sprite_attack enemy_kill() end
		return
	end

	if player.lightsaber then player.sprite = player.sprite_idle + player.switch_saber else player.sprite = player.sprite_idle end
end

function switch_sides()
	input()
	if player.x <= alignment.middle_align then player.sprite = player.sprite + player.switch_sides end
end

-- SCREENS --
function render_screen()
	if screen_manager.screen == 0 then start_screen() end
	if screen_manager.screen == 1 then battle_screen(90,34) render_life() end
	if screen_manager.screen == 2 then battle_screen(90,51) render_life() end
end

function render_life()
	generate_sprite(GUI.hp_bar, GUI.hp_bar.left_border)
	for i = 1, player.life do
		generate_sprite(GUI.hp_bar, GUI.hp_bar.red, nil, nil, GUI.hp_bar.x + i * 16, GUI.hp_bar.y)
	end
	for i = player.life + 1, player.max_life do
		generate_sprite(GUI.hp_bar, GUI.hp_bar.empty, nil, nil, GUI.hp_bar.x + i * 16, GUI.hp_bar.y)
	end
	generate_sprite(GUI.hp_bar, GUI.hp_bar.right_border, nil, nil, GUI.hp_bar.x + (player.max_life + 1) * 16, GUI.hp_bar.y)
end

function screen_transition()
	if screen_manager.screen == 0 then
		fire_left.y = fire_left.y - 1
		fire_right.y = fire_right.y - 1
		yoda.y = yoda.y - 1
		header_text.y = header_text.y - 1
		start_screen()
	end
	if screen_manager.screen == 1 then
		battle_screen()
	end
	screen_manager.transition_counter = screen_manager.transition_counter + 1
end

function start_screen()
	input()

	map()
	animate_sprite(fire_left)
    animate_sprite(fire_right)
    generate_sprite(yoda)
    animate_sprite(lightsaber)
    animate_sprite(player, player.direction)
	
	print("Dangerous to go alone, it is...",header_text.x,header_text.y)
	print("Take THIS!",header_text.x + 50, header_text.y + 10)

	pick_up(lightsaber)
end

function battle_screen(map_coord_x, map_coord_y) 
	switch_sides()

	map(map_coord_x, map_coord_y, 30,17,0,0)
	animate_sprite(player, player.direction)
	enemy_spawn()
	enemy_movement()
end

-- MECHANICS --
function pick_up(object)
	if player.x >= object.x - object.hitbox
		 and player.x < object.x + object.hitbox
			and player.y >= object.y - object.hitbox
			and player.y < object.y + object.hitbox then
		object.x = 0
		object.y = 0
		object.sprite = 256
		object.length = 1
		object.width = 1
		object.size = 0
		player.lightsaber = true
	end
end

function enemy_movement()
	enemy_type = nil
	x_player_position = nil

	if player.x <= alignment.middle_align then x_player_position = player.x enemy_type = 1 end
	if player.x > alignment.middle_align then x_player_position = player.x - alignment.middle_align enemy_type = 0 end
	
	for i = enemy_type, num_enemies - 1, 2 do
		if enemies[i] == nil then goto continue end
		
		x = enemies[i] & 0xFFFF -- unpack x
		y = (enemies[i] >> 16) & 0xFFFF -- unpack y
	
		if (x > x_player_position + player.vision or x < x_player_position- player.vision)
		and (y > player.y + player.vision or y < player.y - player.vision) then return end -- enemy deactivated

		if (x <= x_player_position + player.hitbox and x >= x_player_position - player.hitbox)
		and (y <= player.y + player.hitbox and y >= player.y - player.hitbox) then -- enemy in range to attack
			-- insert attack animation here
			if player.life > 0 then player.life = player.life - 1 end
			return
		end

		if x > x_player_position + player.hitbox or x < x_player_position - player.hitbox then 
			x = x + (x_player_position - x)/math.abs(x_player_position - x) end -- move closer to player x axis
		if y > player.y + player.hitbox or y < player.y - player.hitbox then y = y + (player.y - y)/math.abs(player.y - y) end -- move closer to player y axis

		enemies[i] = x | (y << 16) -- pack (x,y)
			
		::continue::
	end
end

function enemy_spawn()
	-- init
	while num_enemies < max_enemies
	do
		y = math.random(alignment.upper_margin - 40, alignment.bottom_margin)
		x = math.random(0, alignment.middle_align)

		enemies[num_enemies] = x | (y << 16)
		enemies[num_enemies + 1] = x | (y << 16)
		num_enemies = num_enemies + 2
	end
	
	-- render
	for i = 0, num_enemies - 1 do
		if enemies[i] == nil then goto continue end
		
		x = enemies[i] & 0xFFFF
		y = (enemies[i] >> 16) & 0xFFFF
		
		if math.fmod(i,2) == 0  then 
			animate_sprite(enemy_dark, enemy_dark.direction, alignment.middle_align + x, y)
		else
			animate_sprite(enemy_light, enemy_light.direction, alignment.middle_align - x, y)
		end
		
		::continue::
	end
end

function enemy_kill() 
	if screen_manager.screen == 0 then return end

	if player.x < alignment.middle_align then x_player_position = player.x enemy_type = 1 end
	if player.x > alignment.middle_align then x_player_position = player.x - alignment.middle_align enemy_type = 0 end

	for i = enemy_type, num_enemies - 1, 2 do
		if enemies[i] == nil then goto continue end
		
		x = enemies[i] & 0xFFFF -- unpack x
		y = (enemies[i] >> 16) & 0xFFFF -- unpack y
		
		if x <= x_player_position + player.range and x >= x_player_position - player.range
		and y <= player.y + player.range and y >= player.y - player.range then
			-- insert death animation here
			enemies[i] = nil -- remove enemy
			player.sith_kill_count = player.sith_kill_count + (1 * enemy_type)
			player.jedi_kill_count = player.jedi_kill_count + (1 * -(enemy_type - 1)) -- increment counters
		end
		
		::continue::
	end
end

function TIC()
	cls(14)

	if screen_manager.transition_counter > screen_manager.transition_speed then 
		screen_manager.screen = screen_manager.screen + 1 
		screen_manager.transition_counter = 0 
		player.x = alignment.middle_align + 10
		player.y = 0
	end
	
	if screen_manager.transition_counter > 0 then screen_transition() else
		if player.y < alignment.bottom_margin then  render_screen() else 
			screen_transition() end
	end
end