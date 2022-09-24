function minebase.FS.functions:generateInventory(player_name)
    local tb = {
        "formspec_version[6]",
        "size[8,9]",
        "list[context;main;0,0;8,4;]",
        "list[current_player;main;0,5;8,4;]",
    };
    minetest.show_formspec(player_name, "minebase:inv_ex_def", table.concat(tb));
end