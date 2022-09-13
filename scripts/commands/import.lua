dofile(minetest.get_modpath("minebase") .. "/scripts/commands/commands.lua");

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