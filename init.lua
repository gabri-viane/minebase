---@diagnostic disable-next-line: lowercase-global
minebase = {};

dofile(minetest.get_modpath("minebase") .. "/scripts/comms/commons.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/HUD/HUD.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/effects/effects.lua");

dofile(minetest.get_modpath("minebase") .. "/scripts/registers.lua");

dofile(minetest.get_modpath("minebase") .. "/scripts/p.lua");

minebase.commands.functions.addCommand("minebase", "test",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);
        return "Test is empty";
    end
)

return minebase.m;
