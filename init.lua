---@diagnostic disable-next-line: lowercase-global
minebase = {};
minebase.scripts = minetest.get_modpath("minebase") .. '/scripts';


dofile(minebase.scripts.."/comms/import.lua");
dofile(minebase.scripts.."/settings/init.lua");

dofile(minebase.scripts.."/utils/import.lua");
dofile(minebase.scripts.."/remake/import.lua");

dofile(minebase.scripts.."/commands/import.lua");
dofile(minebase.scripts.."/HUD/import.lua");
dofile(minebase.scripts.."/fs/import.lua");
dofile(minebase.scripts.."/effects/import.lua");
dofile(minebase.scripts.."/storage/import.lua");

dofile(minebase.scripts.."/registers.lua");
dofile(minebase.scripts.."/api.lua");

dofile(minebase.scripts.."/testing.lua");

return minebase.api;
