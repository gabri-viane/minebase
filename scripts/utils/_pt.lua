function minebase.utils._p(entity)
    local pos = entity:get_pos();
    pos.y = pos.y + 1.5;
    local vec_pos = vector.new(pos.x, pos.y, pos.z);
    local pitch = entity:get_look_vertical();
    local yaw = entity:get_look_horizontal();
    local max_distance = 10;
    local look_vec = vector.normalize(vector.new(-math.sin(yaw) * math.cos(pitch), -math.sin(pitch),
        math.cos(yaw) * math.cos(pitch)));
    local result = {};
    for i = 1, max_distance do
        local to_add = vector.multiply(look_vec, i);
        local pos_end = vector.add(vec_pos, to_add);
        result[i] = pos_end;
        minetest.set_node(pos_end, { name = "default:stone" });
    end
    return result;
end
