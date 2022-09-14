dofile(minetest.get_modpath('minebase_core') .. '/scripts/comms/commons.lua');
dofile(minetest.get_modpath('minebase_core') .. '/scripts/comms/colors.lua');
dofile(minetest.get_modpath('minebase_core') .. '/scripts/comms/screen.lua');

function minebase.functions:registerTx(to_subscribe)
    if to_subscribe.dt and to_subscribe.finish and to_subscribe.tick then
        self.tx[#self.tx + 1] = to_subscribe;
    end
end

minebase.functions.stringToTokens = function(string)
    local ps = {};
    for w in string:gmatch("([%a%d_-]+)") do
        ps[#ps + 1] = w;
    end
    return ps;
end

minebase.functions.numberToTimer = function(seconds)
    local tb = {};
    tb[1] = math.floor(seconds / 60);
    tb[2] = math.floor(seconds - tb[1] * 60);
    return table.concat(tb, ":");
end

minebase.functions.sizeToString = function(size)
    return table.concat({ size.x, size.y }, "x");
end

minebase.functions.warpString = function(string_to_warp, max_length)
    return minebase.functions.warpString_CN(minebase.functions.splitString(string_to_warp), max_length);
end

minebase.functions.warpString_CN = function(warped, max_length, res, index, call)
    res = res or {};
    local counter = 0;
    index = index or 1;
    call = call or 0;
    for i = index, #warped do
        local word = warped[i];
        counter = counter + word:len();
        if counter < max_length then
            counter = counter + 1;
            res[#res + 1] = word
        else
            warped[i] = '\n' .. warped[i];
            call = minebase.functions.warpString_CN(warped, max_length, res, i, call + 1)[2];
            break;
        end
    end
    return { table.concat(res, " "), call };
end

minebase.functions.splitString = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t + 1] = str;
    end
    return t
end

minebase.functions.convertStringTo = function(from, to)
    if from then
        if to then
            if to == 'int' or to == 'integer' then
                return tonumber(from);
            elseif to == 'hex' then
                return tonumber(from, 16);
            elseif to == 'bool' or to == 'boolean' then
                local stringtoboolean = { ["true"] = true, ["false"] = false, ["0"] = false }; --Il controllo è più veloce così
                return stringtoboolean[from];
            end
        end
        return from;
    else
        return nil;
    end
end