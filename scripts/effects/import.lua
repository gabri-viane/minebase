dofile(minetest.get_modpath("minebase_core") .. '/scripts/effects/init.lua');
dofile(minetest.get_modpath("minebase_core") .. "/scripts/effects/effects.lua");

minebase.commands.functions.addCommand(
    "minebase",
    "effect",
    {
        {
            name = 'name',
            type = 'string',
            optional = false
        },
        {
            name = 'time',
            type = 'integer',
            optional = false
        }, {
            name = 'amplifier',
            type = 'integer',
            optional = true
        }
    },
    {},
    function(name, params)
        if params.name then
            local effect = minebase.statics.effects[params.name];
            if effect then
                minebase.api.addEffectToPlayer(minetest.get_player_by_name(name), effect,
                    params.time, params.amplifier);
                if params.time > 0 then
                    return minebase.colors.functions.setTextColor({
                        { text = effect.name, font_color = minebase.statics.colors.sky_blue_light },
                        { text = " has been given to " },
                        { text = name, font_color = minebase.statics.colors.purple_light },
                        { text = " for " .. params.time .. " seconds" }
                    });
                end
                return minebase.colors.functions.setTextColor({
                    { text = effect.name, font_color = minebase.statics.colors.sky_blue_light },
                    { text = " remmved from " },
                    { text = name, font_color = minebase.statics.colors.purple_light }
                });
            else
                return minebase.colors.functions.setTextColor({
                    { text = "Effect <" .. params.name .. "> not found.", font_color = minebase.statics.colors.red_light }
                });
            end
        else
            return minebase.colors.functions.setTextColor({
                { text = "Effect command usage:\n", font_color = minebase.statics.colors.purple_dark },
                { text = "/effect <effect_name> <seconds> <amplifier>\nType " },
                { text = "/minebase effects", font_color = minebase.statics.colors.orange_light },
                { text = " to learn more." }
            });
        end

    end,
    "Add an effect to current player.\nUsage:\t/effect <name> <duration[seconds]> <amplifier>"
);

minebase.effects.functions.getHelp = function()
    local help = {};
    help[#help + 1] = 'MINEBASE EFFECTS\nAdd an effect to current player.\nUsage:\t/effect <name> <duration[seconds]> <amplifier>\n\nIf you set 0 or negative duration then it will remove the effect \n\nHere is a list of available effects:';
    for k, v in pairs(minebase.statics.effects) do
        help[#help + 1] = '\n'
        help[#help + 1] = minebase.colors.functions.setTextColor({ { text = v.name,
            font_color = minebase.statics.colors.violet_light } });
        help[#help + 1] = "=>\tname: "
        help[#help + 1] = minebase.colors.functions.setTextColor({ { text = v.id,
            font_color = minebase.statics.colors.green_light } });
        help[#help + 1] = '\tamplifiers: '
        local ampls = {}
        for id = 1, #v.amplifiers do
            ampls[#ampls + 1] = minebase.colors.functions.setTextColor({ { text = id,
                font_color = minebase.statics.colors.orange_light } });
        end
        help[#help + 1] = table.concat(ampls, ",");
    end
    return table.concat(help);
end;
