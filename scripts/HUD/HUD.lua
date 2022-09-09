dofile(minetest.get_modpath('minebase') .. '/scripts/HUD/setup_HUD.lua');

--Create a new container with two elements: a title and a description
function minebase.HUD.complex:newInfoBox(player, name, title, text, position, title_color, text_color)
    local title_hud = minebase.HUD.functions.newText(title, { x = 100, y = 50 }, { x = 0, y = 0 }, title_color, nil,
        { x = 0, y = 0 }, 1.2, 1, 5);
        
    local warp_text = minebase.functions.warpString(text, 30);
    local text_hud = minebase.HUD.functions.newText(warp_text[1], { x = 100, y = 100 },
        { x = 0, y = 15 + 10 * warp_text[2] }, text_color, nil, { x = 0, y = 0 }, 1, 2, 5);
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "title", element = title_hud }, { name = "text", element = text_hud } });
    return container;
end
