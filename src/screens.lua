alignment = {
	left_align = 44,
	middle_align = 104,
	right_align = 174,
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
    width = 1
}

fire_left = {
	x = alignment.left_align,
	y = 30,
	sprite = 267,
	length = 1,
    width = 1
}

lightsaber = {
    x = alignment.middle_align + 10,
    y = 50,
    sprite = 259,
    length =  2,
    width = 1
}

player = {
				x = alignment.middle_align,
				y = 90,
				sprite = 293,
				sprite_idle = 293,
				sprite_walk = 289,
				direction = 0,
				length = 2,
				width = 2
}

function generate_sprites(name, sprite, flip, scale, x, y)
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

function animate_sprite(name, frames, flip, scale)
    t = (time()//10)%60//(60/frames)
    generate_sprites(name, name.sprite + (t*name.width), flip, scale)
end

function input() 
	player.sprite = player.sprite_walk
	
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
	
	player.sprite = player.sprite_idle
end

function TIC()
	input()

	cls(14)
	
	-- START SCREEN --
    animate_sprite(fire_left,4,nil,3)
    animate_sprite(fire_right,4,nil,3)
    generate_sprites(yoda)
    animate_sprite(lightsaber,2)
    animate_sprite(player,2,player.direction)
	
	print("It's dangerous to go alone...",44,10)
	print("Take THIS!",94, 20)
	-------------------
end