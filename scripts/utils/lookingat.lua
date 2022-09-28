function minebase.utils.is_looking_at(player, max_distance, find_objects, liquids)
    local arr = minebase.utils.look_to_pos_array(player, max_distance or 10);
    for i = 1, #arr do
        local pos = arr[i];
        local node = minetest.get_node(pos);
        if node.name ~= "air" then
            if not liquids then
                local n = minetest.registered_nodes[node.name];
                if n.drawtype ~= "liquid" then
                    return { found = true, pos = pos, node = n };
                end
            else
                return { found = true, pos = pos, node = minetest.registered_nodes[node.name] };
            end
        end
    end
    return { found = false };
end

function minebase.utils.look_to_pos_array(entity, max_distance)
    local pos = entity:get_pos();
    pos.y = pos.y + 1.5;
    local vec_pos = vector.new(pos.x, pos.y, pos.z);
    local pitch = entity:get_look_vertical();
    local yaw = entity:get_look_horizontal();
    max_distance = max_distance or 10;
    local look_vec = vector.normalize(vector.new(-math.sin(yaw) * math.cos(pitch), -math.sin(pitch),
        math.cos(yaw) * math.cos(pitch)));
    local result = {};
    local precision = minebase.statics.settings.looking_at_precision;
    for i = 1, max_distance * precision do
        local to_add = look_vec * (i / precision);
        local pos_end = vector.add(vec_pos, to_add);
        result[i] = pos_end;
    end
    return result;
end

function math.round_M(x, decimals)
    local p = 10 ^ decimals;
    return math.floor(x * p) / p;
end
