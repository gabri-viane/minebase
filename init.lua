---@diagnostic disable-next-line: lowercase-global
minebase = {};

dofile(minetest.get_modpath("minebase") .. "/scripts/remake/import.lua");

dofile(minetest.get_modpath("minebase") .. "/scripts/comms/commons.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/HUD/HUD.lua");
dofile(minetest.get_modpath("minebase") .. "/scripts/effects/effects.lua");

dofile(minetest.get_modpath("minebase") .. "/scripts/registers.lua");

dofile(minetest.get_modpath("minebase") .. "/scripts/m.lua");

minebase.commands.functions.addCommand("minebase", "test",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);
        local container = minebase.HUD.complex:newTextBoxT(player, "test_border", minebase.screen.p.bottom.left, 30, 17.5
            ,
            "Test title",
            minebase.colors.list.orange.light,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique. Cras pharetra ornare orci et aliquam. Mauris dapibus elit nec purus vehicula placerat."
            , minebase.colors.list.white.dark);
        container:addOffset(10, -(17.5 * 10 + 4 * 2 + 10));
        container:registerToScreen();
        container = minebase.HUD.complex:newTextBoxT(player, "test_border2", minebase.screen.p.bottom.middle, 20, 24
            , "2. TITLE",
            minebase.colors.list.red.light,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique."
            , minebase.colors.list.black.light);
        container:addOffset(0, -(24 * 10 + 4 * 2 + 80));
        container:registerToScreen();
        return "";
    end
)

minebase.commands.functions.addCommand("minebase", "test2",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);

        local list = minebase.HUD.complex:newList(player, "LIST_HUD", minebase.screen.p.top.right, 48,
            { direction = { x = 0, y = 1 }, expandable=true,  expand_direction = { x = -1, y = 0 }, v_spacing = 48 });
        list:addOffset(-24, 24);
        list:registerToScreen();

        return "Added list";
    end
)

minebase.commands.functions.addCommand("minebase", "test3",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);

        local list = minebase.screen:get(player, "LIST_HUD");
        local container2 = minebase.HUD.complex:newIconBoxT(player, "info_t_i_1", "minebase_question_icon.png",
            { x = 0, y = 0 });
        list:listAdd({ name = container2.name, element = container2 });
        local container3 = minebase.HUD.complex:newBlockBoxT(player, "info_t_i_2", "minebase_question_base_block.png",
            { x = 0, y = 0 });
        list:listAdd({ name = container3.name, element = container3 });

        return "Added to list";
    end
)

minebase.commands.functions.addCommand("minebase", "test4",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);

        local list = minebase.screen:get(player, "LIST_HUD");
        local t = math.random(1, 2);
        if t == 1 then
            list:listRemove("info_t_i_1");
        else
            list:listRemove("info_t_i_2");
        end

        return "Removed from list";
    end
)


return minebase.m;
