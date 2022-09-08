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
            local effect = minebase.effects.list[params.name];
            if effect then
                minebase.effects.functions.add_effect(minetest.get_player_by_name(name), effect, params.amplifier,
                    params.time);
                return minebase.colors.functions.setTextColor({
                    { text = effect.name, font_color = minebase.colors.list.sky_blue.light },
                    { text = " has been given to " },
                    { text = name, font_color = minebase.colors.list.purple.light }
                });
            else
                return minebase.colors.functions.setTextColor({
                    { text = "Effect <" .. params.name .. "> not found.", font_color = minebase.colors.list.red.light }
                });
            end
        else
            return minebase.colors.functions.setTextColor({
                { text = "Effect command usage:\n", font_color = minebase.colors.list.purple.dark },
                { text = "/effect <effect_name> <seconds> <amplifier>\nType " },
                { text = "/minebase effects", font_color = minebase.colors.list.orange.light },
                { text = " to learn more." }
            });
        end

    end,
    "Add an effect to current player.\nUsage:\t/effect <name> <duration[seconds]> <amplifier>"
);

minebase.effects.functions.getHelp = function()
    local help = {};
    help[#help + 1] = 'MINEBASE EFFECTS\nAdd an effect to current player.\nUsage:\t/effect <name> <duration[seconds]> <amplifier>\n\nHere is a list of available effects:';
    for k, v in pairs(minebase.effects.list) do
        help[#help + 1] = '\n'
        help[#help + 1] = minebase.colors.functions.setTextColor({ { text = v.name,
            font_color = minebase.colors.list.violet.light } });
        help[#help + 1] = "=>\tname: "
        help[#help + 1] = minebase.colors.functions.setTextColor({ { text = k,
            font_color = minebase.colors.list.green.light } });
        help[#help + 1] = '\tamplifiers: '
        local ampls = {}
        for id = 1, #v.amplifiers do
            ampls[#ampls + 1] = minebase.colors.functions.setTextColor({ { text = id,
                font_color = minebase.colors.list.orange.light } });
        end
        help[#help + 1] = table.concat(ampls, ",");
    end
    return table.concat(help);
end;
