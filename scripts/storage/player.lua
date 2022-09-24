function minebase.storage:saveEffectsToPlayer(player)
    local player_meta = player:get_meta();
    local effects = {};
    local tmp_eff = minebase.effects.players[player].effects;
    local container = minebase.screen:get(player, "EFFECT_HUD");
    for key, value in pairs(tmp_eff) do
        effects[#effects + 1] = {
            id_amplifier = value.amplifier,
            eff_id = key.id,
            resume_time = container:getElement("eff_" .. key.id).datax.dt
        }
    end
    minebase.effects.players[player] = nil;
    container:delete(); --rimuovi, non c'è bisogno di salvarlo questo.
    player_meta:set_string("effects", minetest.serialize(effects));
end

function minebase.storage:loadEffectsToPlayer(player)
    local effects = minetest.deserialize(player:get_meta():get_string("effects"));
    if effects then
        for i = 1, #effects do
            local content = effects[i];
            minebase.api.addEffectToPlayer(player, minebase.statics.effects[content.eff_id], content.resume_time,
                content.id_amplifier);
        end
    end
end

function minebase.storage:savePlayerHUD(player)
    local indexed_huds = minebase.screen:getAll(player);
    local huds = {};
    for i = 1, #indexed_huds do
        if indexed_huds[i] then
            huds[#huds + 1] = indexed_huds[i]:serialize();
        end
    end
    minebase.storage.s:set_string(player:get_player_name(), minetest.serialize(huds));
end

function minebase.storage:savePlayer(player)
    minebase.storage:beforeSavePlayer(player);
    minebase.storage:saveEffectsToPlayer(player);
    minebase.storage:savePlayerHUD(player);
end

function minebase.storage:loadData(player)
    minebase.storage:loadEffectsToPlayer(player);
    --minetest.log(dump(minetest.deserialize(minebase.storage.s:get_string(player:get_player_name()), true)))
end
