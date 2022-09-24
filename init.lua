---@diagnostic disable-next-line: lowercase-global
minebase = {};
minebase.scripts = minetest.get_modpath("minebase") .. '/scripts';

dofile(minebase.scripts.."/utils/image.lua");

dofile(minebase.scripts.."/remake/import.lua");

dofile(minebase.scripts.."/comms/import.lua");
dofile(minebase.scripts.."/commands/import.lua");
dofile(minebase.scripts.."/HUD/import.lua");
dofile(minebase.scripts.."/fs/import.lua");
dofile(minebase.scripts.."/effects/import.lua");
dofile(minebase.scripts.."/storage/import.lua");
dofile(minebase.scripts.."/utils/lookingat.lua");

dofile(minebase.scripts.."/registers.lua");
dofile(minebase.scripts.."/api.lua");

dofile(minebase.scripts.."/testing.lua");
--[[
minebase.commands.functions.addCommand("minebase", "test",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);
        local container = minebase.HUD.complex:newTextBoxT(player, "test_border", minebase.screen.bottom_left, 30, 17.5
            ,
            "Test title",
            minebase.colors.list.orange.light,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique. Cras pharetra ornare orci et aliquam. Mauris dapibus elit nec purus vehicula placerat."
            , minebase.colors.list.white.dark);
        container:addOffset(10, -(17.5 * 10 + 4 * 2 + 10));
        container:registerToScreen();
        container = minebase.HUD.complex:newTextBoxT(player, "test_border2", minebase.screen.bottom_center, 20, 24
            , "2. TITLE",
            minebase.colors.list.red.light,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique."
            , minebase.colors.list.black.light);
        container:addOffset(0, -(24 * 10 + 4 * 2 + 80));
        container:registerToScreen();
        return "";
    end
)
]]
minebase.commands.functions.addCommand("minebase", "test2",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);

        local list = minebase.HUD.complex:newList(player, "LIST_HUD", minebase.statics.screen.top_right, 48,
            { direction = { x = 0, y = 1 }, expandable = true, expand_direction = { x = -1, y = 0 }, v_spacing = 48 });
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
        for i = 1, 12 do
            local container;
            if i % 2 == 0 then
                container = minebase.HUD.complex:newIconBoxT(player, "info_IB_" .. i, "minebase_question_icon.png",
                    { x = 0, y = 0 });
            else
                container = minebase.HUD.complex:newBlockBoxT(player, "info_BB_" .. i, "minebase_question_base_block.png"
                    ,
                    { x = 0, y = 0 });
            end
            list:listAdd({ name = container.name, element = container });
        end
        return "Added to list";
    end
)

minebase.commands.functions.addCommand("minebase", "test4",
    {}, {},
    function(name, params)
        local player = minetest.get_player_by_name(name);

        local list = minebase.screen:get(player, "LIST_HUD");
        local t = math.random(1, 12);
        local nm = "info_"
        if t % 2 == 0 then
            nm = nm .. "IB_" .. t;
        else
            nm = nm .. "BB_" .. t;
        end
        list:listRemove(nm);
        return "Removed " .. nm .. " from list";
    end
)


return minebase.api;
