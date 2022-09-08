
    --[[
        command_name={
            mod = modname,
            callback = function()
            params={
                [id] = {
                    name = value,
                    type = value,
                    optional = boolean
                }
            },
            privileges = {
                list
            }
        }
    ]]

--[[
    param_list={
        {
            name = value,
            type = value,
            optional = boolean
        },...
    }
    callback_function(caller,parmas = {
            name = value,
            ...
        })
    end
]]
minebase.commands.functions.addCommand = function(mod_name, command_alias, param_list, privileges, callback_function,
                                                  description)

    local commands_arr = minebase.commands.list;

    commands_arr[command_alias] = {
        mod = mod_name,
        param_list = param_list,
        privileges = privileges,
        callback = callback_function
    };

    minetest.register_chatcommand(command_alias, {
        privs = privileges,
        description = description,
        func = function(name, param)
            local tokens = minebase.functions.stringToTokens(param);
            local params = {};
            for i = 1, #param_list do
                local value = tokens[i];
                if value then --Controllo se è stato inserito il valore nel comando
                    local tmp_vr = param_list[i];
                    params[tmp_vr.name] = minebase.functions.convertStringTo(value, tmp_vr.type);
                else
                    local optional = param_list[i].optional; --Controllo se non è presente il valore se era opzionale o meno
                    if optional then --Era opzionale, finisco il ciclo
                        break;
                    else
                        return true, minebase.colors.functions.setTextColor({{ text = "Error:", font_color = minebase.colors.list.red.light },{ text = "\nRequired param " },{ text = param_list[i].name, font_color = minebase.colors.list.orange.light },{ text = " not given." }});
                    end
                end
            end
            return true, callback_function(name, params);
        end
    });
end
