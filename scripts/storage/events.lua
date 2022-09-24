local bfsp_funx = {}

function minebase.storage:on_beforeSavePlayer(BSfunction)
    bfsp_funx[#bfsp_funx + 1] = BSfunction;
end

function minebase.storage:beforeSavePlayer(player, ...)
    for i = 1, #bfsp_funx do
        bfsp_funx[i](player, ...);
    end
end
