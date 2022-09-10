
--SCREEN & HUD
--Giocatore si unisce
minetest.register_on_joinplayer(function(player, last_login)
    minebase.screen:enableScreen(player);
    minebase.HUD.complex:newEffectList(player);
end);
--Giocatore abbandona
minetest.register_on_leaveplayer(function(player, timed_out)
    minebase.screen:disableScreen(player);
end)

minetest.register_globalstep(function(dtime)
    local containers = minebase.screen.containers;
    for _, pl_screen in pairs(containers) do
        for i = 1, #pl_screen.all do
            minebase.HUD.functions.refreshContainer(pl_screen.all[i]);
        end
    end
end)

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