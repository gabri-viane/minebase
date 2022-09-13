--Mostra un'icona in un frame quadrato con un background semi-trasparente grigio
--Ogni elemento è disegnato e gestibile singolarmente
function minebase.HUD.complex:newIconBox(player, name, image, position)
    local bg_square_hud = minebase.HUD.functions.newImage("minebase_icon_square_background.png", { x = 1.4, y = 1.4 },
        { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 3); --Background Riquadro
    local square_hud = minebase.HUD.functions.newImage("minebase_icon_square.png", { x = 1.4, y = 1.4 },
        { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 4); --Riquadro
    local img_hud = minebase.HUD.functions.newImage(image, { x = 1.4, y = 1.4 },
        { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 4); --Effetto
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "background", element = bg_square_hud },
        { name = "square", element = square_hud },
        { name = "image", element = img_hud } });
    return container;
end

--Mostra un'icona in un frame quadrato con un background semi-trasparente grigio
--La T alla fine vuol dire che raggruppa tutto in un unico elemento immagine
function minebase.HUD.complex:newIconBoxT(player, name, image, position, size)
    local icon_hud = minebase.HUD.functions.newImage("(minebase_icon_square_background.png^minebase_icon_square.png^" ..
        image .. ")^[resize:" .. minebase.functions.sizeToString(size or minebase.statics.size.medium_l),
        { x = 1, y = 1 },
        { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 4); --Riquadro+immagine
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "icon", element = icon_hud } });
    return container;
end

function minebase.HUD.complex:newBlockBox(player, name, image, position)
    local bg_square_hud = minebase.HUD.functions.newImage("minebase_icon_square_background.png", { x = 1.4, y = 1.4 },
        { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 3); --Background Riquadro
    local square_hud = minebase.HUD.functions.newImage("minebase_icon_square.png", { x = 1.4, y = 1.4 },
        { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 4); --Riquadro
    local img_hud;
    if type(image) == "table" then
        img_hud = minebase.HUD.functions.newImage("([inventorycube{"
            .. image.top .. "{" .. image.left .. "{" .. image.right .. ")^[resize:32x32)", { x = 1.4, y = 1.4 },
            { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 4); --Effetto
    else
        img_hud = minebase.HUD.functions.newImage("([inventorycube{"
            .. image .. "{" .. image .. "{" .. image .. ")^[resize:32x32)", { x = 1.4, y = 1.4 },
            { x = 0, y = 0 }, nil, { x = 0, y = 0 }, 4); --Effetto
    end

    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "background", element = bg_square_hud },
        { name = "square", element = square_hud },
        { name = "image", element = img_hud } });
    return container;
end

function minebase.HUD.complex:newBlockBoxT(player, name, image, position, size)
    --Background+Riquadro+immagine a forma di blocco
    local tb_icon = {
        "(minebase_icon_square_background.png^minebase_icon_square.png^(([inventorycube{",
        "", --top
        "{",
        "", --left
        "{",
        "", --right
        ")^[resize:32x32))^[resize:",
        minebase.functions.sizeToString(size or minebase.statics.size.medium_l)
    }; --Usando la tabella ottimizzo lua.
    if type(image) == "table" then
        tb_icon[2] = image.top;
        tb_icon[4] = image.left;
        tb_icon[6] = image.right;
    else
        tb_icon[2] = image;
        tb_icon[4] = image;
        tb_icon[6] = image;
    end

    local icon_hud = minebase.HUD.functions.newImage(table.concat(tb_icon), { x = 1, y = 1 }, { x = 0, y = 0 }, nil,
        { x = 0, y = 0 }, 4);
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "icon", element = icon_hud } });
    return container;
end

function minebase.HUD.complex:newEffectBar(player, name, effect_applied, position)
    local bar_hud = minebase.HUD.functions.newImage("minebase_bar_background.png", { x = 1, y = 1 }, { x = 0, y = 0 }
        , nil, { x = -1, y = 0 }, 3); --Barra
    local square_hud = minebase.HUD.functions.newImage("minebase_icon_square.png", { x = 1.4, y = 1.4 },
        { x = -204, y = 0 }, nil, { x = -1, y = 0 }, 4); --Riquadro
    local eff_img_hud = minebase.HUD.functions.newImage(effect_applied.effect.icon, { x = 1.4, y = 1.4 },
        { x = -204, y = 0 }, nil, { x = -1, y = 0 }, 4); --Effetto
    local _l = effect_applied.effect.amplifiers;
    local txt = table.concat({ effect_applied.effect.name, " ", (_l[effect_applied.id_amp] or _l[1]).attr });

    local text_hud = minebase.HUD.functions.newText(txt, { x = 150, y = 48 },
        { x = -200, y = 0 }, minebase.statics.colors.white_light, 0, { x = 1, y = 0 }, 1.2, nil, 5); --Testo

    local timer_hud = minebase.HUD.functions.newText(minebase.functions.numberToTimer(effect_applied.duration),
        { x = 30, y = 48 },
        { x = -16, y = 0 }, minebase.statics.colors.white_dark, 1, { x = -1, y = 0 }, 1.2, nil, 5); --Timer
    local container = minebase.HUD.functions.createContainer(player, name, position, { x = 0, y = 0 });
    container:addElements({ { name = "bar", element = bar_hud },
        { name = "square", element = square_hud }, { name = "image", element = eff_img_hud },
        { name = "text", element = text_hud }, { name = "timer", element = timer_hud } });

    return container;
end

function minebase.HUD.complex:newEffectBarT(player, name, effect_applied, position)

    local v = table.concat(
        { "[combine:256x56:0,0=minebase_bar_background.png:6,4=\\(\\(minebase_icon_square.png\\^",
            effect_applied.effect.icon, "\\)\\^[resize\\:48x48\\)" }
    );
    local bar_hud = minebase.HUD.functions.newImage(v, { x = 1, y = 1 }, { x = 0, y = 0 }, nil, { x = -1, y = 0 }, 3); --Barra+Riquadro+Icona
    local _l = effect_applied.effect.amplifiers;
    local txt = table.concat({ effect_applied.effect.name, " ", (_l[effect_applied.id_amp] or _l[1]).attr });
    local text_hud = minebase.HUD.functions.newText(txt, { x = 150, y = 48 },
        { x = -200, y = 0 }, minebase.statics.colors.white_light, 0, { x = 1, y = 0 }, 1.2, nil, 5); --Testo

    local timer_hud = minebase.HUD.functions.newText(minebase.functions.numberToTimer(effect_applied.duration),
        { x = 30, y = 48 },
        { x = -16, y = 0 }, minebase.statics.colors.white_dark, 1, { x = -1, y = 0 }, 1.2, nil, 5); --Timer
    local container = minebase.HUD.functions.createContainer(player, name, position, { x = 0, y = 0 });
    container:addElements({ { name = "base", element = bar_hud },
        { name = "text", element = text_hud }, { name = "timer", element = timer_hud } });

    return container;
end

--direction a -1 gli elementi vengono aggiunti verso il basso, con 1 verso l'altro
function minebase.HUD.complex:newEffectList(player, direction, position)
    local container = minebase.HUD.functions.createContainer(player, "EFFECT_HUD",
        position or minebase.statics.screen.bottom_right, { x = 0, y = -32 });
    container.as = "effect_list";
    container.direction = direction or 1;
    --registro il container sullo schermo
    container:registerToScreen();
    --Abbassa tutti i container
    function container:fixElements(i_rem)
        for i = i_rem, #self.elements do
            local elem = self.elements[i].drawable;
            if elem then
                elem:addOffset(0, self.direction * 64); --sposta in basso l'hud
            end
        end
    end

    function container:appendEffect(effect_applied)
        local ef_pl = minebase.effects.players[self.owner];
        local y_offset = -self.direction * (64 * ef_pl.hud_y_multiplyer);
        ef_pl.hud_y_multiplyer = ef_pl.hud_y_multiplyer + 1;

        local cont = minebase.HUD.complex:newEffectBarT(self.owner, "eff_" .. effect_applied.effect.id, effect_applied,
            container.position);

        cont:addOffset(0, y_offset);
        container:addElement(cont.name, cont);
        local tx = minebase.HUD.tx;

        cont.datax = {
            dt = effect_applied.duration,
            finish = function()
                local el = container:removeElement(cont.name);
                if el then
                    local rem_id = el.id;
                    cont:delete();
                    if rem_id then
                        container:fixElements(rem_id);
                        ef_pl.hud_y_multiplyer = ef_pl.hud_y_multiplyer - 1;
                    end
                end
            end,
            tick = function(me)
                cont:updateElement('timer',
                    { { name = 'text', value = minebase.functions.numberToTimer(me.dt) } });
            end
        }
        tx[#tx + 1] = cont.datax;
    end

    function container:refreshData(effect_applied)
        local el = self:getElement("eff_" .. effect_applied.effect.id);
        if el then
            el.datax.dt = effect_applied.duration;
            local text_id = el:getID('text');
            local _l = effect_applied.effect.amplifiers;
            local txt = table.concat({ effect_applied.effect.name, " ", (_l[effect_applied.id_amp] or _l[1]).attr });
            el:updateElement(text_id, { { name = "text", value = txt } });
        end
    end

    function container:removeEffect(effect)
        local el = self:getElement("eff_" .. effect.id);
        if el then
            el.datax.dt = 0;
        end
    end

    return container;
end

function minebase.HUD.complex:newBoxBorderT(player, name, position, width, height)
    local line_w = (width or 2) * 10;
    local line_h = (height or 2) * 10;
    local bar_w = line_w + 4 * 2; --4*2 = due angoli da 4px
    local bar_h = line_h + 4 * 1; --4*1 = un solo angolo angoli da 4px
    local border_t = table.concat(
        {
            "[combine:", bar_w, "x", (bar_h + 4), ":",
            --Parte linea bordo superiore
            "0,0=minebase_corner_bar_border.png:", --spigolo sinistro
            "4,0=\\(minebase_line_bar_border.png\\^[resize\\:", line_w, "x4\\):", --linea orizzontale
            (line_w + 4), ",0=\\(minebase_corner_bar_border.png\\^[transformFX\\):", --spigolo destro
            --Parte linea bordo inferiore
            "0,", (bar_h), "=\\(minebase_corner_bar_border.png\\^[transformFY\\):", --spigolo sinistro
            "4,", (bar_h), "=\\(minebase_line_bar_border.png\\^[transformFY\\^[resize\\:", line_w, "x4\\):", --linea orizzontale
            (line_w + 4), ",", (bar_h), "=\\(minebase_corner_bar_border.png\\^[transformFYFX\\):", --spigolo destro
            --Parte linea sinistra
            "0,4=\\(minebase_v_line_bar_border.png\\^[resize\\:4x", line_h, "\\):", --linea verticale
            --Parte linea destra
            (line_w + 4), ",4=\\(minebase_v_line_bar_border.png\\^[resize\\:4x", line_h, "\\^[transformFX\\)" --linea verticale
        }
    )
    --Background+Riquadro+immagine a forma di blocco
    local border = minebase.HUD.functions.newImage(border_t, { x = 1, y = 1 }, { x = 0, y = 0 }, nil, { x = 1, y = 1 }, 4);
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "border", element = border } });
    return container;
end

function minebase.HUD.complex:newBoxT(player, name, position, width, height)
    local line_w = (width or 2) * 10;
    local line_h = (height or 2) * 10;
    local bar_w = line_w + 4 * 2; --4*2 = due angoli da 4px
    local bar_h = line_h + 4 * 1; --4*1 = un solo angolo angoli da 4px
    local box_t = table.concat({
        "[combine:", bar_w, "x", (bar_h + 4), ":",
        --background
        "4,4=minebase_bg_base.png\\^[resize\\:", line_w, "x", line_h, ":",
        --Parte linea bordo superiore
        "0,0=minebase_corner_bar_border.png:", --spigolo sinistro
        "4,0=\\(minebase_line_bar_border.png\\^[resize\\:", line_w, "x4\\):", --linea orizzontale
        (line_w + 4), ",0=\\(minebase_corner_bar_border.png\\^[transformFX\\):", --spigolo destro
        --Parte linea bordo inferiore
        "0,", (bar_h), "=\\(minebase_corner_bar_border.png\\^[transformFY\\):", --spigolo sinistro
        "4,", (bar_h), "=\\(minebase_line_bar_border.png\\^[transformFY\\^[resize\\:", line_w, "x4\\):", --linea orizzontale
        (line_w + 4), ",", (bar_h), "=\\(minebase_corner_bar_border.png\\^[transformFYFX\\):", --spigolo destro
        --Parte linea sinistra
        "0,4=\\(minebase_v_line_bar_border.png\\^[resize\\:4x", line_h, "\\):", --linea verticale
        --Parte linea destra
        (line_w + 4), ",4=\\(minebase_v_line_bar_border.png\\^[resize\\:4x", line_h, "\\^[transformFX\\)" --linea verticale
    });
    local box = minebase.HUD.functions.newImage(box_t, { x = 1, y = 1 }, { x = 0, y = 0 }, nil, { x = 1, y = 1 }, 4); --Background+Riquadro+immagine a forma di blocco
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "box", element = box } });
    return container;
end

function minebase.HUD.complex:newTextBoxT(player, name, position, width, height, title, title_color, text, text_color)
    local line_w = (width or 2) * 10;
    local line_h = (height or 2) * 10;
    local bar_w = line_w + 4 * 2; --4*2 = due angoli da 4px
    local bar_h = line_h + 4 * 1; --4*1 = un solo angolo angoli da 4px
    local box_t = table.concat({
        "[combine:", bar_w, "x", (bar_h + 4), ":",
        --background
        "4,4=minebase_bg_base.png\\^[resize\\:", line_w, "x", line_h, ":",
        --Parte linea bordo superiore
        "0,0=minebase_corner_bar_border.png:", --spigolo sinistro
        "4,0=\\(minebase_line_bar_border.png\\^[resize\\:", line_w, "x4\\):", --linea orizzontale
        (line_w + 4), ",0=\\(minebase_corner_bar_border.png\\^[transformFX\\):", --spigolo destro
        --Parte linea bordo inferiore
        "0,", (bar_h), "=\\(minebase_corner_bar_border.png\\^[transformFY\\):", --spigolo sinistro
        "4,", (bar_h), "=\\(minebase_line_bar_border.png\\^[transformFY\\^[resize\\:", line_w, "x4\\):", --linea orizzontale
        (line_w + 4), ",", (bar_h), "=\\(minebase_corner_bar_border.png\\^[transformFYFX\\):", --spigolo destro
        --Parte linea sinistra
        "0,4=\\(minebase_v_line_bar_border.png\\^[resize\\:4x", line_h, "\\):", --linea verticale
        --Parte linea destra
        (line_w + 4), ",4=\\(minebase_v_line_bar_border.png\\^[resize\\:4x", line_h, "\\^[transformFX\\)" --linea verticale
    });
    local box_hud = minebase.HUD.functions.newImage(box_t, { x = 1, y = 1 }, { x = 0, y = 0 }, nil, { x = 1, y = 1 }, 4); --Background+Riquadro+immagine a forma di blocco
    local title_hud = minebase.HUD.functions.newText(title, { x = line_w, y = 20 }, { x = bar_w / 2, y = 16 },
        title_color, nil, { x = 0, y = 0 }, 1.5, 1, 5);
    local warp_text = minebase.functions.warpString(text, (line_w - 20) / 7)[1];
    local text_hud = minebase.HUD.functions.newText(warp_text, { x = line_w - 20, y = line_h - 24 }, { x = 10, y = 36 },
        text_color, nil, { x = 1, y = 1 }, 1.1, nil, 5);
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container:addElements({ { name = "box", element = box_hud, type = "def" },
        { name = "title", element = title_hud, type = "def" },
        { name = "text", element = text_hud, type = "def" } });
    return container;
end

function minebase.HUD.complex:newList(player, name, position, spacing, rules)
    local container = minebase.HUD.functions.createContainer(player, name, position);
    container.as = "list";

    container.datax = {
        direction = minebase.statics.directions.right; --Direzione:y? -1=alto:1=basso   x? -1=sinistra,1=destra
        expandable = false, --Se true allora guarda expand_limit per sapere dopo quanti elementi iniziare ad un'altro offset
        expand_limit = 5,
        expand_direction = minebase.statics.directions.down, --Direzione: y? -1=alto,1=basso    x? -1=sinistra,1=destra
        last_index = 0,
        row_index = 0,
        spacing = spacing or 10,
        v_spacing = 10
    };

    if rules then
        local dx = container.datax;
        dx.direction = rules.direction or dx.direction;
        dx.expandable = rules.expandable or false;
        dx.expand_limit = rules.expand_limit or dx.expand_limit;
        dx.expand_direction = rules.expand_direction or dx.expand_direction;
        dx.v_spacing = rules.v_spacing or dx.v_spacing;
    end

    if container.datax.expandable then
        function container:listAdd(el)
            local to_add;
            local dx = self.datax;
            local dir = dx.direction;
            local ex_dir = dx.expand_direction;

            local colonna = dx.last_index % dx.expand_limit;
            if dx.last_index > 1 and colonna == 0 then
                dx.row_index = dx.row_index + 1;
            end
            local x = dir.x * dx.spacing * colonna + ex_dir.x * dx.v_spacing * dx.row_index;
            local y = dir.y * dx.spacing * colonna + ex_dir.y * dx.v_spacing * dx.row_index;
            dx.last_index = dx.last_index + 1;
            if el.element.type == "container" then
                el.element:addOffset(x, y);
                to_add = el.element;
            elseif el.element.type == "def" then
                to_add = minebase.HUD.functions.createLightContainer(player, el.name, nil,
                    { x = x, y = y }, el.element);
            end
            self:addElement(el.name, to_add);
        end

        function container:listRemove(nm)
            local removed = container:removeElement(nm);
            if removed then
                if removed.element then
                    removed.element.drawable:delete(); --So per certo che è un container
                end
                container:fixElements(removed.id);
            end
        end

        function container:fixElements(i_rem)
            local dx = self.datax;
            local dir = dx.direction;
            local ex_dir = dx.expand_direction;

            --numero colonna da cui l'ho rimosso
            -- i_rem=id : corrisponde alla posizione nella lista e quindi al suo posizionamento
            --i_rem % dx.expand_limit : corrisponde alla posizione nella riga, dove 0==primo elemento e dx.expand_limit-1 == ultimo elemento
            local row_pos = (i_rem % dx.expand_limit); --+ 1 perchè se è 0 allora è il primo elemento di una colonna
            -- i_rem-(row_) : corrisponde a il numero di elementi che completano "completamente" (che riempiono dx.expand_limit) le colonne prima di sé
            -- /dx.expand_limit : per sapere quante colonne prima ci sono
            --local col_ = (i_rem - row_pos) / dx.expand_limit;

            --Rimuovo 1 dall'indice
            dx.last_index = dx.last_index - 1;
            --Per calcolare di quanto va mosso l'elemento nella stessa colonna ma riga diversa
            --devo solamente sottrarre la direzione di aggiunta normale della lista,
            --per sapere se lo devo spostare anche di colonna devo vedere se si trova in una colonna successiva
            --devo quindi contare quanti elementi sto spostando:
            --parto dal vedere a che riga sono ora,
            --dopo che so a che riga sono calcolo se sono in un nuovo indice di colonna facendo row_%dx.expand_limit,
            --se == 0 allora devo anche spostarmi indietro di una colonna
            --Lo spostamento massimo sulla riga è di dx.expand_limit
            --e lo spostamento massimo sulle colonne è 1 per elemento: e corrisponde a 1 colonna indietro e una somma massima di riga

            local moved = 0;
            local m;
            local mx = 0;
            for i = i_rem, #self.elements do
                moved = moved + 1;
                local elem = self.elements[i].drawable;
                if elem then
                    --La i corrisponde all'indice corrente, se i = i_rem allora sono il primo elemento
                    --dopo quello rimosso: devo vedere se quello rimosso era il primo della riga
                    row_pos = i % dx.expand_limit; --Per il primo il calcolo non cambia il valore
                    if row_pos == 0 then --Se era il primo elemento nella riga allora devo sottrarre una colonna all'elemento
                        m = 1; --l'elemento è da spostare nella colonna precedente
                        mx = mx + 1;
                    else
                        m = 0; --l'elemento è da lasciare nella stessa colonna
                    end
                    --Se m=1 vuol dire che cambio colonna: +massima riga -1 colonna
                    --Se m=0 vuol dire che cambio riga: -1 riga
                    local r = (1 - m + (-(dx.expand_limit - 1) * m));
                    --              RIGA                         COLONNA
                    local x = -dir.x * dx.spacing * r + -ex_dir.x * dx.v_spacing * m; -- -riga + -colonna
                    local y = -dir.y * dx.spacing * r + -ex_dir.y * dx.v_spacing * m;
                    elem:addOffset(x, y); --sposta in l'hud
                end
            end
            --Ricalcolo il numero della colonna
            dx.row_index = math.floor((#self.elements - (#self.elements%dx.expand_limit)) / dx.expand_limit);
        end
    else
        --Deve essere passato el:{name=...,element=...}
        function container:listAdd(el)
            local to_add;
            local dx = self.datax;
            local dir = dx.direction;
            dx.last_index = dx.last_index + 1;
            if el.element.type == "container" then
                el.element:addOffset(dir.x * dx.spacing * dx.last_index, dir.y * dx.spacing *
                    dx.last_index);
                to_add = el.element;
            elseif el.element.type == "def" then
                to_add = minebase.HUD.functions.createLightContainer(player, el.name, nil,
                    { dir.x * dx.spacing * dx.last_index, dir.y * dx.spacing * dx.last_index },
                    el.element)
            end
            self:addElement(el.name, to_add);
        end

        function container:listRemove(name)
            self.datax.last_index = self.datax.last_index - 1;
            local removed = container:removeElement(name);
            if removed then
                if removed.element then
                    removed.element.drawable:delete();
                end
                container:fixElements(removed.id);
            end
        end

        function container:fixElements(i_rem)
            local dir = self.datax.direction;
            for i = i_rem, #self.elements do
                local elem = self.elements[i].drawable;
                if elem then
                    elem:addOffset(-dir.x * self.datax.spacing, -dir.y * self.datax.spacing); --sposta in l'hud
                end
            end
        end
    end

    return container;
end
