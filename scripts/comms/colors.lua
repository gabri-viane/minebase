minebase.colors.list = {
    red = {
        text = 0xFF0000,
        light = '#FF0000FF',
        dark = '#B20000FF'
    },
    orange = {
        text = 0xFFA500,
        light = '#FFA500FF',
        dark = '#B27300FF'
    },
    yellow = {
        text = 0xFFFF00,
        light = '#FFFF00FF',
        dark = '#B2B200FF'
    },
    green = {
        text = 0x8fce00,
        light = '#8fce00ff',
        dark = '#5b8300ff'
    },
    sky_blue = {
        text = 0x2986cc,
        light = '#2986ccff',
        dark = '#206ba3ff'
    },
    blue = {
        text = 0x0000cc,
        light = '#0000ccff',
        dark = '#00008eff'
    },
    violet = {
        text = 0xee82ee,
        light = '#ee82eeff',
        dark = '#a65ba6ff'
    },
    purple = {
        text = 0x800080,
        light = '#800080ff',
        dark = '#660066ff'
    },
    white = {
        text = 0xe5e5e5,
        light = '#ffffffff',
        dark = '#e5e5e5ff'
    },
    black = {
        text = 0x191919,
        light = '#191919ff',
        dark = '#000000ff'
    },
    random = {
        rnd1 = function()
            local av = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
            return '#' .. av[math.random(1, #av + 1)]
                .. av[math.random(1, #av + 1)]
                .. av[math.random(1, #av + 1)]
                .. av[math.random(1, #av + 1)]
                .. av[math.random(1, #av + 1)]
                .. av[math.random(1, #av + 1)]
                .. av[math.random(1, #av + 1)]
                .. av[math.random(1, #av + 1)];
        end
    }
}

--Ritorna il colore richiesto come stringa se esistente altrimenti la variante light del colore black
minebase.colors.functions.getColorString = function(color_name, type)
    local value = (minebase.colors.list[color_name or 'black'] or minebase.colors.list.black.light)[type or 'light'] or minebase.colors.list.black.light;
    if type(value) == "function" then
        value = value();
    end
    return value;
end

--Ritorna il colore richiesto come numero se esistente altrimenti la variante light del colore black
minebase.colors.functions.getColorHex = function(color_name, type)
    return tonumber(minebase.colors.functions.getColorString(color_name, type):sub(2, 9), 16);
end

minebase.colors.functions.colorToHex = function(color_string)
    return tonumber(color_string:sub(2, 7), 16);
end

--Aggiunge un colore, ritorna il colore aggiunto se è stato inserito altrimenti false
minebase.colors.functions.addColor = function(color_name, type, value)
    if color_name and type and value then
        minebase.colors.list[color_name] = {};
        minebase.colors.list[color_name][type] = value;
        return minebase.colors.list[color_name][type];
    end
    return false;
end



--[[
    La table §text_instructions deve essere formattato nel modo seguente:

    text_instructions = {
        {
            text = value,
            font_color = value,
            bg_color = value
        },
        {
            text = value,
            font_color = value,
            bg_color = value
        }
    }

    dove le table interne devono essere con indice numerico, i colori font_color e bg_color
    sono stringhe esadecimali e sono opzionali.
]]

minebase.colors.functions.setTextColor = function(text_instructions)
    if text_instructions then
        local text = {};
        for indx, value in ipairs(text_instructions) do
            local text_part_formatted = value.text;
            local font_color = value.font_color;
            local bg_color = value.bg_color;
            if font_color then
                text_part_formatted = core.colorize(font_color, text_part_formatted);
            end
            if bg_color then
                text_part_formatted = core.get_background_escape_sequence(bg_color) ..
                    text_part_formatted .. core.get_color_escape_sequence("#ffffff");
            end
            text[indx] = text_part_formatted;
            text_part_formatted = nil;
        end
        return table.concat(text);
    end
    return "";
end
