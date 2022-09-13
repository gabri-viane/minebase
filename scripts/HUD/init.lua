minebase.HUD.functions.newText = function(text, scale, offset, color, direction, alignment, size, style, z_index)
    return {
        hud_elem_type = "text",
        base_offset = offset,
        offset = offset,
        scale = scale,
        text = text,
        direction = direction or 0,
        alignment = alignment,
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
        base_offset = offset,
        offset = offset,
        direction = direction or 0,
        alignment = alignment or { x = 0, y = 0 },
        scale = scale,
        text = image,
        z_index = z_index or 0,
        type = "def"
    }
end