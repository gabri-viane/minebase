minebase.HUD.functions.newText = function(text, scale, offset, color, direction, alignment, size, style, z_index)
    return {
        hud_elem_type = "text",
        base_offset = offset or { x = 0, y = 0 },
        offset = offset or { x = 0, y = 0 },
        scale = scale or { x = 1, y = 1 },
        text = text,
        direction = direction or 0,
        alignment = alignment or { x = -1, y = -1 },
        size = { x = size or 1, y = 0 },
        style = style or 0,
        number = minebase.colors.functions.colorToHex(color or '000000'),
        z_index = z_index or 0,
        type = "def"
    }
end

minebase.HUD.functions.newImage = function(image, scale, offset, direction, alignment, z_index)
    return {
        hud_elem_type = "image",
        base_offset = offset or { x = 0, y = 0 },
        offset = offset or { x = 0, y = 0 },
        direction = direction or 0,
        alignment = alignment or { x = 0, y = 0 },
        scale = scale or { x = 1, y = 1 },
        text = image,
        z_index = z_index or 0,
        type = "def"
    }
end
