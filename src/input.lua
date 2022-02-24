 --Direction constants
 U={x= 0, y= -1} --up
 D={x= 0, y= 1} --down
 L={x= -1, y= 0} --left
 R={x= 1, y= 0} --right

function input()
    if player.lightsaber then
        player.sprite = player.sprite_walk + player.switch_saber
    else
        player.sprite = player.sprite_walk
    end

    if btn(0) --and is_clear_ahead(U)
    then
        player.y = player.y - 1
        return
    end
    if btn(1) --and is_clear_ahead(D)
    then
        player.y = player.y + 1
        return
    end
    if btn(2) --and is_clear_ahead(L)
    then
        player.x = player.x - 1
        player.direction = 0
        return
    end
    if btn(3) --and is_clear_ahead(D)
    then
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

-- author: @programmeruser2
function is_clear_ahead(dir)
    local x=dir.x
    local y=dir.y

    if mget(player.x+x,player.y+y)<WALL then
      return true

     else
      return false
    end
end
