--[[
    giocatore={
        hud_y_multiplyer=0 
        effects={
            slowness={
                hud_text = id_hud_text,
                hud_image = id_hud_image,
                amplifier = id_amplifier,
                time = lasting_time
            },
            ...
        }
    }
]]

--Appena un giocatore si unisce o muore si occupa di inserirlo nella table $players di minebase.effects
minebase.effects.functions.addEffectsToPlayer = function(player)
    minebase.effects.players[player] = {
        hud_y_multiplyer = 0, --Indica la quantità di hud presenti
        modify_owner = {
            speed = nil,
            jump = nil,
            gravity = nil,
            vision = nil,
            regen = nil
        },
        effects = {
        }
    };
end
--[[
    LISTA DI TUTTI GLI EFFETTI

    Ogni effetto possiede un:
        -id : intero 
            Numero univoco per ogni effetto
        -name : stringa 
            Rappresenta il nome e il testo mostrato nell'hud
        -amplifiers : table
            Contiene a sua volta una table con id interi:
            -id (autogen.) : table
                -attr : stringa
                    Rappresenta il livello dell'effetto da mostrare nell'hud
                -value : float/intero
                    Rappresenta il moltiplicatore dell'effetto per il livello scelto
        -icon : stringa
            Contiene il nome del file immagine dell'icona dell'effetto, server per l'hud
        -exec_effect : funzione
            Chiede il giocatore e l'id dell'amplificatore, si occupa di applicare 
            l'effetto al giocatore e (DEPRECATED:)ritorna una tabella con l'id dell'amplificatore scelto
            e l'amplificatore stesso
        -reset_effect : funzione
            Chiede il giocatore e si occupa di reimpostare il valore di default 
]]
minebase.effects.list = {
    slowness = {
        id = 'slowness',
        owner = "minebase",
        name = 'Slowness',
        amplifiers = {
            { attr = 'I', value = 1, fov = 0.8 },
            { attr = 'II', value = 1.2, fov = 0.6 },
            { attr = 'III', value = 1.5, fov = 0.4 },
            { attr = 'IV', value = 1.7, fov = 0.1 }
        },
        icon = "minebase_slowness_icon.png"
    },
    speed_boost = {
        id = 'speed_boost',
        owner = "minebase",
        name = 'Speed',
        amplifiers = {
            { attr = 'I', value = 1, fov = 1.2 },
            { attr = 'II', value = 1.7, fov = 1.3 },
            { attr = 'III', value = 2.2, fov = 1.35 },
            { attr = 'IV', value = 3.5, fov = 1.4 }
        },
        icon = "minebase_speedness_icon.png"
    },
    jump_boost = {
        id = 'jump_boost',
        owner = "minebase",
        name = 'Jump Boost',
        amplifiers = {
            { attr = 'I', value = 1 },
            { attr = 'II', value = 2.1 },
            { attr = 'III', value = 3.2 },
            { attr = 'IV', value = 4.3 }
        },
        icon = "minebase_jump_boost_icon.png"
    },
    night_vision = {
        id = 'night_vision',
        owner = "minebase",
        name = 'Night Vision',
        amplifiers = {
            { attr = 'I', value = 1 },
            { attr = 'II', value = 1.5 },
            { attr = 'III', value = 2 }
        },
        icon = "minebase_nightvision_icon.png"
    },
    regeneration = {
        id = 'regeneration',
        owner = 'minebase',
        name = 'Regeneration',
        amplifiers = {
            { attr = 'I', value = 1 },
            { attr = 'II', value = 2.1 },
            { attr = 'III', value = 3.2 },
            { attr = 'IV', value = 4.3 },
            { attr = 'V', value = 4.7 }
        },
        icon = "minebase_regeneration_icon.png"
    }
};

function minebase.effects.list.speed_boost:exec_effect(player, id_amplifier)
    id_amplifier = id_amplifier or 1;
    local amplifier = self.amplifiers[id_amplifier] or self.amplifiers[1];
    minebase.effects.players[player].modify_owner.speed = self;
    player:set_fov(amplifier.fov, true, 0.2);
    player:set_physics_override({
        speed = 1.2 ^ amplifier.value;
    });
end

function minebase.effects.list.speed_boost:reset_effect(player)
    if minebase.effects.players[player].modify_owner.speed == self then --Solo se sono l'ultimo posso resettare
        player:set_fov(0, false, 0.2);
        player:set_physics_override({
            speed = 1
        });
    end
end

function minebase.effects.list.slowness:exec_effect(player, id_amplifier)
    local amplifier = self.amplifiers[id_amplifier or 1] or self.amplifiers[1];
    minebase.effects.players[player].modify_owner.speed = self;
    player:set_fov(amplifier.fov, true, 0.5);
    player:set_physics_override({
        speed = 0.7 ^ amplifier.value;
    });
end

function minebase.effects.list.slowness:reset_effect(player)
    if minebase.effects.players[player].modify_owner.speed == self then --Solo se sono l'ultimo posso resettare
        player:set_fov(0, false, 0.5);
        player:set_physics_override({
            speed = 1
        });
    end
end

function minebase.effects.list.jump_boost:exec_effect(player, id_amplifier)
    local amplifier = self.amplifiers[id_amplifier or 1] or self.amplifiers[1];
    minebase.effects.players[player].modify_owner.jump = self;
    player:set_physics_override({
        jump = 1.2 ^ amplifier.value;
    });
end

function minebase.effects.list.jump_boost:reset_effect(player)
    if minebase.effects.players[player].modify_owner.jump == self then --Solo se sono l'ultimo posso resettare
        player:set_physics_override({
            jump = 1
        });
    end
end

function minebase.effects.list.night_vision:exec_effect(player, id_amplifier)
    local amplifier = self.amplifiers[id_amplifier or 1] or self.amplifiers[1];
    minebase.effects.players[player].modify_owner.vision = self;
    player:override_day_night_ratio(0.5 * amplifier.value);
end

function minebase.effects.list.night_vision:reset_effect(player)
    if minebase.effects.players[player].modify_owner.vision == self then --Solo se sono l'ultimo posso resettare
        player:override_day_night_ratio(nil);
    end
end

function minebase.effects.list.regeneration:exec_effect(player, id_amplifier,seconds)
    local amplifier = self.amplifiers[id_amplifier or 1] or self.amplifiers[1];
    minebase.effects.players[player].modify_owner.regen = self;
    minebase.effects.players[player].regen_data = {
        dt = seconds
    }
    --minebase.functions:registerTx
end

function minebase.effects.list.regeneration:reset_effect(player)
    if minebase.effects.players[player].modify_owner.regen == self then --Solo se sono l'ultimo posso resettare

    end
end
