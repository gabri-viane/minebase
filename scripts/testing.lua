minebase.commands.functions.addCommand("minebase", "test", {
    {
        name = "command",
        type = "string",
        optional = true
    }
},
    {},
    function(name, params)
        local player = minetest.get_player_by_name(name);
        if params.command then
            if params.command == "effects" then
                minebase.m.addEffectToPlayer(player, minebase.m.effects.jump_boost, 90, 3);
                minebase.m.addEffectToPlayer(player, minebase.m.effects.speed_boost, 45, 4);
                minebase.m.addEffectToPlayer(player, minebase.m.effects.night_vision, 120, 3);
                return "Added some effects as example"
            elseif params.command == "hudtext" then
                local container = minebase.screen:get(player, "test_hudtext1");
                if not container then
                    container = minebase.HUD.complex:newTextBoxT(player, "test_hudtext1",
                        minebase.screen.bottom_left, 30, 17.5, "Test title", minebase.colors.list.orange.light,
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique. Cras pharetra ornare orci et aliquam. Mauris dapibus elit nec purus vehicula placerat."
                        , minebase.colors.list.white.dark);
                    container:addOffset(10, -(17.5 * 10 + 4 * 2 + 10));
                    container:registerToScreen();
                    container = minebase.HUD.complex:newTextBoxT(player, "test_hudtext2", minebase.screen.bottom_center,
                        20, 24, "2. TITLE", minebase.colors.list.red.light,
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique."
                        , minebase.colors.list.black.light);
                    container:addOffset(0, -(24 * 10 + 4 * 2 + 80));
                    container:registerToScreen();
                    return "Added Container:" .. container.name;
                else
                    local container2 = minebase.screen:get(player, "test_hudtext2");
                    container2:addOffset(math.random(-30, 30), math.random(-30, 30));
                    container:addOffset(math.random(-30, 30), math.random(-30, 30));
                    return "This container already exists... moving the offsets randmoly";
                end
            elseif params.command == "hudlist" then
                local list = minebase.screen:get(player, "LIST_HUD");
                if not list then
                    list = minebase.HUD.complex:newList(player, "LIST_HUD", minebase.screen.top_right, 48,
                        { direction = { x = 0, y = 1 }, expandable = true, expand_direction = { x = -1, y = 0 },
                            v_spacing = 48 });
                    list:addOffset(-24, 24);
                    list:registerToScreen();
                    for i = 1, 5 do
                        local container;
                        if i % 2 == 0 then
                            container = minebase.HUD.complex:newIconBoxT(player, "info_IB_" .. i,
                                "minebase_question_icon.png", { x = 0, y = 0 });
                        else
                            container = minebase.HUD.complex:newBlockBoxT(player, "info_BB_" .. i,
                                "minebase_question_base_block.png", { x = 0, y = 0 });
                        end
                        list:listAdd({ name = container.name, element = container });
                    end
                    return "Example list added: appends down (max.5), expands left";
                else
                    local rnd = math.random(1, 2);
                    if rnd == 1 then
                        for i = 1, 5 do
                            local t = math.random(1, 5);
                            local nm = "info_"
                            if t % 2 == 0 then
                                nm = nm .. "IB_" .. t;
                            else
                                nm = nm .. "BB_" .. t;
                            end
                            list:listRemove(nm);
                        end
                        return "List already exists: removing random elements from list (they may not exist)" ;
                    else
                        for i = 1, 5 do
                            local container;
                            if i % 2 == 0 then
                                container = minebase.HUD.complex:newIconBoxT(player, "info_IB_" .. i,
                                    "minebase_question_icon.png", { x = 0, y = 0 });
                            else
                                container = minebase.HUD.complex:newBlockBoxT(player, "info_BB_" .. i,
                                    "minebase_question_base_block.png", { x = 0, y = 0 });
                            end
                            list:listAdd({ name = container.name, element = container });
                        end
                        return "List already exists: adding some elements to list";
                    end
                end
            end
        end
    end)
