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
                minebase.api.addEffectToPlayer(player, minebase.api.effects.jump_boost, 90, 3);
                minebase.api.addEffectToPlayer(player, minebase.api.effects.speed_boost, 45, 4);
                minebase.api.addEffectToPlayer(player, minebase.api.effects.night_vision, 120, 3);
                return "Added some effects as example"
            elseif params.command == "hudtext" then
                local container = minebase.screen:get(player, "test_hudtext1");
                if not container then
                    container = minebase.HUD.complex:newTextBoxT(player, "test_hudtext1",
                        minebase.statics.screen.bottom_left, 30, 17.5, "Test title", minebase.statics.colors.orange_light
                        ,
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique. Cras pharetra ornare orci et aliquam. Mauris dapibus elit nec purus vehicula placerat."
                        , minebase.statics.colors.white_dark);
                    container:addOffset(10, -(17.5 * 10 + 4 * 2 + 10));
                    container:registerToScreen();
                    container = minebase.HUD.complex:newTextBoxT(player, "test_hudtext2",
                        minebase.statics.screen.bottom_center
                        ,
                        20, 24, "2. TITLE", minebase.statics.colors.red_light,
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique."
                        , minebase.statics.colors.black_light);
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
                    list = minebase.HUD.complex:newList(player, "LIST_HUD", minebase.statics.screen.top_right, 48,
                        { direction = minebase.statics.directions.down, expandable = true,
                            expand_direction = minebase.statics.directions.left,
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
                        return "List already exists: removing random elements from list (they may not exist)";
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

            elseif params.command == "slide" then
                local container = minebase.screen:get(player, "info_IB_X");
                if not container then
                    container = minebase.HUD.complex:newIconBoxT(player, "info_IB_X",
                        "minebase_question_icon.png", minebase.statics.screen.center_center);
                    container:registerToScreen();
                    container = minebase.HUD.animations.injectSlide(container);
                end
                container:slide({ x = math.random(-100, 100), y = math.random(-100, 100) }, math.random() * 2);
            elseif params.command == "fade" then
                local container = minebase.screen:get(player, "info_IB_Y");
                if not container then
                    local img = minebase.HUD.functions.newImage("test1.png^[lowpart:50:test2.png");
                    container = minebase.HUD.functions.createLightContainer(player, "info_IB_Y",
                        minebase.statics.screen.center_center, nil, img);
                    container:registerToScreen();
                    container = minebase.HUD.animations.injectAlphaFade(container);
                end
                container:alphaFadeS("icon", 255, 0, 2);
            elseif params.command == "anim" then
                local container = minebase.screen:get(player, "info_IB_Z");
                if not container then
                    local img = minebase.HUD.functions.newImage("sprite.png");
                    container = minebase.HUD.functions.createLightContainer(player, "info_IB_Z",
                        minebase.statics.screen.center_center, nil, img);
                    container:registerToScreen();
                    container = minebase.HUD.animations.injectAnimation(container);
                end
                container:frameAnimation("icon", 4, 0.4, 10, 2);
            elseif params.command == "animt" then
                local container = minebase.screen:get(player, "info_IB_W");
                if not container then
                    local img = minebase.HUD.functions.newText("Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                        ..
                        " Aenean rhoncus elementum diam, et blandit dolor venenatis ut. In fermentum hendrerit tristique. "
                        .. "Cras pharetra ornare orci et aliquam. Mauris dapibus elit nec purus vehicula placerat.");
                    container = minebase.HUD.functions.createLightContainer(player, "info_IB_W",
                        minebase.statics.screen.center_center, nil, img);
                    container:registerToScreen();
                    container = minebase.HUD.animations.injectAnimation(container);
                end
                container:textAnimation("text", 10, 0.5, 50, 3);
            elseif params.command == "imgread" then
                local width, height = GetImageWidthHeight(minetest.get_modpath("minebase") .. "/textures/test1.png");
                minetest.log("Dimensions:" .. width .. "x" .. height);
            end
        end
    end)
