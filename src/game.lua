alignment = {
	left_align = 44,
	middle_align = 104,
	right_align = 174,
	bottom_margin = 128
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
	animation_frames = 2
}

player = {
	x = alignment.middle_align,
	y = 90,
	sprite = 293,
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

screen = 0
transition_counter = 0

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

function animate_sprite(name, flip)
    t = (time()//10)%60//(60/name.animation_frames)
    generate_sprite(name, name.sprite + (t*name.width), flip, name.size)
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

-- SCREENS --
function render_screen(screen)
	if screen == 0 then start_screen() end
	if screen == 1 then battle_screen() end
end

function screen_transition()
	if screen == 0 then
		fire_left.y = fire_left.y - 1
		fire_right.y = fire_right.y - 1
		yoda.y = yoda.y - 1
		start_screen()
	end
	transition_counter = transition_counter + 1
end

function start_screen()
	animate_sprite(fire_left)
    animate_sprite(fire_right)
    generate_sprite(yoda)
    animate_sprite(lightsaber)
    animate_sprite(player, player.direction)
	
	print("It's dangerous to go alone...",44,10)
	print("Take THIS!",94, 20)

	pick_up(lightsaber)
end

function battle_screen() end

function pick_up(object)
	if player.x == object.x or player.y == object.y then
		object.x = 0
		object.y = 0
		object.sprite = 256
		object.length = 1
		object.width = 1
		object.size = 0
		player.lightsaber = true
	end
end

function TIC()
	input()
	
	cls(14)
	
	if transition_counter > alignment.bottom_margin then screen = screen + 1 transition_counter = 0 end
	
	if transition_counter > 0 then 	screen_transition() else
		if player.y < alignment.bottom_margin then  render_screen(screen) else 
			screen_transition() end
	end
end