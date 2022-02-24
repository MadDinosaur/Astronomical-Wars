require "config"
require "input"
require "mechanics"
require "rendering"
require "utils"

function render_screen()
    if screen_manager.screen == -1 then
        splash_screen()
    end
    
    if screen_manager.screen == 0 then
        start_screen()
    end

    if contains({1, 2, 4}, screen_manager.screen) then
        battle_screen()
        render_life()
    end

    if screen_manager.screen == 3 then
        if screen_manager.map_coord_x < alignment.middle_align then
            screen_manager.div = alignment.right_margin
        end

        if screen_manager.map_coord_x > alignment.middle_align then
            screen_manager.div = alignment.left_margin
        end

        battle_screen()
        render_life()
    end
    
    if screen_manager.screen == 5 then
        credits_screen()
    end
end

function render_life()
    generate_sprite(GUI.hp_bar, GUI.hp_bar.left_border)
    for i = 1, player.life do
        generate_sprite(GUI.hp_bar, GUI.hp_bar.red, nil, nil, GUI.hp_bar.x + i * 16, GUI.hp_bar.y)
    end

    for i = player.life + 1, player.max_life do
        generate_sprite(GUI.hp_bar, GUI.hp_bar.empty, nil, nil, GUI.hp_bar.x + i * 16, GUI.hp_bar.y)
    end

    generate_sprite(
        GUI.hp_bar,
        GUI.hp_bar.right_border,
        nil,
        nil,
        GUI.hp_bar.x + (player.max_life + 1) * 16,
        GUI.hp_bar.y
    )
end

function screen_transition()
    if screen_manager.screen == -1 then
        if math.floor(math.fmod(time() / screen_manager.transition_speed, 2)) == 0 then
            screen_manager.map_coord_y = screen_manager.map_coord_y + 1
        end
    end

    if screen_manager.screen == 0 then
        if math.floor(math.fmod(time() / screen_manager.transition_speed, 2)) == 0 then
            fire_left.y = fire_left.y - 1
            fire_right.y = fire_right.y - 1
            yoda.y = yoda.y - 1
            header_text.y = header_text.y - 1
            screen_manager.map_coord_y = screen_manager.map_coord_y + 1
        end
    end

    if screen_manager.screen == 1 then
        if math.floor(math.fmod(time() / screen_manager.transition_speed, 2)) == 0 then
            screen_manager.map_coord_y = screen_manager.map_coord_y + 1
        end
    end

    if screen_manager.screen == 2 then
        screen_manager.transition_time = 29 * 2

        if math.floor(math.fmod(time() / screen_manager.transition_speed, 2)) == 0 then
            screen_manager.map_coord_x =
                screen_manager.map_coord_x +
                (player.x - alignment.middle_align) / math.abs(player.x - alignment.middle_align)
        end
    end

    if screen_manager.screen == 3 then
        screen_manager.transition_time = 30 * 2
        if math.floor(math.fmod(time() / screen_manager.transition_speed, 2)) == 0 then
            screen_manager.map_coord_x =
                screen_manager.map_coord_x +
                (player.x - alignment.middle_align) / math.abs(player.x - alignment.middle_align)
        end
    end

    if screen_manager.screen == 4 then
        screen_manager.map_coord_x = 90
        screen_manager.map_coord_y = 0
    end

    map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30, 17, 0, 0)
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
        if screen_manager.map_coord_x < alignment.middle_align then
            player.x = alignment.right_margin - 10
        end
        if screen_manager.map_coord_x > alignment.middle_align then
            player.x = alignment.left_margin + 10
        end
    end
end

function splash_screen()
    input()

    map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30, 17, 0, 0)
    generate_sprite(title_text_1)
    generate_sprite(title_text_2)
    print("THE RISE OF DUALITY", 64, 70, 8)
    print("Move - Arrows    Attack - Z", 45, 95)

    if math.floor(math.fmod(time() / 300, 2)) == 0 then
        print("Hold DOWN", 90, 110)
    end

    if music_player.playing ~= 4 then
        music(4)
        music_player.playing = 4
    end
end

function start_screen()
    input()

    map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30, 17, 0, 0)
    animate_sprite(fire_left)
    animate_sprite(fire_right)
    generate_sprite(yoda)
    animate_sprite(lightsaber)
    animate_sprite(player, player.direction)

    print("Dangerous to go alone, it is...", header_text.x, header_text.y)
    print("Take THIS!", header_text.x + 50, header_text.y + 10)

    pick_up(lightsaber)
end

function battle_screen()
    switch_sides()

    map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30, 17, 0, 0)
    animate_sprite(player, player.direction)
    enemy_spawn()
    if (screen_manager.screen == 3) then
        mini_boss_spawn()
    end
    enemy_movement()
end

function boss_screen()
    switch_sides()

    map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30, 17, 0, 0)
    animate_sprite(player, player.direction)
    boss_spawn()
end

function credits_screen()
    input()
    map(screen_manager.map_coord_x, screen_manager.map_coord_y, 30, 17, 0, 0)

    print("Thank you very much for playing!", 0, 0)
    print("This game is still in development!", 0, 10)
    animate_sprite(player, player.direction)

    print("Credit to:", 0, 30)
    print("@MadDinosaur - code", 0, 40)
    print("@Sakris - art & sound", 0, 50)
    print("@Edu - creative director", 0, 60)
    print("@educorreia932 - refactoring master", 0, 70)

    print("May the force be with you!", 0, 80, 8)
end