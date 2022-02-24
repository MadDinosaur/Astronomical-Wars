function generate_sprite(name, sprite, flip, scale, x, y)
    sx = nil
    sy = nil
    ssprite = nil
    sscale = nil
    sflip = nil

    if x ~= nil then
        sx = x
    else
        sx = name.x
    end
    if y ~= nil then
        sy = y
    else
        sy = name.y
    end
    if sprite ~= nil then
        ssprite = sprite
    else
        ssprite = name.sprite
    end
    if scale ~= nil then
        sscale = scale
    else
        sscale = 2
    end
    if flip ~= nil then
        sflip = flip
    else
        sflip = 0
    end

    spr(ssprite, sx, sy, 0, sscale, sflip, 0, name.width, name.length)
end

function animate_sprite(name, flip, x, y, sprite)
    t = (time() // 10) % 60 // (60 / name.animation_frames)

    if sprite ~= nil then
        generate_sprite(name, sprite + (t * name.width), flip, name.size, x, y)
    else
        generate_sprite(name, name.sprite + (t * name.width), flip, name.size, x, y)
    end
end