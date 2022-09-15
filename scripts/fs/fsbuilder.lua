function minebase.FS.functions:generateInventory(player_name)
    local tb = {
        "formspec_version[9]",
        "size[8,7.5]",
        "image[1,0.6;1,2;player.png]",
        "list[current_player;main;0,3.5;8,4;]",
        "list[current_player;craft;3,0;3,3;]",
        "list[current_player;craftpreview;7,1;1,1;]",
    }
    minetest.show_formspec(player_name, "minebase:inv_ex_def", tb:concat())
end
