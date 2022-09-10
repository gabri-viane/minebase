minebase.screen.genPoint = function(x, y)
    return { x = x, y = y }
end

minebase.screen = {
    p = { --Points
        top = {
            left = minebase.screen.genPoint(0, 0),
            middle = minebase.screen.genPoint(0.5, 0),
            right = minebase.screen.genPoint(1, 0)
        },
        middle = {
            left = minebase.screen.genPoint(0, 0.5),
            middle = minebase.screen.genPoint(0.5, 0.5),
            right = minebase.screen.genPoint(1, 0.5)
        },
        bottom = {
            left = minebase.screen.genPoint(0, 1),
            middle = minebase.screen.genPoint(0.5, 1),
            right = minebase.screen.genPoint(1, 1)
        }
    },
    d = { --Dimension
        title = { x = 800, y = 800 },
        short_string = { x = 200, y = 50 },
        med_string = { x = 500, y = 50 },
        long_string = { x = 800, y = 50 }
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
    local player = container.owner;
    local player_screen = self.containers[player];
    local indx = #player_screen.all + 1;
    player_screen.all[indx] = container;
    player_screen.named[container.name] = container;
    container.screen_pos = { minebase.screen:assignToScreen(container), indx };
end

function minebase.screen:removeFromScreen(container)
    local player = container.owner;
    local player_screen = self.containers[player];
    player_screen.all[container.screen_pos[2]] = nil;
    player_screen.named[container.name] = nil;
    container.screen_pos = nil;
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

    container.screen_pos[1] = minebase.screen:assignToScreen(container);
end