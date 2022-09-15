--Creo lo spazio di lavoro per gli elementi statici
minebase.statics = {
    screen = {
        top_left = { x = 0, y = 0 },
        top_center = { x = 0.5, y = 0 },
        top_right = { x = 1, y = 0 },
        center_left = { x = 0, y = 0.5 },
        center_center = { x = 0.5, y = 0.5 },
        center_right = { x = 1, y = 0 },
        bottom_left = { x = 0, y = 1 },
        bottom_center = { x = 0.5, y = 1 },
        bottom_right = { x = 1, y = 1 }
    },
    size = {
        small_s = { x = 4, y = 4 },
        small = { x = 8, y = 8 },
        small_l = { x = 16, y = 16 },
        medium_s = { x = 24, y = 24 },
        medium = { x = 32, y = 32 },
        medium_l = { x = 44, y = 44 },
        large_s = { x = 56, y = 56 },
        large = { x = 64, y = 64 },
        large_l = { x = 72, y = 72 }
    },
    directions = {
        up = { x = 0, y = -1 },
        down = { x = 0, y = 1 },
        right = { x = 1, y = 0 },
        left = { x = -1, y = 0 },
        up_left = { x = -1, y = -1 },
        up_right = { x = 1, y = -1 },
        down_right = { x = 1, y = 1 },
        down_left = { x = -1, y = 1 }
    },
    colors = {
        red_text = 0xFF0000,
        red_light = '#FF0000FF',
        red_dark = '#B20000FF',

        orange_text = 0xFFA500,
        orange_light = '#FFA500FF',
        orange_dark = '#B27300FF',

        yellow_text = 0xFFFF00,
        yellow_light = '#FFFF00FF',
        yellow_dark = '#B2B200FF',

        green_text = 0x8fce00,
        green_light = '#8fce00ff',
        green_dark = '#5b8300ff',

        sky_blue_text = 0x2986cc,
        sky_blue_light = '#2986ccff',
        sky_blue_dark = '#206ba3ff',

        blue_text = 0x0000cc,
        blue_light = '#0000ccff',
        blue_dark = '#00008eff',

        violet_text = 0xee82ee,
        violet_light = '#ee82eeff',
        violet_dark = '#a65ba6ff',

        purple_text = 0x800080,
        purple_light = '#800080ff',
        purple_dark = '#660066ff',

        white_text = 0xe5e5e5,
        white_light = '#ffffffff',
        white_dark = '#e5e5e5ff',

        black_text = 0x191919,
        black_light = '#191919ff',
        black_dark = '#000000ff'
    }
};

--Contiente tutte le funzioni di utilizzo vario
minebase.functions = {};
minebase.functions.tx = {};

--Contiene tutti i dati sui colori
minebase.colors = {};
minebase.colors.functions = {};

minebase.screen = {};

minebase.commands = {};
minebase.commands.functions = {};
minebase.commands.list = {};

--Conntiene tutti i dati riguardo la gestione HUD
minebase.HUD = {};
minebase.HUD.functions = {};
minebase.HUD.complex = {};
minebase.HUD.tx = {};
minebase.HUD.animations = {};

--Conntiene tutti i dati riguardo la gestione Formspec
minebase.FS = {};
minebase.FS.functions = {};
minebase.FS.complex = {};

--Contiene tutti i dati sugli effetti
minebase.effects = {};
minebase.effects.functions = {};
minebase.effects.list = {};
minebase.effects.players = {};