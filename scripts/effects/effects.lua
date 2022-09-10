dofile(minetest.get_modpath("minebase") .. '/scripts/effects/setup_effects.lua');
dofile(minetest.get_modpath("minebase") .. '/scripts/effects/adv_effects.lua');

--[[
    Controlla se un effetto è presente per un giocatore dentro la lista
    
    minebase.effects.players.[giocatore].effects

    Nel caso è presente ritorna la chiave, altrimenti ritorna false
]]
minebase.effects.functions.isEffectPresent = function(player, effect)
    if player ~= nil then
        for key, _ in pairs(minebase.effects.players[player].effects) do
            if key == effect then return { toadd = false, key = key } end
        end
        return { toadd = true };
    end
    return { toadd = false, key = nil };
end

--Sposta se presenti le ulteriori HUD nelle nuove posizioni
minebase.effects.functions.refreshHUDPosition = function(player)
    if player ~= nil then
        local player_comp = minebase.effects.players[player];
        local y_position = -30;
        for _, data in pairs(player_comp.effects) do
            player:hud_change(data.hud_text, "offset", { x = -90, y = y_position });
            player:hud_change(data.hud_image, "offset", { x = -170, y = y_position });
            y_position = y_position - 50;
        end
    end
end

minebase.effects.functions.refreshHUDEffectData = function(player, effect)
    if player ~= nil then
        local player_comp = minebase.effects.players[player];
        local data = player_comp.effects[effect]
        player:hud_change(data.hud_text, "text",
            effect.name .. " " .. (effect.amplifiers[data.amplifier] or effect.amplifiers[1]).attr);
    end
end

minebase.effects.functions.removeAll = function(player)
    if player ~= nil then
        local player_comp = minebase.effects.players[player];
        for key, data in pairs(player_comp.effects) do
            if data then
                player:hud_remove(data.hud_text);
                player:hud_remove(data.hud_image);
                data.job:cancel();
            end
            key:reset_effect(player);
            player_comp.effects[key] = nil;
        end
    end
end

minebase.effects.functions.add_effect = function(player, effect, id_amplifier, seconds, tx_index)
    if effect then
        local control_result = minebase.effects.functions.isEffectPresent(player, effect);
        if control_result.toadd then


            local container = minebase.screen:get(player, "EFFECT_HUD");
            container:appendEffect({ effect = effect, id_amp = id_amplifier, duration = seconds });

            --Eseguo la funzione dell'effetto
            effect:exec_effect(player, id_amplifier);

            --Imposto il timer per rimuovere la HUD
            local job = minetest.after(seconds,
                function()
                    minebase.effects.functions.remove_effect(player, effect);
                end
            );

            --Aggiungo l'effetto al giocatore (vedi in setup_effects.lua)
            minebase.effects.players[player].effects[effect] = {
                amplifier = id_amplifier,
                time = seconds,
                job = job
            };
        elseif control_result.key then
            --[[
            Altrimenti fai in modo di reimpostare i secondi
            all'effetto già presente
        ]]
            local effect_data = minebase.effects.players[player].effects[effect];
            if effect_data.amplifier == id_amplifier then --Se l'effetto è dello stesso livello imposta il nuovo tempo
                effect_data.job:cancel();
                local container = minebase.screen:get(player, "EFFECT_HUD");
                container:refreshData({ effect = effect, duration = seconds, id_amp = id_amplifier });
                effect_data.job = minetest.after(seconds,
                    function()
                        minebase.effects.functions.remove_effect(player, effect);
                    end
                );
            elseif effect_data.amplifier < id_amplifier then --Altrimenti annulla l'effetto precedente e metti quello nuovo
                effect_data.job:cancel();
                effect_data.amplifier = id_amplifier;

                local container = minebase.screen:get(player, "EFFECT_HUD");
                container:refreshData({ effect = effect, duration = seconds, id_amp = id_amplifier });

                effect:exec_effect(player, id_amplifier);
                --minebase.effects.functions.refreshHUDEffectData(player, effect);
                effect_data.job = minetest.after(seconds,
                    function()
                        minebase.effects.functions.remove_effect(player, effect);
                    end
                );

            end
        end
    end
end

minebase.effects.functions.remove_effect = function(player, effect)
    --Seleziona il giocatore
    local player_comp = minebase.effects.players[player];
    if player_comp then
        local eff = player_comp.effects[effect];
        if eff then
            --Rimuovi gli HUD
            --player:hud_remove(eff.hud_text);
            -- player:hud_remove(eff.hud_image);
            --Imposta l'effetto a nullo
            player_comp.effects[effect] = nil;
            eff = nil;
            --Sottrai alla y
            --player_comp.hud_y_multiplyer = player_comp.hud_y_multiplyer - 1;
            --Reset dell'effetto
            effect:reset_effect(player);
            --Refresh dell'HUD
            --minebase.effects.functions.refreshHUDPosition(player);
        end
    end
end
