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
	damage_buffer = 0,
	damage_buffer_timeout = 50,
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
	animation_frames = 2,
	life = 1
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
	animation_frames = 2,
	life = 1
}

obi_wan = {
	x = alignment.right_align,
	y = 60,
	sprite = 362,
	sprite_idle = 362,
	sprite_walk = 358,
	sprite_attack = 362,
	sprite_dead = 366,
	direction = 1,
	length = 2,
	width = 2,
	size = 3,
	animation_frames = 2,
	life = 3
}

darth_vader = {
	x = alignment.right_align,
	y = 50,
	sprite = 394,
	sprite_idle = 394,
	sprite_walk = 390,
	sprite_attack = 394,
	sprite_dead = 398,
	direction = 0,
	length = 2,
	width = 2,
	size = 3,
	animation_frames = 2,
	life = 3
}

boss = {
	x = -player.x,
	y = player.y,
	sprite,
	direction = -player.direction,
	length = 2,
	width = 2,
	size = 2,
	animation_frames = 2,
	life = 3
}

enemies = {
	positions = {},
	life = {},
	damage_buffer = {},
	damage_buffer_timeout = 25,
	num_enemies = 0,
	max_enemies = 2,
	speed = 100
}

header_text = {
	x = 44,
	y = 10
}

title_text_1 = {
	x = 24,
	y = 10,
	sprite = 480,
	length = 2,
	width = 12,
	size = 3
}

title_text_2 = {
	x = 84,
	y = 30,
	sprite = 492,
	length = 2,
	width = 4,
	size = 3
}

stars = {
	sprite = 462,
	length = 2,
	width = 2,
	size = 2
}

screen_manager = { 
	screen = -1,
	transition_counter = 0,
	transition_speed = 50,
	transition_time = 17*2-2,
	map_coord_x = 90,
	map_coord_y = 0,
	div = alignment.middle_align
}

music_player = {
	playing = -1
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
		if player.lightsaber then player.sprite = player.sprite_attack sfx(10) enemy_kill() end
		return
	end

	if player.lightsaber then player.sprite = player.sprite_idle + player.switch_saber else player.sprite = player.sprite_idle end
end

function switch_sides()
	input()
	if player.x <= screen_manager.div then 
		player.sprite = player.sprite + player.switch_sides 
		if music_player.playing ~= 0 then music(0) music_player.playing = 0 end
	else 
		if music_player.playing ~= 1 then music(1) music_player.playing = 1 end
	end
end

-- SCREENS --
function render_screen()
	if screen_manager.screen == -1 then splash_screen() end
	if screen_manager.screen == 0 then start_screen() end
	if screen_manager.screen == 1 then battle_screen() render_life() end
	if screen_manager.screen == 2 then battle_screen() render_life() end
	if screen_manager.screen == 3 then 
		if screen_manager.map_coord_x < alignment.middle_align then screen_manager.div = alignment.right_margin end
		if screen_manager.map_coord_x > alignment.middle_align then screen_manager.div = alignment.left_margin end
		battle_screen() render_life() end
	if screen_manager.screen == 4 then boss_screen() render_life() end
	if screen_manager.screen == 5 then credits_screen() end
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
	if screen_manager.screen == -1 then
		if math.floor(math.fmod(time()/screen_manager.transition_speed,2)) == 0 then
			screen_manager.map_coord_y = screen_manager.map_coord_y + 1
		end
	end
	if screen_manager.screen == 0 then
		if math.floor(math.fmod(time()/screen_manager.transition_speed,2)) == 0 then
			fire_left.y = fire_left.y - 1
			fire_right.y = fire_right.y - 1
			yoda.y = yoda.y - 1
			header_text.y = header_text.y - 1
			screen_manager.map_coord_y = screen_manager.map_coord_y + 1
		end
	end
	if screen_manager.screen == 1 then
		if math.floor(math.fmod(time()/screen_manager.transition_speed,2)) == 0 then
			screen_manager.map_coord_y = screen_manager.map_coord_y + 1
		end
	end
	if screen_manager.screen == 2 then
		screen_manager.transition_time = 29*2
		if math.floor(math.fmod(time()/screen_manager.transition_speed,2)) == 0 then
			screen_manager.map_coord_x = screen_manager.map_coord_x + (player.x - alignment.middle_align)/math.abs(player.x - alignment.middle_align)
		end
	end
	if screen_manager.screen == 3 then
		screen_manager.transition_time = 30*2
		if math.floor(math.fmod(time()/screen_manager.transition_speed,2)) == 0 then
			screen_manager.map_coord_x = screen_manager.map_coord_x + (player.x - alignment.middle_align)/math.abs(player.x - alignment.middle_align)
		end
	end
	if screen_manager.screen == 4 then
		screen_manager.map_coord_x = 90
		screen_manager.map_coord_y = 0
	end
	map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30,17,0,0)
	screen_manager.transition_counter = screen_manager.transition_counter + 1
end

function reset_screen()
	-- reset player posititon and enemies
	if screen_manager.screen > 1 then
		enemies.positions = {}
		enemies.life = {}
		enemies.num_enemies = 0
	end
	if screen_manager.screen == 0 then
		player.x = alignment.middle_align
		player.y = 90
	end
	if screen_manager.screen == 1 or screen_manager.screen == 2 then
		player.y = 0
	end
	if screen_manager.screen >= 3 then
		if screen_manager.map_coord_x < alignment.middle_align then player.x = alignment.right_margin -10 end
		if screen_manager.map_coord_x > alignment.middle_align then player.x = alignment.left_margin + 10 end
	end
end

function splash_screen()
	input()

	map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30,17,0,0)
	generate_sprite(title_text_1)
	generate_sprite(title_text_2)
	print("THE RISE OF DUALITY",64,70,8)
	print("Move - Arrows    Attack - Z", 45,95)
	
	if math.floor(math.fmod(time()/300,2)) == 0 then
	print("Hold DOWN", 90, 110) end

	if music_player.playing ~= 4 then 
		music(4)
		music_player.playing = 4
	end
end

function start_screen()
	input()

	map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30,17,0,0)
	animate_sprite(fire_left)
    animate_sprite(fire_right)
    generate_sprite(yoda)
    animate_sprite(lightsaber)
    animate_sprite(player, player.direction)
	
	print("Dangerous to go alone, it is...",header_text.x,header_text.y)
	print("Take THIS!",header_text.x + 50, header_text.y + 10)

	pick_up(lightsaber)
end

function battle_screen() 
	switch_sides()

	map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30,17,0,0)
	animate_sprite(player, player.direction)
	enemy_spawn()
	if(screen_manager.screen == 3) then mini_boss_spawn() end
	enemy_movement()
end

function boss_screen()
	switch_sides()

	map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30,17,0,0)
	animate_sprite(player, player.direction)
	boss_spawn()
end

function credits_screen()
	input()
	map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30,17,0,0)
	
	print("Thank you very much for playing!",0,0)
	print("This game is still in development!",0,10)
	animate_sprite(player, player.direction)
	
	print("Credit to:",0,30)
	print("@MadDinosaur - code",0,40)
	print("@Sakris - art & sound",0,50)
	print("@Edu - creative director",0,60)
	
	print("May the force be with you!",0,80,8)
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
	if math.floor(math.fmod(time()/enemies.speed,2)) == 0 then return end -- define speed

	enemy_type = nil
	x_player_position = nil

	if player.x <= screen_manager.div then x_player_position = screen_manager.div - player.x enemy_type = 1 end
	if player.x > screen_manager.div then x_player_position = player.x - screen_manager.div enemy_type = 0 end
	
	for i = enemy_type, enemies.num_enemies - 1, 2 do
		if enemies.positions[i] == nil then goto continue end
		
		x = enemies.positions[i] & 0xFFFF -- unpack x
		y = (enemies.positions[i] >> 16) & 0xFFFF -- unpack y
	
		if (x > x_player_position + player.vision or x < x_player_position- player.vision)
		and (y > player.y + player.vision or y < player.y - player.vision) then return end -- enemy deactivated

		if (x <= x_player_position + player.hitbox and x >= x_player_position - player.hitbox)
		and (y <= player.y + player.hitbox and y >= player.y - player.hitbox) then -- enemy in range to attack
			-- insert attack animation here
			take_damage()
			return
		end

		if x > x_player_position + player.hitbox or x < x_player_position - player.hitbox then 
			x = x + (x_player_position - x)/math.abs(x_player_position - x) end -- move closer to player x axis
		if y > player.y + player.hitbox or y < player.y - player.hitbox then y = y + (player.y - y)/math.abs(player.y - y) end -- move closer to player y axis

		enemies.positions[i] = x | (y << 16) -- pack (x,y)
			
		::continue::
	end
end

function enemy_spawn()
	-- init
	while enemies.num_enemies < enemies.max_enemies
	do
		y = math.random(alignment.upper_margin - 50, alignment.bottom_margin + 20)
		if screen_manager.div > alignment.left_margin then x = math.random(10, screen_manager.div - 10) else x = math.random(10, alignment.right_margin - screen_manager.div) end

		enemies.positions[enemies.num_enemies] = x | (y << 16)
		enemies.positions[enemies.num_enemies + 1] = x | (y << 16)
		
		enemies.life[enemies.num_enemies] = enemy_dark.life
		enemies.life[enemies.num_enemies + 1] = enemy_light.life

		enemies.damage_buffer[enemies.num_enemies] = 0
		enemies.damage_buffer[enemies.num_enemies + 1] = 0
		
		enemies.num_enemies = enemies.num_enemies + 2
	end
	
	-- render
	for i = 0, enemies.max_enemies - 1 do
		if enemies.positions[i] == nil then goto continue end
		
		x = enemies.positions[i] & 0xFFFF
		y = (enemies.positions[i] >> 16) & 0xFFFF
		
		if math.fmod(i,2) == 0  then 
			animate_sprite(enemy_dark, enemy_dark.direction, screen_manager.div + x, y)
		else
			animate_sprite(enemy_light, enemy_light.direction, screen_manager.div - x, y)
		end
		
		::continue::
	end
end

function mini_boss_spawn()
	-- init
	while enemies.num_enemies < enemies.max_enemies + 2 do
		enemies.positions[enemies.num_enemies] = darth_vader.x | (darth_vader.y << 16)
		enemies.positions[enemies.num_enemies + 1] = obi_wan.x | (obi_wan.y << 16)

		enemies.life[enemies.num_enemies] = darth_vader.life
		enemies.life[enemies.num_enemies + 1] = obi_wan.life

		enemies.damage_buffer[enemies.num_enemies] = 0
		enemies.damage_buffer[enemies.num_enemies + 1] = 0

		enemies.num_enemies = enemies.num_enemies + 2
	end

	-- render
	if screen_manager.map_coord_x < alignment.middle_align then 
		if enemies.positions[enemies.num_enemies - 1] == nil then return end
		x = enemies.positions[enemies.num_enemies - 1] & 0xFFFF
		y = (enemies.positions[enemies.num_enemies -1] >> 16) & 0xFFFF
		animate_sprite(obi_wan, obi_wan.direction, screen_manager.div - x, y) end
	if screen_manager.map_coord_x > alignment.middle_align then 
		if enemies.positions[enemies.num_enemies - 2] == nil then return end
		x = enemies.positions[enemies.num_enemies - 2] & 0xFFFF
		y = (enemies.positions[enemies.num_enemies - 2] >> 16) & 0xFFFF
		animate_sprite(darth_vader, darth_vader.direction, screen_manager.div + x, y) end
end

function boss_spawn()
	-- init
	if player.x <= screen_manager.div then boss.sprite = player.sprite - player.switch_sides end -- jedi
	if player.x > screen_manager.div then boss.sprite = player.sprite + player.switch_sides end -- sith

	-- render
	animate_sprite(boss, boss.direction)
end

function enemy_kill() 
	if screen_manager.screen == 0 then return end

	if player.x <= screen_manager.div then x_player_position = screen_manager.div - player.x enemy_type = 1 end
	if player.x > screen_manager.div then x_player_position = player.x - screen_manager.div enemy_type = 0 end

	for i = enemy_type, enemies.num_enemies - 1, 2 do
		if enemies.positions[i] == nil then goto continue end
		
		x = enemies.positions[i] & 0xFFFF -- unpack x
		y = (enemies.positions[i] >> 16) & 0xFFFF -- unpack y
		
		if x <= x_player_position + player.range and x >= x_player_position - player.range
		and y <= player.y + player.range and y >= player.y - player.range then
			deal_damage(i)
			return
		end
		
		::continue::
	end
end

function deal_damage(i)
	if enemies.life[i] > 0 then
		if enemies.damage_buffer[i] == 0 then enemies.life[i] = enemies.life[i] - 1 sfx (8) end
		if enemies.damage_buffer[i] < enemies.damage_buffer_timeout then enemies.damage_buffer[i] = enemies.damage_buffer[i] + 1 end
		if enemies.damage_buffer[i] >= enemies.damage_buffer_timeout then enemies.damage_buffer[i] = 0 end
	else
		-- insert death animation here
		enemies.positions[i] = nil -- remove enemy
		player.sith_kill_count = player.sith_kill_count + (1 * enemy_type)
		player.jedi_kill_count = player.jedi_kill_count + (1 * -(enemy_type - 1)) -- increment counters
	end
end

function take_damage()
	if player.life > 0 then 
		if player.damage_buffer == 0 then player.life = player.life - 1 end
		if player.damage_buffer < player.damage_buffer_timeout then player.damage_buffer = player.damage_buffer + 1 end
		if player.damage_buffer >= player.damage_buffer_timeout then player.damage_buffer = 0 end
	end
end

function TIC()
	cls(14)

	if screen_manager.transition_counter > screen_manager.transition_time then 
		screen_manager.screen = screen_manager.screen + 1 
		screen_manager.transition_counter = 0	
		reset_screen()
	end
	
	if screen_manager.transition_counter > 0 then screen_transition() else
		if player.y < alignment.bottom_margin and player.x < alignment.right_margin and player.x > alignment.left_margin then  render_screen() else 
			screen_transition() end
	end
end