function minebase.utils.toNode(node)
    return minetest.registered_nodes[node.name or "air"];
end

function minebase.utils.has_group(node, group)
    local n = minebase.utils.toNode(node);
    if n then
        return n.groups[group] or false;
    end
    return false;
end