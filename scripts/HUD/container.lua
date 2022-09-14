minebase.HUD.functions.drawContainer = function(container)
    if container and container.to_draw then
        local off = container.offset;
        for i = 1, #container.elements do
            local el = container.elements[i];
            if el.type == 'def' then
                if not el.id then --Non ho ancora disegnato l'oggetto
                    local comp = el.drawable;
                    comp.position = container.position; --Imposto la posizione dell'oggetto
                    local off2 = comp.offset;
                    comp.offset = { x = off.x + off2.x, y = off.y + off2.y };
                    el.id = container.owner:hud_add(comp);
                else
                    local comp = el.drawable;
                    if not comp then --Altrimenti se ho l'id ma non ho più l'oggetto lo tolgo dall'hud e dalla lista del container
                        container.owner:remove_hud(comp);
                        container.elements[i] = nil;
                    end
                end
            else
                local inner_container = el.drawable;
                inner_container:move(container.position);
            end
        end
    end
end

minebase.HUD.functions.removeContainer = function(container)
    if container then
        local el;
        for i = 1, #container.elements do
            el = container.elements[i];
            if el.type == 'def' then --è un oggetto disegnabile
                local id = container.elements[i].id;
                container.owner:hud_remove(id);
            elseif el.type == 'container' then
                el.drawable:delete();
            end
        end
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
        type = "container";
        offset = offset or { x = 0, y = 0 },
        elements = {},
        to_draw = true,
        to_refresh = false
    };

    --Restituisce direttamente l'elemento drawable
    function container:getElement(nm)
        local res = container:get(nm);
        if res then
            return res.drawable;
        end
        return nil;
    end

    --Restituisce l table: name-type-drawable
    function container:get(nm)
        local res = container:getID(nm);
        if res then
            return self.elements[res];
        end
        return nil;
    end

    function container:getID(nm)
        for i = 1, #self.elements do
            if self.elements[i].name == nm then
                return i;
            end
        end
        return nil;
    end

    function container:getLast()
        return self.elements[#self.elements];
    end

    --Muove il contenitore ad una nuova posizione relativa allo schermo
    function container:move(to_position)
        self.position = to_position;
        minebase.HUD.functions.reloadContainerPosition(self);
        -- minebase.screen:refreshScreen(self); --Non utilizzato
    end

    --Muove il continitore ad un nuovo offset (AGGIUNGE ALL'OFFSET CORRENTE, NON SOVRASCRIVE!!)
    --relativo alla posizione
    function container:addOffset(x, y)
        self.offset = { x = self.offset.x + x, y = self.offset.y + y };
        minebase.HUD.functions.reloadContainerOffsets(self, { x = x, y = y });
    end

    --updates= {{type="text",value="Nuovo testo"},{type="number",value=0x00000}} (un array di tabelle valori da aggiornare)
    function container:updateElement(nm, updates) --ID della lista del container non dell'elemento creato
        local comp = self:get(nm);
        if comp and comp.drawable then --se esiste il componente con quell'id e esiste anche l'oggetto da aggiornare (non è stato eliminato)
            self.to_refresh = true;
            comp.refresh = updates;
            if self.refresh_callback then --Controllo se ho un callback
                self.refresh_callback(); --Se ce l'ho probabilmente non sono sottoscritto al thread dello screen
            end
        end
    end

    --Nel caso il container appartenga ad un container viene impostato un callback
    --Per evitare di sottoscrivere tutti i container al thread di screen
    function container:onRefreshRequest(RFunction)
        self.refresh_callback = RFunction;
    end

    --Element è un componente minetest da aggiungere all'HUD, non ha bisogno dell'elemento position
    --perchè è ereditato del container a cui viene aggiunto
    --Il nome serve per essere più facilmente accessibile dallo oggetto #minebase.screen
    function container:addElement(nm, element)
        self.elements[#self.elements + 1] = {
            --id = nil, --Non impostato, appena il container viene disegnato viene impostato
            name = nm,
            type = element.type,
            drawable = element,
        };
        if element.type == 'container' then
            element:move(self.position); --Imposto l'eredità della posizione del contenitore
            element:addOffset(self.offset.x, self.offset.y); --Aggiorno l'offset con quello di questo container
            element:onRefreshRequest(function() --Imposto la funzione di refresh
                minebase.HUD.functions.refreshContainer(element);
            end);
        end
    end

    function container:delete()
        minebase.HUD.functions.removeContainer(self);
    end

    function container:addElements(els)
        for i = 1, #els do
            local el = els[i].element;
            self.elements[#self.elements + 1] = {
                --id = nil, --Non impostato, appena il container viene disegnato viene impostato
                name = els[i].name,
                type = el.type, --Se def allora è una cosa realmente disegnabile
                drawable = el
            };
            if el.type == 'container' then
                el:move(self.position)
                el:addOffset(self.offset.x, self.offset.y);
                el:onRefreshRequest(function()
                    minebase.HUD.functions.refreshContainer(el);
                end);
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
                comp = table.remove(self.elements, id); --Se è un container lo devo rimuovere: NON DEVO ELIMINARLO!!! RIMUOVO DA ME MA NON ELIMINO
            end
            return { id = id, element = comp };
        end
        return nil;
    end

    --Registra questo container al thread di screen
    function container:registerToScreen()
        minebase.screen:addToScreen(self);
    end

    return container;
end

--Ha tutte le proprietà e funzioni di un container normale ma è meno "pesante"
minebase.HUD.functions.createLightContainer = function(player, name, position, offset, component)
    local container = {
        name = name;
        owner = player;
        position = position,
        type = "container";
        offset = offset or { x = 0, y = 0 },
        elements = { [1] = {
            name = name, --Nome uguale al container
            type = component.type,
            drawable = component
        } },
        to_draw = true,
        to_refresh = false
    };

    --Restituisce direttamente l'elemento drawable
    function container:getElement()
        return self.elements[1].drawable;
    end

    --Restituisce l table: name-type-drawable
    function container:get()
        return self.elements[1];
    end

    function container:getID()
        return 1;
    end

    container.getLast = container.get; --Imposto la funzione uguale a get

    --Muove il contenitore ad una nuova posizione relativa allo schermo
    function container:move(to_position)
        self.position = to_position;
        minebase.HUD.functions.reloadContainerPosition(self);
    end

    --Muove il continitore ad un nuovo offset (AGGIUNGE ALL'OFFSET CORRENTE, NON SOVRASCRIVE!!)
    --relativo alla posizione
    function container:addOffset(x, y)
        self.offset = { x = self.offset.x + x, y = self.offset.y + y };
        minebase.HUD.functions.reloadContainerOffsets(self, { x = x, y = y });
    end

    --updates= {{type="text",value="Nuovo testo"},{type="number",value=0x00000}} (un array di tabelle valori da aggiornare)
    function container:updateElement(nm, updates) --ID della lista del container non dell'elemento creato
        self.to_refresh = true;
        self.elements[1].refresh = updates;
        if self.refresh_callback then --Controllo se ho un callback
            self.refresh_callback(); --Se ce l'ho probabilmente non sono sottoscritto al thread dello screen
        end
    end

    --Nel caso il container appartenga ad un container viene impostato un callback
    --Per evitare di sottoscrivere tutti i container al thread di screen
    function container:onRefreshRequest(RFunction)
        self.refresh_callback = RFunction;
    end

    function container:delete()
        minebase.HUD.functions.removeContainer(self);
    end

    --Le funzioni seguenti non possono lavorare su questo container
    container.removeElement = function()

    end
    container.addElement = container.removeElement;
    container.addElements = container.removeElement;

    --Registra questo container al thread di screen
    function container:registerToScreen()
        minebase.screen:addToScreen(self);
    end

    --Disegno solo una volta il container
    minebase.HUD.functions.drawContainer(container);

    return container;
end
