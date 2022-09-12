minebase.screen.genPoint = function(x, y)
    return { x = x, y = y }
end

minebase.screen = {
    top_left = { x = 0, y = 0 },
    top_center = { x = 0.5, y = 0 },
    top_right = { x = 1, y = 0 },
    center_left = { x = 0, y = 0.5 },
    center_center = { x = 0.5, y = 0.5 },
    center_right = { x = 1, y = 0 },
    bottom_left = { x = 0, y = 1 },
    bottom_center = { x = 0.5, y = 1 },
    bottom_right = { x = 1, y = 1 },
    square = {
        small_s = { x = 4, y = 4 },
        small = { x = 8, y = 8 },
        small_l = { x = 16, y = 16 },
        medium_s = { x = 24, y = 24 },
        medium = { x = 32, y = 32 },
        medium_l = { x = 44, y = 44 },
        large_s = { x = 56, y = 56 },
        large = { x = 64, y = 64 },
        large_l = { x = 72, y = 72 },
    },
    containers = {
        --Lista giocatori
    }
}

function minebase.screen:enableScreen(player)
    self.containers[player] = {
        all = {},
        named = {}
        --left = { --[[0<x<0.25        0.2 < y < 0.8 ]] },
        --right = { --[[ 0.75<x<1       0.2 < y < 0.8]] },
        --top = { --[[0<x<1           0 < y < 0.2]] },
        --center = { --[[0.25<x<0.75     0.2 < y < 0.8]] },
        --bottom = { --[[0<x<1           0.8 < y < 1]] }
    };
end

function minebase.screen:disableScreen(player)
    self.containers[player] = nil;
end

function minebase.screen:get(player, container_name)
    return self.containers[player].named[container_name];
end

function minebase.screen:addToScreen(container)
    if container then
        local player = container.owner;
        local player_screen = self.containers[player];
        local indx = #player_screen.all + 1;
        player_screen.all[indx] = container;
        player_screen.named[container.name] = container;
        container.screen_pos = { minebase.screen:assignToScreen(container), indx };
    end
end

function minebase.screen:removeFromScreen(container)
    local player = container.owner;
    if container.screen_pos then
        local player_screen = self.containers[player];
        player_screen.all[container.screen_pos[2]] = nil;
        player_screen.named[container.name] = nil;
        container.screen_pos = nil;
    end
end

function minebase.screen:assignToScreen(container)
    local lx = container.position.x;
    local ly = container.position.y;
    if ly <= 0.8 and ly >= 0.2 then --IN BASE ALLA Y
        if lx <= 0.25 then --LEFT CONTAINER
            return "left";
        elseif lx >= 0.75 then --RIGHT CONTAINER
            return "right";
        else --CENTER CONTAINER
            return "center";
        end
    else
        if ly > 0.8 then --BOTTOM CONTAINER
            return "bottom";
        else --TOP CONTAINER
            return "top";
        end
    end
end

function minebase.screen:refreshScreen(container)
    --Rimuovo il container rispetto a dove era
    --self.containers[player][container.screen_pos[1]][cont_name] = nil;
    if container.screen_pos then
        container.screen_pos[1] = minebase.screen:assignToScreen(container);
    end
end
