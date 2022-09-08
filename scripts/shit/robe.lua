minebase.rightClick, minebase.onSecondaryUse, minebase.onPlace, minebase.custom = {}, {}, {}, {};
minebase.rightClick.Oblisteride =
function(pos, node, puncher, pointed_thing)
    if puncher:is_player() then
        minetest.chat_send_player(puncher:get_player_name(), "Let me give you some help...");
        puncher:set_hp(puncher:get_hp() - 3);
        minebase.effects.controls.add_effect(puncher, minebase.effects.list.slowness, 2, 10);
        minetest.remove_node(pos);
        minetest.add_item({ x = pos.x, y = pos.y + 1, z = pos.z }, ItemStack("minebase:oblisteride_shard 2"));
    end
end

minebase.onSecondaryUse.OblisterideItem =
function(itemstack, user, pointed_thing)
    minebase.custom.OblisterideItem(itemstack, user, pointed_thing);
end

minebase.onPlace.OblisterideItem =
function(itemstack, placer, pointed_thing)
    if placer:is_player() then
        minebase.custom.OblisterideItem(itemstack, placer, pointed_thing);
    end
end

minebase.custom.OblisterideItem =
function(itemstack, user, pointed_thing)
    user:get_inventory():remove_item('main', itemstack:take_item(1));
    user:set_hp(user:get_hp() + 3);
    minebase.effects.controls.add_effect(user,minebase.effects.list.speedness,3,10);
    --[[ local pos = user:get_pos();
    user:move_to({ x = pos.x + 6, y = pos.y + 6, z = pos.z }) ]]
end

minetest.register_craftitem("minebase:oblisteride_shard", {
    description = "Oblisteride Shard\nGives you speed 3 for 10s",
    inventory_image = "minebase_oblisteride_shard.png",
    on_secondary_use = minebase.onSecondaryUse.OblisterideItem,
    on_place = minebase.onPlace.OblisterideItem
});

minetest.register_node("minebase:oblisteride_block", {
    description = "Oblisteride cube",
    tiles = { "minebase_oblisteride.png" },
    is_ground_content = true,
    groups = { cracky = 3, stone = 1 },
    drop = "minebase:oblisteride_shard",
    on_punch = minebase.rightClick.Oblisteride
});

minetest.register_craft({
    type = "shaped",
    output = "minebase:oblisteride_block 1",
    recipe = {
        { "minebase:oblisteride_shard", "minebase:oblisteride_shard", "minebase:oblisteride_shard" },
        { "minebase:oblisteride_shard", "minebase:oblisteride_shard", "minebase:oblisteride_shard" },
        { "minebase:oblisteride_shard", "minebase:oblisteride_shard", "minebase:oblisteride_shard" }
    }
});

minetest.register_alias("oblisteride_shard", "minebase:oblisteride_shard");