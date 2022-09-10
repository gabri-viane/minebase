minebase.HUD.functions.newText = function(text, scale, offset, color, direction, alignment, size, style, z_index)
    return {
        hud_elem_type = "text",
        base_offset = offset,
        offset = offset,
        scale = scale,
        text = text,
        direction = direction or 0,
        alignment = alignment or { x = 0, y = 0 },
        size = { x = size or 1, y = 0 },
        style = style or 0,
        number = minebase.colors.functions.colorToHex(color or '000000'),
        z_index = z_index or 0,
    }
end

minebase.HUD.functions.newImage = function(image, scale, offset, direction, alignment, z_index)
    return {
        hud_elem_type = "image",
        base_offset = offset,
        offset = offset,
        direction = direction or 0,
        alignment = alignment or { x = 0, y = 0 },
        scale = scale,
        text = image,
        z_index = z_index or 0,
    }
end


minebase.HUD.functions.drawContainer = function(container)
    if container and container.to_draw then
        local off = container.offset;
        for i = 1, #container.elements do
            if container.elements[i].type == 'def' then
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
            else
                local inner_container = container.elements[i].drawable;
                inner_container:move(container.position);
            end
        end
    end
end

minebase.HUD.functions.removeContainer = function(container)
    if container then
        for i = 1, #container.elements do
            if container.elements[i].type == 'def' then --è un oggetto disegnabile
                local id = container.elements[i].id;
                container.owner:hud_remove(id);
            elseif container.elements[i].type == 'container' then
                minebase.HUD.functions.removeContainer(container.elements[i].drawable);
            end
        end
        container.elements = nil;
        --minetest.chat_send_all(dump(container));
        minebase.screen:removeFromScreen(container);
    end
end

minebase.HUD.functions.reloadContainerPosition = function(container)
    if container and container.to_draw then
        for i = 1, #container.elements do
            if container.elements[i].type == 'def' then --è un oggetto disegnabile
                local id = container.elements[i].id;
                if not id then --Non ho ancora disegnato l'oggetto
                    local comp = container.elements[i].drawable;
                    comp.position = container.position; --Imposto la posizione dell'oggetto
                    container.elements[i].id = container.owner:hud_add(comp);
                else
                    local comp = container.elements[i].drawable;
                    if not comp then --Altrimenti se ho l'id ma non ho più l'oggetto lo tolgo dall'hud e dalla lista del container
                        container.owner:remove_hud(comp);
                        container.elements[i] = nil;
                    else
                        comp.position = container.position; --Imposto la nuova posizione dell'oggetto
                        container.owner:hud_change(id, "position", comp.position);
                    end
                end
            else
                local inner_container = container.elements[i].drawable;
                inner_container:move(container.position);
            end
        end
    end
end

minebase.HUD.functions.reloadContainerOffsets = function(container, add_offset)
    if container and container.to_draw then
        local to_add = container.offset;
        for i = 1, #container.elements do
            local el = container.elements[i];
            if el.type == 'def' then
                if el.id then
                    local new_offset = { x = el.drawable.base_offset.x + to_add.x,
                        y = el.drawable.base_offset.y + to_add.y };
                    el.drawable.offset = new_offset;
                    container.owner:hud_change(el.id, "offset", new_offset);
                end
            elseif el.type == 'container' then
                el.drawable:addOffset(add_offset.x, add_offset.y);
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

    function container:addOffset(x, y)
        self.offset = { x = self.offset.x + x, y = self.offset.y + y };
        minebase.HUD.functions.reloadContainerOffsets(self, { x = x, y = y });
    end

    function container:get(nm)
        return self.elements[container:getID(nm)];
    end

    function container:getID(nm)
        for i = 1, #self.elements do
            if self.elements[i].name == nm then
                return i;
            end
        end
        return 0;
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
    function container:updateElement(nm, updates) --ID della lista del container non dell'elemento creato
        local id = self:getID(nm);
        local comp = self.elements[id];
        if comp and comp.drawable then --se esiste il componente con quell'id e esiste anche l'oggetto da aggiornare (non è stato eliminato)
            self.to_refresh = true;
            comp.refresh = updates;
        end
    end

    --Element è un componente minetest da aggiungere all'HUD, non ha bisogno dell'elemento position
    --perchè è ereditato del container a cui viene aggiunto
    --Il nome serve per essere più facilmente accessibile dallo oggetto #minebase.screen
    function container:addElement(nm, element, type)
        self.elements[#self.elements + 1] = {
            --id = nil, --Non impostato, appena il container viene disegnato viene impostato
            name = nm,
            type = type or 'def',
            drawable = element,
        };
        if type == 'container' then
            element:addOffset(self.offset.x, self.offset.y);
        end
        --self:updateElement(nm,
        --  { { name = "offset", value = { x = element.offset.x + self.offset.x, y = element.offset.y + self.offset.y } } });
        --[[  local res = minebase.HUD.functions.checkContainerDimension(self);
        if res.exceeded then
            self.to_draw = not res.exceeded; --Se eccede le dimensioni imposte non disegnarlo
            self:on_elements_exceeded();
        end ]]
        --minebase.HUD.functions.drawContainer(self);
    end

    function container:delete()
        minebase.HUD.functions.removeContainer(self);
    end

    function container:addElements(els)
        for i = 1, #els do
            local el = els[i].element;
            local tp = els[i].type;
            self.elements[#self.elements + 1] = {
                --id = nil, --Non impostato, appena il container viene disegnato viene impostato
                name = els[i].name,
                type = tp or 'def', --Se def allora è una cosa realmente disegnabile
                drawable = el
            };
            if tp == 'container' then
                el:addOffset(self.offset.x, self.offset.y);
            end
        end
        minebase.HUD.functions.drawContainer(self);
    end

    function container:removeElement(nm)
        local id = self:getID(nm);
        local comp = self.elements[id];
        if comp and comp.drawable then --Se non l'ho ancora segnato da eliminare
            if comp.type == 'def' then
                comp.drawable = nil; --Per segnare un elemento da rimuovere gli imposto l'oggetto a nil
            else
                table.remove(self.elements, id);
            end

            return id;
        end
        return nil;
    end

    minebase.screen:addToScreen(container);
    return container;
end
