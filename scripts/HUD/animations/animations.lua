local tx = minebase.HUD.tx;

function minebase.HUD.animations.injectSlide(container)
    if not container.anim then
        container.anim = {};
    end

    container.anim.slide_dx = {
        clock = {
            dt = 0;
            finish = function(self)
                --fix finale offset
                local cur_of = container.base_offset;
                local to = container.anim.slide_dx.to;
                container:addOffset(to.x - cur_of.x, to.y + cur_of.y);
            end,
            tick = function(self, dtime)
                local sps = container.anim.slide_dx.step_per_second;
                container:addOffset(sps.x * dtime, sps.y * dtime);
            end
        },
        from = container.base_offset,
        to = { x = container.base_offset.x, y = container.base_offset.y },
        step_per_second = { x = 0, y = 0 } --Quanto devo fare in 1 secondo
    }

    function container:slide(to, seconds)
        local sx = self.anim.slide_dx;
        sx.from = self.base_offset;
        sx.to = to;
        local dX = to.x;
        local dY = to.y;
        local ddX = dX / seconds;
        local ddY = dY / seconds;
        sx.step_per_second = { x = ddX, y = ddY };
        sx.clock.dt = seconds;
        tx[#tx + 1] = sx.clock;
    end

    return container;
end

--funziona solo per i type="def" hud_elem_type="image": modifico la trasparenza
function minebase.HUD.animations.injectAlphaFade(container)
    if not container.anim then
        container.anim = {};
    end
    container.anim.fade_dx = {
        clockS = {
            dt = 0;
            finish = function()
                --fix finale offset
                local fx = container.anim.fade_dx;
                fx.altered[4] = fx.to;
                container:updateElement(fx.to_fade, { { name = "text", value = table.concat(fx.altered) } });
            end,
            tick = function(self, dtime)
                local fx = container.anim.fade_dx;
                fx.current = fx.current + fx.step_per_second * dtime;
                fx.altered[4] = math.floor(fx.current);
                container:updateElement(fx.to_fade, { { name = "text", value = table.concat(fx.altered) } });
            end
        },
        clockM = {
            dt = 0;
            finish = function()
                --fix finale offset
                local fx = container.anim.fade_dx;
                for i = 1, #fx.altered do
                    fx.altered[i][4] = fx.to;
                    container:updateElement(fx.to_fade[i], { { name = "text", value = table.concat(fx.altered[i]) } });
                end
            end,
            tick = function(self, dtime)
                local fx = container.anim.fade_dx;
                fx.current = fx.current + fx.step_per_second * dtime;
                local v = math.floor(fx.current);
                for i = 1, #fx.altered do
                    fx.altered[i][4] = v;
                    container:updateElement(fx.to_fade[i], { { name = "text", value = table.concat(fx.altered[i]) } });
                end
            end
        },
        to_fade = "", --nome elemento
        base_img = "", --salvo la stringa iniziale
        altered = {},
        current = 0,
        from = 0, --da trasparente
        to = 255, --a completamente visibile
        step_per_second = 1 --Quanto devo fare in 1 secondo
    }

    --This method only works with one image elements inside a container
    function container:alphaFadeS(hud_image_name, from, to, seconds)
        local img = self:getElement(hud_image_name);
        if img and img.type == "def" and img.hud_elem_type == "image" then

            local fx = self.anim.fade_dx;

            fx.from = from;
            fx.to = to;
            fx.to_fade = hud_image_name;
            fx.base_img = img.text;
            fx.step_per_second = (to - from) / seconds;
            fx.clockS.dt = seconds;
            fx.current = fx.from;

            fx.altered = { "(", fx.base_img, ")^[opacity:", fx.from };

            tx[#tx + 1] = fx.clockS;
        end
    end

    function container:alphaFadeM(hud_images, from, to, seconds)

        local fx = self.anim.fade_dx;
        fx.from = from;
        fx.to = to;
        fx.step_per_second = (to - from) / seconds;
        fx.clockM.dt = seconds;
        fx.current = fx.from;

        for _, v in ipairs(hud_images) do
            local img = self:getElement(v);
            if img and img.type == "def" and img.hud_elem_type == "image" then
                fx.to_fade[#fx.to_fade + 1] = hud_images;
                fx.base_img[#fx.base_img + 1] = img.text;
                fx.altered[#fx.altered + 1] = { "(", fx.base_img, ")^[opacity:", fx.from };
            end
        end
        tx[#tx + 1] = fx.clockM;
    end

    return container;
end

--funziona solo per i type="def" hud_elem_type="image": modifico la trasparenza
function minebase.HUD.animations.injectAnimation(container)
    if not container.anim then
        container.anim = {};
    end
    container.anim.frame_anim_dx = {
        clock = {
            dt = 0;
            finish = function()
                --fix finale offset
                local fx = container.anim.frame_anim_dx;
                fx.altered[6] = fx.total;
                container:updateElement(fx.to_animate, { { name = "text", value = table.concat(fx.altered) } });
            end,
            tick = function(self, dtime)
                local fx = container.anim.frame_anim_dx;
                fx.current = fx.current + fx.step_per_second * dtime;
                fx.altered[6] = math.floor(fx.current);
                container:updateElement(fx.to_animate, { { name = "text", value = table.concat(fx.altered) } });
                if fx.current >= fx.total then
                    fx.current = 0;
                    if fx.mode == "repeat" then
                        fx.repeat_count = fx.repeat_count - 1;
                        if fx.repeat_count == 0 then
                            self.dt = 0; -- fermo animazione
                        else
                            self.dt = 3; --devo continuare l'animazione
                        end
                    end
                end
            end
        },
        to_animate = "", --nome elemento
        base_img = "", --salvo la stringa iniziale
        altered = {},
        current = 0,
        total = 0,
        repeat_count = 1,
        mode = "seconds",
        step_per_second = 1 --Quanto devo fare in 1 secondo
    }

    container.anim.text_anim_dx = {
        clock = {
            dt = 0;
            finish = function()
                --fix finale offset
                local tx_ = container.anim.text_anim_dx;
                container:updateElement(tx_.to_animate, { { name = "text", value = "" } });
            end,
            tick = function(self, dtime)
                local tx_ = container.anim.text_anim_dx;
                if tx_.mode == "repeat" then
                    self.dt = 3;
                end
                tx_.current = tx_.current + tx_.step_per_second * dtime;
                local s_idx = math.floor(tx_.current);
                local e_idx = s_idx + tx_.max;
                local t_len = tx_.base_text:len();
                local to_add = "";
                if e_idx > t_len then
                    local over = tx_.max - (t_len - s_idx);
                    e_idx = t_len;
                    for i = 1, over do
                        to_add = to_add .. " ";
                    end
                end
                tx_.altered = tx_.base_text:sub(s_idx, e_idx) .. to_add;
                container:updateElement(tx_.to_animate, { { name = "text", value = tx_.altered } });
                if math.floor(tx_.current) == t_len then
                    tx_.current = 0;
                    for i = 1, tx_.max do
                        tx_.base_text = " " .. tx_.base_text;
                    end
                    if tx_.mode == "repeat" then
                        tx_.repeat_count = tx_.repeat_count - 1;
                        if tx_.repeat_count == 0 then
                            self.dt = 0; -- fermo animazione
                        else
                            self.dt = 3; --devo continuare l'animazione
                        end
                    end
                end
            end
        },
        to_animate = "", --nome elemento
        base_text = "", --salvo la stringa iniziale
        altered = {},
        current = 0,
        max = 0,
        repeat_count = 1,
        mode = "seconds",
        step_per_second = 1 --Quanto devo fare in 1 secondo
    }

    --This method only works with one image elements inside a container
    --Posso impostare o per quanti secondi oppure per quante ripetizioni voglio
    function container:frameAnimation(hud_image_name, total, seconds_per_sprite, seconds, repeats)
        local img = self:getElement(hud_image_name);
        if img and img.type == "def" and img.hud_elem_type == "image" then

            local fx = self.anim.frame_anim_dx;

            fx.total = total;
            fx.to_animate = hud_image_name;
            fx.base_img = img.text;
            fx.step_per_second = 1 / seconds_per_sprite;
            fx.clock.dt = seconds;
            fx.current = 0;

            if repeats then
                fx.mode = "repeat";
                fx.repeat_count = repeats;
            end

            fx.altered = { "(", fx.base_img, ")^[verticalframe:", fx.total, ":", fx.current };

            tx[#tx + 1] = fx.clock;
        end
    end

    --This method only works with one image elements inside a container
    --Posso impostare o per quanti secondi oppure per quante ripetizioni voglio
    function container:textAnimation(hud_text_name, max_chars, seconds_pre_sprite, seconds, repeats)
        local txt = self:getElement(hud_text_name);
        if txt and txt.type == "def" and txt.hud_elem_type == "text" then

            local tx_ = self.anim.text_anim_dx;

            tx_.max = max_chars;
            tx_.to_animate = hud_text_name;
            tx_.base_text = txt.text;
            tx_.step_per_second = 1 / seconds_pre_sprite;
            tx_.clock.dt = seconds;
            tx_.current = 0;

            if repeats then
                tx_.mode = "repeat";
                tx_.repeat_count = repeats;
            end

            tx_.altered = tx_.base_text:sub(tx_.current, tx_.current + max_chars);

            tx[#tx + 1] = tx_.clock;
        end
    end

    --TODO: AGGIUNGERE ANIMAZIONE PER TESTI: LE PAROLE SCORRONO: DATA UNA FRASE FACCIO IL SUBSTRING +1 OGNI FRAME

    return container;
end
