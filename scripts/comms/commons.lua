dofile(minetest.get_modpath('minebase') .. '/scripts/comms/setup_commons.lua');
dofile(minetest.get_modpath('minebase') .. '/scripts/comms/colors.lua');
dofile(minetest.get_modpath('minebase') .. '/scripts/comms/commands.lua');

minebase.functions.stringToTokens = function(string)
    local ps = {};
    for w in string:gmatch("([%a%d_-]+)") do
        ps[#ps + 1] = w;
    end
    return ps;
end

minebase.functions.convertStringTo = function(from, to)
    if from then
        if to then
            if to == 'int' or to == 'integer' then
                return tonumber(from);
            elseif to == 'hex' then
                return tonumber(from, 16);
            elseif to == 'bool' or to == 'boolean' then
                local stringtoboolean = { ["true"] = true, ["false"] = false, ["0"] = false }; --Il controllo è più veloce così
                return stringtoboolean[from];
            end
        end
        return from;
    else
        return nil;
    end
end

minebase.commands.functions.addCommand("minebase", "minebase", {
    {
        name = "command",
        type = "string",
        optional = true
    }
},
    {},
    function(name, params)
        if params.command then
            if params.command == "effects" then
                return minebase.effects.functions.getHelp();
            end
        end
    end)
