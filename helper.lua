helper = {}

-- 通用插入函数
function helper.insert(t, v)
    if type(v) == "table" then
        if v.id then -- v是玩家table，直接插入
            table.insert(t, v)
        else -- v是其它table，向t中插入v包含的所有元素
            for _, v1 in ipairs(v) do
                table.insert(t, v1)
            end
        end
    -- v为其它，直接插入
    else
        table.insert(t, v)
    end 
end

-- 通用移除函数
function helper.remove(t, v)
    -- v为table，从t中移除v包含的所有元素
    if type(v) == "table" then
        if v.id then
            for i, v1 in ipairs(t) do
                if v == v1 then
                    table.remove(t, i)
                    return
                end
            end
        else
            for _, v1 in ipairs(v) do
                for i, v2 in ipairs(t) do
                    if v2 == v1 then
                        table.remove(t, i)
                        break
                    end
                end
            end
        end
    -- v为其它，直接移除
    else
        for i, v1 in ipairs(t) do
            if v == v1 then
                table.remove(t, i)
                return
            end
        end
    end 
end

-- table t是否包含元素v
function helper.element(t, v)
    for _, v1 in ipairs(t) do
        if v1 == v then
            return true
        end
    end
end

-- 清空table，用于清除玩家flags，因为flags中可能有键值对，所以不能用table.remove函数
function helper.clear(t)
    for k, _ in pairs(t) do
        t[k] = nil
    end
end

-- 获取table中的所有key
function helper.get_keys(t)
    local t1 = {}
    for k, _ in pairs(t) do
        table.insert(t1, k)
    end
    return t1
end

-- 进栈
function helper.put(t, v)
    table.insert(t, v)
end

-- 出栈
function helper.pop(t)
    table.remove(t)
end

-- 比较
function helper.equal(a, b)
    if type(a) ~= type(b) then
        return false
    end
    if type(a) == "table" then
        if #a ~= #b then
            return false
        end
        for i = 1, #a, 1 do
            if a[i] ~= b[i] then
                return false
            end
        end
    else
        return a == b
    end
    return true   
end

function get_suit_str(suit)
    if suit == macro.suit.spade then
        return "黑桃"
    elseif suit == macro.suit.heart then
        return "红桃"
    elseif suit == macro.suit.club then
        return "梅花"
    elseif suit == macro.suit.diamond then
        return "方块"
    end
end

-- 通用打印函数
function text(str, ...)
    if str then
        print(string.format(str, ...))
    else
        print()
    end
end

function t2s(t)
    if not t then
        return ""
    end
    if type(t) == "number" then
        t = {t}
    end
    local s = ""
    for _, v in ipairs(t) do
        if s ~= "" then
            s = s .. " "
        end
        -- number表示牌或技能
        if resmng.check_card(v) then
            s = s .. resmng[v].id .. "-" .. resmng[v].name
        elseif resmng.check_skill(v) then
                s = s .. v .. "-" .. resmng[v]
        -- table表示玩家
        elseif type(v) == "table" then
            s = s .. tostring(v.id) .. "-" .. v.name
        end
    end
    return s
end

-- 打印对局信息
function print_game_info()
    for _, player in ipairs(game.players) do
        print_player_info(player)
    end
end

-- 打印玩家信息
function print_player_info(player)
    text()
    text("ID:%s", player.id)
    text("名字:%s", player.name)
    text("生命:%d", player.life)
    text("生命上限:%d", player.life_limit)
    text("技能:%s", t2s(player.skills))
    text("手牌:%s", t2s(player.hand_cards))
    text("武器:%s", t2s(player.arm))
    text("防具:%s", t2s(player.armor))
    text("+1马:%s", t2s(player.add_horse))
    text("-1马:%s", t2s(player.sub_horse))
    text("判定区:%s", t2s(player.judge_cards))
end

return helper