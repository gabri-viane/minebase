dofile(minetest.get_modpath('minebase') .. '/scripts/HUD/setup_HUD.lua');

--Create a new container with two elements: a title and a description
function minebase.HUD.complex:newInfoBox(player, name, title, text, position, title_color, text_color)

    local title_hud = minebase.HUD.functions.newText(title, { x = 100, y = 50 }, { x = 0, y = 0 }, title_color, nil,
        { x = 0, y = 0 }, 1.2, 1, 5);
    local warp_text = minebase.functions.warpString(text, 30);
    local text_hud = minebase.HUD.functions.newText(warp_text[1], { x = 100, y = 100 },
        { x = 0, y = 15 + 10 * warp_text[2] }, text_color, nil, { x = 0, y = 0 }, 1, 2, 5);
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "title", element = title_hud, type = "def" },
        { name = "text", element = text_hud, type = "def" } });
    return container;
end

function minebase.HUD.complex:newImageTextL(player, name, image, text, position, text_color)

    local img_hud = minebase.HUD.functions.newImage(image, { x = 3, y = 3 }, { x = 0, y = 0 }, nil, nil, 4);
    local text_hud = minebase.HUD.functions.newText(text, { x = text:len() * 5, y = 16 * 3 },
        { x = 16 * 2, y = 0 }, text_color, 0, { x = 1, y = 0 }, 1, 2, 5);
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "image", element = img_hud, type = "def" },
        { name = "text", element = text_hud, type = "def" } });
    return container;
end

function minebase.HUD.complex:newEffectBar(player, name, effect_applied, position)

    local bar_hud = minebase.HUD.functions.newImage("minebase_bar_background.png", { x = 1, y = 1 }, { x = 0, y = 0 },
        nil, nil, 3); --Barra
    local square_hud = minebase.HUD.functions.newImage("minebase_icon_square.png", { x = 1.4, y = 1.4 },
        { x = -100, y = 0 }, nil, nil, 4); --Riquadro
    local eff_img_hud = minebase.HUD.functions.newImage(effect_applied.effect.icon, { x = 1.4, y = 1.4 },
        { x = -100, y = 0 }, nil, nil
        , 4); --Effetto
    local _l = effect_applied.effect.amplifiers;
    local txt = effect_applied.effect.name .. " " .. (_l[effect_applied.id_amp] or _l[1]).attr;
    local text_hud = minebase.HUD.functions.newText(txt, { x = txt:len() * 5, y = 16 * 3 },
        { x = 32, y = 0 }, minebase.colors.list.white.dark, 0, { x = -1, y = 0 }, 1.2, nil, 5); --Testo
    local timer_hud = minebase.HUD.functions.newText(minebase.functions.numberToTimer(effect_applied.duration),
        { x = 5 * 5, y = 16 * 3 },
        { x = 60, y = 0 }, minebase.colors.list.red.dark, 1, { x = 1, y = 0 }, 1.2, nil, 5); --Testo
    local container = minebase.HUD.functions.createContainer(player, name, position, { x = 0, y = 0 });
    container:addElements({ { name = "bar", element = bar_hud, type = "def" },
        { name = "square", element = square_hud, type = "def" }, { name = "image", element = eff_img_hud, type = "def" },
        { name = "text", element = text_hud, type = "def" }, { name = "timer", element = timer_hud, type = "def" } });

    return container;
end

function minebase.HUD.complex:newEffectList(player)
    local container = minebase.HUD.functions.createContainer(player, "EFFECT_HUD",
        minebase.screen.p.bottom.right, { x = -128, y = -32 });

    --Abbassa tutti i container
    function container:fixElements(i_rem)
        for i = i_rem, #self.elements do
            local elem = self.elements[i].drawable;
            if elem then
                elem:addOffset(0, 64); --sposta in basso l'hud
            end
        end
    end

    function container:appendEffect(effect_applied)
        local ef_pl = minebase.effects.players[self.owner];
        local y_offset = -(64 * ef_pl.hud_y_multiplyer);
        ef_pl.hud_y_multiplyer = ef_pl.hud_y_multiplyer + 1;
        --effect_applied.effect:exec_effect(self.owner, effect_applied.id_amp);

        local cont = minebase.HUD.complex:newEffectBar(self.owner, "eff_" .. effect_applied.effect.name, effect_applied,
            { x = 1, y = 1 });

        cont:addOffset(0, y_offset);
        container:addElement(cont.name, cont, "container");
        local tx = minebase.HUD.tx;

        cont.datax = {
            dt = effect_applied.duration,
            finish = function()
                cont:delete();
                local rem_id = container:removeElement(cont.name);
                container:fixElements(rem_id);
                ef_pl.hud_y_multiplyer = ef_pl.hud_y_multiplyer - 1;
            end,
            tick = function(me)
                cont:updateElement('timer',
                    { { name = 'text', value = minebase.functions.numberToTimer(me.dt) } });
            end
        }
        tx[#tx + 1] = cont.datax;
    end

    function container:refreshData(effect_applied)
        local cont = self:get("eff_" .. effect_applied.effect.name).drawable;
        cont.datax.dt = effect_applied.duration;
        local text_id = cont:getID('text');
        local _l = effect_applied.effect.amplifiers;
        local txt = effect_applied.effect.name .. " " .. (_l[effect_applied.id_amp] or _l[1]).attr;
        cont:updateElement(text_id,{{name="text",value=txt}});
    end

    function container:removeEffect(effect)

    end

    return container;
end
