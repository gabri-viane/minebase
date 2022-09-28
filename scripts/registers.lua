-- functions
minetest.register_globalstep(function(dtime)
    local tx = minebase.functions.tx;
    local rem = {};
    if #tx > 0 then
        for i = 1, #tx do
            local el = tx[i];
            if el then
                el.dt = el.dt - dtime;
                if el.dt <= 0 then
                    el:finish();
                    rem[#rem + 1] = i;
                else
                    el:tick();
                end
            end
        end
        for i = 1, #rem do
            table.remove(tx, rem[i]);
        end
    end

    tx = minebase.functions.dx;
    rem = {};
    if #tx > 0 then
        for i = 1, #tx do
            local el = tx[i];
            if el and el:on_tick(dtime) then
                rem[#rem + 1] = i;
                el:on_finish(dtime);
            end
        end
        for i = 1, #rem do
            table.remove(tx, rem[i]);
        end
    end
end);


--SCREEN & HUD
--Giocatore si unisce
minetest.register_on_joinplayer(function(player, last_login)
    minebase.screen:enableScreen(player); --Enable Screen for player
    minebase.HUD.complex:newEffectList(player, 1); --Add effects list to player (empty)
    if minebase.statics.settings.desc_locator then
        minebase.HUD.complex:newPointInfoText(player); --Add info box, when pointing node
    end
    minebase.effects.functions.addEffectsToPlayer(player); --Enable Effects for player
    minebase.storage:loadData(player); --Load player stored data
end);

--Giocatore abbandona
local on_player_leave = function(player, timed_out)
    minebase.storage:savePlayer(player);
    minetest.after(2, function()
        minebase.screen:disableScreen(player);
    end)
end;

minetest.register_on_leaveplayer(on_player_leave)

minetest.register_on_shutdown(function()
    for _, player in ipairs(minetest.get_connected_players()) do
        on_player_leave(player);
    end
end)

--globalstep per aggiornare i componenti grafici
minetest.register_globalstep(function(dtime)
    local containers = minebase.screen.containers;
    for _, pl_screen in pairs(containers) do
        for i = 1, #pl_screen.all do
            minebase.HUD.functions.refreshContainer(pl_screen.all[i]);
        end
    end
end)

--Creo le funzioni base per il lavoro per l'HUD a tempo
minetest.register_globalstep(function(dtime)
    local tx = minebase.HUD.tx;
    local rem = {}
    for i = 1, #tx do
        local el = tx[i];
        if el then
            el.dt = el.dt - dtime;
            if el.dt <= 0 then
                el:finish();
                rem[#rem + 1] = i;
            else
                el:tick(dtime);
            end
        end
    end
    for i = 1, #rem do
        table.remove(tx, rem[i]);
    end
end);

-- EFFECTS
--Giocatore respawn
minetest.register_on_dieplayer(function(player)
    minebase.effects.functions.removeAll(player);
    minebase.effects.functions.addEffectsToPlayer(player);
end)

--minetest.register_on_leaveplayer(function(player, timed_out)
--    minebase.effects.functions.removeAll(player);
--    minebase.effects.players[player] = nil;
--end)
