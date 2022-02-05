function input()
    if player.lightsaber then
        player.sprite = player.sprite_walk + player.switch_saber
    else
        player.sprite = player.sprite_walk
    end

    if btn(0) then
        player.y = player.y - 1
        return
    end
    if btn(1) then
        player.y = player.y + 1
        return
    end
    if btn(2) then
        player.x = player.x - 1
        player.direction = 0
        return
    end
    if btn(3) then
        player.x = player.x + 1
        player.direction = 1
        return
    end
    if btn(4) then
        if player.lightsaber then
            player.sprite = player.sprite_attack
            sfx(10)
            enemy_kill()
        end
        return
    end

    if player.lightsaber then
        player.sprite = player.sprite_idle + player.switch_saber
    else
        player.sprite = player.sprite_idle
    end
end

function switch_sides()
    input()
    if player.x <= screen_manager.div then
        player.sprite = player.sprite + player.switch_sides
        if music_player.playing ~= 0 then
            music(0)
            music_player.playing = 0
        end
    else
        if music_player.playing ~= 1 then
            music(1)
            music_player.playing = 1
        end
    end
end