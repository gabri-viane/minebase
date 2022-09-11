--Contains quicks functions and references of @minebase mod
minebase.m = {};

--List of effects available
minebase.m.effects = minebase.effects.list;

--A container can be registered on a player screen.
--If it's registered you can get the container back passing
--the player and the container name.
--@param player The player you want the screen (userdata)
--@param container_name The container you want back (string)
--@returns The container request if exists.
minebase.m.getPlayerScreen = function(player, container_name)
    return minebase.screen:get(player, container_name);
end

--Add effect to a specified player, also handles the HUD
--@param player The player to apply the effect (userdata)
--@param effect The effect to use (from the table: #minebase.m.effects or #minebase.effects.list) (table)
--@param seconds The duration in seconds of the effect applied (number)
--@param amplifier The effect amplifier (a number, if exceeds the max id it's set to 1)
minebase.m.addEffectToPlayer = function(player, effect, seconds, amplifier)
    minebase.effects.functions.add_effect(player, effect, amplifier, seconds);
end

--Remove effect from a specified player, also handles the HUD
--@param player The player to remove the effect (userdata)
--@param effect The effect to remove (from the table: #minebase.m.effects or #minebase.effects.list) (table)
minebase.m.removEffectFromPlayer = function(player, effect)
    minebase.effects.functions.forcr_remove_effect(player, effect);
end

--Remove all effects from a specified player, also handles the HUD
--@param player The player to remove the effects (userdata)
minebase.m.clearEffectsPlayer = function(player)
    minebase.effects.functions.removeAll(player);
end

--Get color definition as a string representetion of the hex color #RGBA (if not found returns black_light)
--@param color_name A color of: (evry color as _light and _dark definition)
--[[
    black_light,black_dark,
    white_light,white_...,
    orange...,red...,
    yellow...,green...,
    sky_blue...,blue...,
    violet...,purple...
]]
--@returns The color requested or black_light
minebase.m.getColor = function(color_name)
    local ps = {};
    for w in color_name:gmatch("([^_]+)") do
        ps[#ps + 1] = w;
    end
    local color_ = ps[1] or 'black';
    local variant_ = ps[2] or 'light';
    ps = nil;
    return minebase.colors.functions.getColorString(color_, variant_);
end

--Add a color to the list #minebase.colors.list, a color can be a string or a function
--@param name The name to get the color back
--@param variant The type of the color
--@pram value A #RGBA string (eg.: "#123456AF") or a function that returns an #RGBA string
minebase.m.addColor = function(name, variant, value)
    minebase.colors.functions.addColor(name, variant, value);
end

--Register a new command
--@param mod_name The name of the mod that is subscribing to this function
--@param command_alias The alias of the command (eg.: /foo , "foo" is the alias)
--@param param_list A specific i-table (the indexes are only ordered numbers) that contains the structure required by the command:
--[[
    {
        {
            name="first_param", --name to get the parameter in the callback_function
            type="string", --or "bool"/"boolean" or "int"/"integer" or hex, this
                           --allows conversion of the parameter befoore
                           --passing it to the callback_function
            optional = true --if true the command fails if the parameter is not passed, 
                            --otherwise it stops and calls the callback_function
        } --,...(as many as you need)
    }
]]
--@param privileges A list of privileges
--@param description A description of the command
minebase.m.addCommand = function(mod_name, command_alias, param_list, callback_function, privileges, description)
    minebase.commands.functions.addCommand(mod_name, command_alias, param_list, privileges, callback_function,
        description);
end
