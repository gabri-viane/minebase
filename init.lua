---@diagnostic disable-next-line: lowercase-global
minebase = {};

dofile(minetest.get_modpath("minebase") .. "/scripts/comms/commons.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/HUD/HUD.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/effects/effects.lua");

dofile(minetest.get_modpath("minebase") .. "/scripts/registers.lua");

dofile(minetest.get_modpath("minebase") .. "/scripts/p.lua");

minebase.commands.functions.addCommand("minebase", "test1",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);
        minebase.m.addEffectToPlayer(player, minebase.effects.list.jumpness, 20, 3);
        --local container = minebase.HUD.complex:newEffectList(player);
        --container:appendEffect({ effect = minebase.effects.list.jumpness, duration = 9999, id_amp = 3 });
        --container:appendEffect({ effect = minebase.effects.list.speedness, duration = 9999, id_amp = 3 });
        --inebase.HUD.complex:newEffectBar(player,"test",{ effect = minebase.effects.list.jumpness, duration = 9999, id_amp = 3 },minebase.screen.p.bottom.right);
        return "";
    end
)
minebase.commands.functions.addCommand("minebase", "test2",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);
        minebase.m.addEffectToPlayer(player, minebase.effects.list.jumpness, 40, 3);
        return "";
    end
)

minebase.commands.functions.addCommand("minebase", "test3",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);
        minebase.m.addEffectToPlayer(player,minebase.effects.list.jumpness, 10, 4 );
        return "";
    end
)

return minebase.m;
