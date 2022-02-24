function pick_up(object)
    if
        player.x >= object.x - object.hitbox and player.x < object.x + object.hitbox and
            player.y >= object.y - object.hitbox and
            player.y < object.y + object.hitbox
     then
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
    if math.floor(math.fmod(time() / enemies.speed, 2)) == 0 then
        return
    end -- define speed

    enemy_type = nil
    x_player_position = nil

    if player.x <= screen_manager.div then
        x_player_position = screen_manager.div - player.x
        enemy_type = 1
    else
        x_player_position = player.x - screen_manager.div
        enemy_type = 0
    end

    for i = enemy_type, enemies.num_enemies - 1, 2 do
        if enemies.controller[i].position == nil then
            goto continue
        end

        x = enemies.controller[i].position & 0xFFFF -- unpack x
        y = (enemies.controller[i].position >> 16) & 0xFFFF -- unpack y

        if
            (x > x_player_position + player.vision or x < x_player_position - player.vision) and
                (y > player.y + player.vision or y < player.y - player.vision)
         then
            enemies.controller[i].status = status.idle
            return
        end -- enemy deactivated

        if
            (x <= x_player_position + player.hitbox and x >= x_player_position - player.hitbox) and
                (y <= player.y + player.hitbox and y >= player.y - player.hitbox)
         then -- enemy in range to attack
            enemies.controller[i].status = status.attack -- attack animation
            take_damage()
            return
        end

        if x > x_player_position + player.hitbox or x < x_player_position - player.hitbox then
            enemies.controller[i].status = status.walk
            x = x + (x_player_position - x) / math.abs(x_player_position - x)
        end -- move closer to player x axis
        if y > player.y + player.hitbox or y < player.y - player.hitbox then
            enemies.controller[i].status = status.walk
            y = y + (player.y - y) / math.abs(player.y - y)
        end -- move closer to player y axis

        enemies.controller[i].position = x | (y << 16) -- pack (x,y)
        ::continue::
    end
end

function enemy_spawn()
    -- init
    while enemies.num_enemies < enemies.max_enemies do
        y = math.random(alignment.upper_margin - 50, alignment.bottom_margin + 20)
        if screen_manager.div > alignment.left_margin then
            x = math.random(10, screen_manager.div - 10)
        else
            x = math.random(10, alignment.right_margin - screen_manager.div)
        end

        local enemy = {
            position = x | (y << 16),
            life = 1,
            status = status.idle,
            damage_buffer = 0
        }

        -- adds two mirrored enemies (light/dark)
        enemies.controller[enemies.num_enemies] = enemy
        enemies.controller[enemies.num_enemies + 1] = deepcopy(enemy)

        enemies.num_enemies = enemies.num_enemies + 2
    end

    -- render
    for i = 0, enemies.max_enemies - 1 do
        if enemies.controller[i].position == nil then
            goto continue
        end

        x = enemies.controller[i].position & 0xFFFF
        y = (enemies.controller[i].position >> 16) & 0xFFFF

        if math.fmod(i, 2) == 0 then
            animate_sprite(enemy_dark, enemy_dark.direction, screen_manager.div + x, y, enemy_dark.sprite + enemies.controller[i].status)
        else
            animate_sprite(enemy_light, enemy_light.direction, screen_manager.div - x, y, enemy_light.sprite + enemies.controller[i].status)
        end

        ::continue::
    end
end

function mini_boss_spawn()
    -- init
    while enemies.num_enemies < enemies.max_enemies + 2 do
        local darth_vader = {
            position = darth_vader.x | (darth_vader.y << 16),
            life = darth_vader.life,
            status = status.idle,
            damage_buffer = 0
        }

        local obi_wan = {
            position = obi_wan.x | (obi_wan.y << 16),
            life = obi_wan.life,
            status = status.idle,
            damage_buffer = 0
        }

        enemies.controller[enemies.num_enemies] = darth_vader
        enemies.controller[enemies.num_enemies + 1] = obi_wan

        enemies.num_enemies = enemies.num_enemies + 2
    end

    -- render
    if screen_manager.map_coord_x < alignment.middle_align then
        if enemies.controller[enemies.num_enemies - 1].position == nil then
            return
        end
        x = enemies.controller[enemies.num_enemies - 1].position & 0xFFFF
        y = (enemies.controller[enemies.num_enemies - 1].position >> 16) & 0xFFFF
        animate_sprite(obi_wan, obi_wan.direction, screen_manager.div - x, y)
    end
    if screen_manager.map_coord_x > alignment.middle_align then
        if enemies.controller[enemies.num_enemies - 2].position == nil then
            return
        end
        x = enemies.controller[enemies.num_enemies - 2].position & 0xFFFF
        y = (enemies.controller[enemies.num_enemies - 2].position >> 16) & 0xFFFF
        animate_sprite(darth_vader, darth_vader.direction, screen_manager.div + x, y)
    end
end

function boss_spawn()
    -- init
    if player.x <= screen_manager.div then
        boss.sprite = player.sprite - player.switch_sides
    end -- jedi
    if player.x > screen_manager.div then
        boss.sprite = player.sprite + player.switch_sides
    end -- sith

    -- render
    animate_sprite(boss, boss.direction)
end

function enemy_kill()
    if screen_manager.screen == 0 then
        return
    end

    if player.x <= screen_manager.div then
        x_player_position = screen_manager.div - player.x
        enemy_type = 1
    end
    if player.x > screen_manager.div then
        x_player_position = player.x - screen_manager.div
        enemy_type = 0
    end

    for i = enemy_type, enemies.num_enemies - 1, 2 do
        if enemies.controller[i].position == nil then
            goto continue
        end

        x = enemies.controller[i].position & 0xFFFF -- unpack x
        y = (enemies.controller[i].position >> 16) & 0xFFFF -- unpack y

        if
            x <= x_player_position + player.range and x >= x_player_position - player.range and
                y <= player.y + player.range and
                y >= player.y - player.range
         then
            deal_damage(i)
            return
        end

        ::continue::
    end
end

function deal_damage(i)
    if enemies.controller[i].life > 0 then
        if enemies.controller[i].damage_buffer == 0 then
            enemies.controller[i].life = enemies.controller[i].life - 1
            sfx(8)
        end
        if enemies.controller[i].damage_buffer < enemies.damage_buffer_timeout then
            enemies.controller[i].damage_buffer = enemies.controller[i].damage_buffer + 1
        end
        if enemies.controller[i].damage_buffer >= enemies.damage_buffer_timeout then
            enemies.controller[i].damage_buffer = 0
        end
    else
        enemies.controller[i].status = status.dead -- death animation
        enemies.controller[i].position = nil -- remove enemy
    end
end

function take_damage()
    if player.life > 0 then
        if player.damage_buffer == 0 then
            player.life = player.life - 1
        end
        if player.damage_buffer < player.damage_buffer_timeout then
            player.damage_buffer = player.damage_buffer + 1
        end
        if player.damage_buffer >= player.damage_buffer_timeout then
            player.damage_buffer = 0
        end
    end
end