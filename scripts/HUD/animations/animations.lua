local tx = minebase.HUD.tx;

function minebase.HUD.animations.injectSlide(container)
    if not container.anim then
        container.anim = {};
    end
    container.anim.slide_dx = {
        clock = {
            dt = 0;
            finish = function()
                --fix finale offset
                local cur_of = container.offset;
                local to = container.anim.slide_dx.to;
                container:addOffset(to.x - cur_of.x, to.y - cur_of.y);
            end,
            tick = function(self, dtime)
                local sps = container.anim.slide_dx.step_per_second;
                container:addOffset(sps.x * dtime, sps.y * dtime);
            end
        },
        from = container.offset,
        to = { x = 0, y = 0 },
        step_per_second = { x = 0, y = 0 } --Quanto devo fare in 1 secondo
    }

    function container:slide(to, seconds)
        container.anim.slide_dx.from = container.offset;
        container.anim.slide_dx.to = to;
        local dX = to.x - container.offset.x;
        local dY = to.y - container.offset.y;
        local ddX = dX / seconds;
        local ddY = dY / seconds;
        container.anim.slide_dx.step_per_second = { x = ddX, y = ddY };
        container.anim.slide_dx.clock.dt = seconds;
        tx[#tx + 1] = container.anim.slide_dx.clock;
    end
    return container;
end

--funziona solo per i type="def" hud_elem_type="image": modifico la trasparenza
function minebase.HUD.animations.injectAlphaFade(container)
    if not container.anim then
        container.anim = {};
    end
    container.anim.fade_dx = {
        clock = {
            dt = 0;
            finish = function()
                --fix finale offset
            end,
            tick = function(self, dtime)
            end
        },
        to_fade = "",--nome elemento
        base_img = "",--salvo la stringa iniziale
        from = 0,--da trasparente
        to = 255,--a completamente visibile
        step_per_second = 1 --Quanto devo fare in 1 secondo
    }

    function container:alphaFade(to, seconds)
        container.anim.slide_dx.from = container.offset;
        container.anim.slide_dx.to = to;
        local dX = to.x - container.offset.x;
        local dY = to.y - container.offset.y;
        local ddX = dX / seconds;
        local ddY = dY / seconds;
        container.anim.slide_dx.step_per_second = { x = ddX, y = ddY };
        container.anim.slide_dx.clock.dt = seconds;
        tx[#tx + 1] = container.anim.slide_dx.clock;
    end
    return container;
end
