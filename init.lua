---@diagnostic disable-next-line: lowercase-global
minebase = {};

dofile(minetest.get_modpath("minebase") .. "/scripts/comms/commons.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/HUD/HUD.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/effects/effects.lua");


dofile(minetest.get_modpath("minebase") .. "/scripts/p.lua");

minebase.commands.functions.addCommand("minebase", "test",
    {}, {},
    function(name, params)
        local container = minebase.HUD.complex:newInfoBox(minetest.get_player_by_name(name), "infobox_test_1",
            "Test info box 1",
            "This is a text box in middle-right screen position. Automatic warp to the text.",
            minebase.screen.p.middle.right,
            minebase.colors.list.purple.dark, minebase.colors.list.white.dark);
        container:setOffset(-100, 0);
        container = minebase.HUD.complex:newInfoBox(minetest.get_player_by_name(name), "infobox_test_2",
            "Info box 2",
            "This is a another text box in bottom-left screen position.",
            minebase.screen.p.bottom.left,
            minebase.colors.list.orange.light, minebase.colors.list.white.light);
        container:setOffset(100, -50);
        container = minebase.HUD.complex:newInfoBox(minetest.get_player_by_name(name), "infobox_test_3",
            "Info-box 3",
            "Bla bla bla",
            minebase.screen.p.top.middle,
            minebase.colors.list.green.dark, minebase.colors.list.white.light);
        container:setOffset(0, 20);
        minetest.after(10, function(a)
            container:move(minebase.screen.p.middle.middle)
        end)
        return "";
    end
)

return minebase.m;
