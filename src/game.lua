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
	sprite = 257,
	length = 2,
    width = 2
}

fire_right = {
	x = alignment.right_align,
	y = 30,
	sprite = 267,
	length = 1,
    width = 1,
	size = 3,
	animation_frames = 4
}

fire_left = {
	x = alignment.left_align,
	y = 30,
	sprite = 267,
	length = 1,
    width = 1,
	size = 3,
	animation_frames = 4
}

lightsaber = {
    x = alignment.middle_align + 10,
    y = 50,
    sprite = 259,
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
	sprite_idle = 293,
	sprite_walk = 289,
	sprite_attack = 329,
	sprite_dead = 297,
	switch_saber = 32,
	switch_sides = 64,
	lightsaber = false,
	direction = 0,
	length = 2,
	width = 2,
	size = 2,
	animation_frames = 2
}

enemy_dark = { 
	x,
	y,
	sprite = 421,
	sprite_idle = 421,
	sprite_walk = 417,
	sprite_attack = 425,
	direction = 0,
	length = 2,
	width = 2,
	size = 2,
	animation_frames = 2
}

enemy_light = { 
	x,
	y,
	sprite = 453,
	sprite_idle = 453,
	sprite_walk = 449,
	sprite_attack = 457,
	direction = 0,
	length = 2,
	width = 2,
	size = 2,
	animation_frames = 2
}

enemies = {}
num_enemies = 0
max_enemies = 10

screen_manager = { 
	screen = 0,
	transition_counter = 0,
	transition_speed = 100
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
		if player.lightsaber then player.sprite = player.sprite_attack end
		return
	end

	if player.lightsaber then player.sprite = player.sprite_idle + player.switch_saber else player.sprite = player.sprite_idle end
end

function switch_sides()
	input()
	if player.x > alignment.middle_align then player.sprite = player.sprite + player.switch_sides end
end

-- SCREENS --
function render_screen()
	if screen_manager.screen == 0 then start_screen() end
	if screen_manager.screen == 1 then battle_screen() end
end

function screen_transition()
	if screen_manager.screen == 0 then
		fire_left.y = fire_left.y - 1
		fire_right.y = fire_right.y - 1
		yoda.y = yoda.y - 1
		start_screen()
	end
	screen_manager.transition_counter = screen_manager.transition_counter + 1
end

function start_screen()
	input()

	animate_sprite(fire_left)
    animate_sprite(fire_right)
    generate_sprite(yoda)
    animate_sprite(lightsaber)
    animate_sprite(player, player.direction)
	
	print("It's dangerous to go alone...",44,10)
	print("Take THIS!",94, 20)

	pick_up(lightsaber)
end

function battle_screen() 
	switch_sides()

	map(0,17,30,17,0,0)
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
	enemy_type = 0
	if player.x <= alignment.middle_align then enemy_type = 1 end
	
	for i = enemy_type, num_enemies - 1, 2 do
		x = enemies[i] & 0xFFFF -- unpack x
		y = (enemies[i] >> 16) & 0xFFFF -- unpack y

		if (player.x - alignment.middle_align) ~= x then x = x + (player.x - alignment.middle_align - x)/math.abs(player.x - alignment.middle_align - x) end -- move closer to player x axis
		if player.y ~= y then y = y + (player.y - y)/math.abs(player.y - y) end -- move closer to player y axis

		enemies[i] = x | (y << 16) -- pack (x,y)
	end
end

function enemy_spawn()
	-- init
	while num_enemies < max_enemies
	do
		y = math.random(alignment.upper_margin, alignment.bottom_margin)
		x = math.random(0, alignment.middle_align)

		enemies[num_enemies] = x | (y << 16)
		enemies[num_enemies + 1] = x | (y << 16)
		num_enemies = num_enemies + 2
	end
	
	-- render
	for i = 0, num_enemies - 1 do
		x = enemies[i] & 0xFFFF
		y = (enemies[i] >> 16) & 0xFFFF
		
		animate_sprite(enemy_dark, enemy_dark.direction, alignment.middle_align + x, y)
		animate_sprite(enemy_light, enemy_light.direction, alignment.middle_align - x, y)
	end
end

function TIC()
	cls(14)
	
	if screen_manager.transition_counter > screen_manager.transition_speed then 
		screen_manager.screen = screen_manager.screen + 1 
		screen_manager.transition_counter = 0 
		player.x = alignment.middle_align
		player.y = 0
	end
	
	if screen_manager.transition_counter > 0 then screen_transition() else
		if player.y < alignment.bottom_margin then  render_screen() else 
			screen_transition() end
	end
end