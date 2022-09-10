-- functions
minetest.register_globalstep(function(dtime)
    local tx = minebase.functions.tx;
    if #tx > 0 then
        local rem = {}
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
end);


--SCREEN & HUD
--Giocatore si unisce
minetest.register_on_joinplayer(function(player, last_login)
    minebase.screen:enableScreen(player);
    minebase.HUD.complex:newEffectList(player, 1);
end);
--Giocatore abbandona
minetest.register_on_leaveplayer(function(player, timed_out)
    minebase.screen:disableScreen(player);
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
                el:tick();
            end
        end
    end
    for i = 1, #rem do
        table.remove(tx, rem[i]);
    end
end);

-- EFFECTS
--Giocatore si unisce
minetest.register_on_joinplayer(function(player, last_login)
    minebase.effects.functions.addEffectsToPlayer(player);
end);
--Giocatore respawn
minetest.register_on_respawnplayer(function(player)
    minebase.effects.functions.removeAll(player);
    minebase.effects.functions.addEffectsToPlayer(player);
end)
minetest.register_on_leaveplayer(function(player, timed_out)
    minebase.effects.functions.removeAll(player);
    minebase.effects.players[player] = nil;
end)
