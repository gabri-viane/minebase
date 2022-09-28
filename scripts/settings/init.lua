local settings = Settings(minetest.get_modpath("minebase") .. "/minebase.conf");
minebase.statics.settings = {
    desc_locator = settings:get_bool("desc_loc", true), --Aggiungi a HUD l'infotext
    looking_at_precision = tonumber(settings:get("look_at_p") or 50) --Precisione puntatore nodi
}
