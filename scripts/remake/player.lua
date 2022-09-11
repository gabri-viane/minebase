minetest.register_on_joinplayer(function(player)
    player:hud_set_hotbar_image("minebase_hotbar_background_9.png");
    player:hud_set_hotbar_itemcount(9);
    player:set_formspec_prepend("");--Cancella il fastidioso background nero delle forms
    --Alzare la barra della vita di qualche pixel di offset
end)
