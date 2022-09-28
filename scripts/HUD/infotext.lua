function minebase.HUD.complex:newPointInfoText(player)
    local text_hud = minebase.HUD.functions.newText("prova", nil, nil
        , minebase.statics.colors.white_dark, nil, { x = 0, y = 0 }, nil, nil, 5);
    local container = minebase.HUD.functions.createLightContainer(player, "POINT_INFO_HUD",
        minebase.statics.screen.top_center, { x = 0, y = 25 }, text_hud);
    local last = nil;
    container:registerToScreen();

    minebase.functions:registerDx({
        on_tick = function(self)
            local res = minebase.utils.is_looking_at(player, 5, nil, false);
            local nm = "";
            if res.found then
                nm = res.node.description;
            end
            if last ~= res then
                container:updateElement("", { { name = "text", value = (nm or "") } });
            end
            last = res;
            return false;
        end,
        on_finish = function()

        end
    });
end
