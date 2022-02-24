WALL = 161

alignment = {
    left_align = 44,
    middle_align = 104,
    right_align = 174,
    upper_margin = 20,
    bottom_margin = 128,
    right_margin = 230,
    left_margin = 0
}

status = {
    idle = 0,
    walk = -4,
    attack = 4,
    dead = 8
}

yoda = {
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
    length = 2,
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
}

enemy_dark = {
    x,
    y,
    sprite = 420,
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
    controller = {},
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
    transition_time = 17 * 2 - 2,
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