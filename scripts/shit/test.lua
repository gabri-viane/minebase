local param = "black_light";
--local params=string.match(param, "([%a%d_-]+)+");

local ps = param:gmatch("([^_]+)");--{};
--[[ for w in param:gmatch("([^_]+)") do
    print(w);
    ps[#ps + 1] = w;
end ]]
print(type(ps));