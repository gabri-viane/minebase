--Creo le funzioni base per il lavoro per l'HUD



minebase.HUD.functions.newText = function(text, scale, offset, color, direction, alignment, size, style, z_index)
    return {
        hud_elem_type = "text",
        offset = offset,
        scale = scale,
        text = text,
        direction = direction or 0,
        alignment = alignment or { x = 0, y = 0 },
        size = { x = size or 1, y = 0 },
        style = style or 0,
        number = minebase.colors.functions.colorToHex(color or '000000') ,
        z_index = z_index or 0,
    }
end

minebase.HUD.functions.newImage = function(image, scale, position, offset, color)
    return {
        hud_elem_type = "image",
        position = position,
        offset = offset,
        scale = scale,
        text = image,
        --number = color or 0x000000
    }
end


minebase.HUD.functions.drawContainer = function(container)
    if container and container.to_draw then
        local off = container.offset;
        for i = 1, #container.elements do
            local id = container.elements[i].id;
            if not id then --Non ho ancora disegnato l'oggetto
                local comp = container.elements[i].drawable;
                comp.position = container.position; --Imposto la posizione dell'oggetto
                local off2 = comp.offset;
                comp.offset = { x = off.x + off2.x, y = off.y + off2.y };
                container.elements[i].id = container.owner:hud_add(comp);
            else
                local comp = container.elements[i].drawable;
                if not comp then --Altrimenti se ho l'id ma non ho più l'oggetto lo tolgo dall'hud e dalla lista del container
                    container.owner:remove_hud(comp);
                    container.elements[i] = nil;
                end
            end
        end
    end
end

minebase.HUD.functions.reloadContainerPosition = function(container)
    if container and container.to_draw then
        local off = container.offset;
        for i = 1, #container.elements do
            local id = container.elements[i].id;
            if not id then --Non ho ancora disegnato l'oggetto
                local comp = container.elements[i].drawable;
                local off2 = comp.offset;
                comp.offset = { x = off.x + off2.x, y = off.y + off2.y };
                comp.position = container.position; --Imposto la posizione dell'oggetto
                container.elements[i].id = container.owner:hud_add(comp);
            else
                local comp = container.elements[i].drawable;
                if not comp then --Altrimenti se ho l'id ma non ho più l'oggetto lo tolgo dall'hud e dalla lista del container
                    container.owner:remove_hud(comp);
                    container.elements[i] = nil;
                else
                    comp.position = container.position; --Imposto la nuova posizione dell'oggetto
                    local off2 = comp.offset;
                    comp.offset = { x = off.x + off2.x, y = off.y + off2.y };
                    container.owner:hud_change(id, "position", comp.position);
                    container.owner:hud_change(id, "offset", comp.offset);
                end
            end
        end
    end
end

minebase.HUD.functions.refreshContainer = function(container)
    if container and container.to_refresh then
        for i = 1, #container.elements do
            local elem = container.elements[i];
            if elem.id and elem.refresh and elem.drawable then --Controllo se ha un id, non è segnato da eliminare e ha componenti da fare il refresh
                local player = container.owner;
                for j = 1, #elem.refresh do --per ogni elemento da aggiornare
                    local to_rf = elem.refresh[j];
                    player:hud_change(elem.id, to_rf.name, to_rf.value);
                end
                elem.refresh = nil;
            end
        end
        container.to_refresh = false;
    end
end

minebase.HUD.functions.createContainer = function(player, name, position, offset)
    local container = {
        name = name;
        owner = player;
        position = position,
        offset = offset or { x = 0, y = 0 },
        elements = {},
        named_elements = {},
        to_draw = true,
        to_refresh = false,
        on_elements_exceeded = function()
            --Comprimi container
        end

    };

    function container:setOffset(x, y)
        self.offset = { x = x or self.x, y = y or self.offset.y };
        minebase.HUD.functions.reloadContainerPosition(self);
    end

    function container:get(name)
        return self.elements[self.named_elements[name]];
    end

    function container:getLast()
        return self.elements[#self.elements];
    end

    function container:move(to_position)
        self.position = to_position;
        minebase.HUD.functions.reloadContainerPosition(self);
        minebase.screen:refreshScreen(container);
    end

    --updates= {{type="text",value="Nuovo testo"},{type="number",value=0x00000}} (un array di tabelle valori da aggiornare)
    function container:updateElement(id, updates) --ID della lista del container non dell'elemento creato
        local comp = self.elements[id];
        if comp and comp.drawable then --se esiste il componente con quell'id e esiste anche l'oggetto da aggiornare (non è stato eliminato)
            self.to_refresh = true;
            comp.refresh = updates;
        end
    end

    --Element è un componente minetest da aggiungere all'HUD, non ha bisogno dell'elemento position
    --perchè è ereditato del container a cui viene aggiunto
    --Il nome serve per essere più facilmente accessibile dallo oggetto #minebase.screen
    function container:addElement(name, element)
        local add_indx = #self.elements + 1;
        self.elements[add_indx] = {
            --id = nil, --Non impostato, appena il container viene disegnato viene impostato
            name = name,
            drawable = element
        };
        self.named_elements[name] = add_indx;
        --[[  local res = minebase.HUD.functions.checkContainerDimension(self);
        if res.exceeded then
            self.to_draw = not res.exceeded; --Se eccede le dimensioni imposte non disegnarlo
            self:on_elements_exceeded();
        end ]]
        minebase.HUD.functions.drawContainer(self);
        return add_indx;
    end

    function container:addElements(els)
        local indexes = {}
        for i = 1, #els do
            local add_indx = #self.elements + 1;
            self.elements[add_indx] = {
                --id = nil, --Non impostato, appena il container viene disegnato viene impostato
                name = els[i].name,
                drawable = els[i].element
            };
            self.named_elements[els[i].name] = add_indx;
            indexes[els[i].name] = add_indx;
        end
        minebase.HUD.functions.drawContainer(self);
        return indexes;
    end

    function container:removeElement(id)
        local comp = self.elements[id];
        if comp and comp.drawable then --Se non l'ho ancora segnato da eliminare
            comp.drawable = nil; --Per segnare un elemento da rimuovere gli imposto l'oggetto a nil
        end
    end

    minebase.screen:addToScreen(container);

    return container;
end
