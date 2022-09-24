function minebase.utils.is_looking_at(player, max_distance, find_objects, liquids)
    local arr = minebase.utils.look_to_pos_array(player, max_distance or 10, find_objects, liquids);
    for i = 1, max_distance or 10 do
        local pos = arr[i];
        local node = minetest.get_node(pos);
        if node.name ~= "air" then
            return { found = true, pos = pos, node = node };
        end
    end
    return { found = false };
end

function minebase.utils.look_to_pos_array(entity, max_distance, find_objects, liquids)
    local pos = entity:get_pos();
    pos.y = pos.y + 1.125; --livello occhi, altrimenti è piedi

    local pitch = entity:get_look_vertical();
    local yaw = entity:get_look_horizontal();

    if not max_distance then
        max_distance = 10;
    end
    if find_objects == nil then
        find_objects = false;
    end
    if liquids == nil then
        liquids = true;
    end

    local add_vertical = -math.round(math.sin(pitch), 2);
    local add_h_z = math.round(math.cos(yaw) * math.cos(pitch), 2);
    local add_h_x = -math.round(math.sin(yaw) * math.cos(pitch), 2);

    local result = {};

    for i = 1, max_distance do
        local pos3 = {
            x = pos.x + i * add_h_x,
            y = pos.y + i * add_vertical,
            z = pos.z + i * add_h_z
        }
        result[i] = pos3;
    end
    return result;
end

function math.round(x, decimals)
    local p = 10 ^ decimals;
    return math.floor(x * p) / p;
end

minebase.commands.functions.addCommand("minebase", "lookingat", {}, {},
    function(player, params)
        local found = minebase.utils.is_looking_at(minetest.get_player_by_name(player));
        if found.found then
            return found.node.name;
        end
        return "Not found";
    end)
