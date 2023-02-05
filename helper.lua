helper = {}

-- 将序列x或元素x插入到序列t的尾部
function helper.insert_tail(t, x)
    if type(x) == "table" then
        for _, v in ipairs(x) do
            table.insert(t, v)
        end
    else
        table.insert(t, x)
    end   
end

-- 将序列x或元素x插入到序列t的头部
function helper.insert_head(t, x)
    if type(x) == "table" then
        for i, v in ipairs(x) do
            table.insert(t, i, v)
        end
    else
        table.insert(t, 1, x)
    end   
end

-- 在序列t中删除x
function helper.delete(t, x)
    for i, v in ipairs(t) do
        if x == v then
            table.remove(t, i)
            break
        end
    end
end

-- 判断x是否在序列t中
function helper.element(t, x)
    for _, v in ipairs(t) do
        if x == v then
            return true
        end
    end
    return false
end

-- 在序列t中返回x的索引
function helper.find(t, x)
    for i, v in ipairs(t) do
        if x == v then
            return i
        end
    end
    return nil
end

function helper.id_to_id_and_name(t)
    local s = ""
    for _, v in ipairs(t) do
        s = s..tostring(v).."-"..card_m[v].name.." "
    end
    return s
end

function helper.get_others(player)
    local t = {}
    for k, _ in pairs(players) do
        if k ~= player.name then
            table.insert(t, k)
        end
    end
    return t
end

function helper.get_dis(player, player1)
    local i1 = helper.find(order, player.name)
    local i2 = helper.find(order, player1.name)
    local dis = math.min(math.abs(i1 - i2), #order - math.abs(i1 - i2))
    if player1.add_dis_horse then
        dis = dis + 1
    end
    if player.sub_dis_horse then
        dis = dis - 1
    end
    return dis
end

function helper.check_kill_targets(player)
    local t = {}
    for i, v in ipairs(order) do    
        if v ~= player.name then
            local player1 = players[v]
            local dis = helper.get_dis(player, player1)
            if player.arm then
                dis = dis - card_m[player.arm].range + 1
            end
            if dis <= 1 then
                table.insert(t, v)
            end
        end
    end
    return t
end

function helper.check_shunshouqianyang_targets(player)
    local t = {}
    for _, v in ipairs(order) do    
        if v ~= player.name then
            local player1 = players[v]
            local dis = helper.get_dis(player, player1)
            if dis <= 1 then
                table.insert(t, v)
            end
        end
    end
    return t
end

function helper.check_guohechaiqiao_targets(player)
    local t = {}
    for k, v in pairs(players) do
        if k ~= player.name then
            if #v.hand_cards > 0 or #equip.get_equip(v) > 0 then
                table.insert(t, k)
            end
        end
    end
    return t
end

function helper.check_jiedaosharen_targets(player)
    local t = {}
    for k, v in pairs(players) do
        if k ~= player.name then
            if v.arm and next(helper.check_kill_targets(v)) ~= nil then
                table.insert(t, k)
            end
        end
    end
    return t
end

function helper.check_card_in_hand_cards(hand_cards, card_name)
    local cards = {}
    for _, v in ipairs(hand_cards) do
        if card_m[v].name == card_name then
            table.insert(cards, v)
        end
    end
    return cards
end

function helper.check_can_use_card(player)
    local cards = {}
    local hand_cards = player.hand_cards
    for _, v in ipairs(hand_cards) do
        if card_m[v].type == "basic" or card_m[v].type == "tactic" then
            if card_m[v].name == "杀" then
                if (not player.flag["use_kill"] or player.arm and card_m[player.arm].name == "诸葛连弩") and next(helper.check_kill_targets(player)) ~= nil then
                    table.insert(cards, v)
                end
            elseif card_m[v].name == "桃" then
                if player.life < player.life_limit then
                    table.insert(cards, v)
                end
            elseif card_m[v].name == "南蛮入侵" then
                table.insert(cards, v)
            elseif card_m[v].name == "万箭齐发" then
                table.insert(cards, v)
            elseif card_m[v].name == "桃园结义" then
                table.insert(cards, v)
            elseif card_m[v].name == "五谷丰登" then
                table.insert(cards, v)
            elseif card_m[v].name == "决斗" then
                table.insert(cards, v)
            elseif card_m[v].name == "顺手牵羊" then
                if next(helper.check_shunshouqianyang_targets(player)) ~= nil then
                    table.insert(cards, v)
                end
            elseif card_m[v].name == "过河拆桥" then
                if next(helper.check_guohechaiqiao_targets(player)) ~= nil then
                    table.insert(cards, v)
                end
            elseif card_m[v].name == "无中生有" then
                table.insert(cards, v)
            elseif card_m[v].name == "借刀杀人" then
                if next(helper.check_jiedaosharen_targets(player)) ~= nil then
                    table.insert(cards, v)
                end
            elseif card_m[v].name == "乐不思蜀" then
                table.insert(cards, v)
            elseif card_m[v].name == "闪电" then
                table.insert(cards, v)
            end
        elseif card_m[v].type == "arm" or card_m[v].type == "armor" or card_m[v].type == "add_dis_horse" or card_m[v].type == "sub_dis_horse" then
            table.insert(cards, v)
        end
    end
    if player.arm and card_m[player.arm].name == "丈八蛇矛" and #hand_cards >= 2 and not player.flag["use_kill"] then
        table.insert(cards, player.arm)
    end
    return cards
end

function helper.get_kill_color(card_id)
    if card_m[card_id].suit == "红桃" or card_m[card_id].suit == "方块" then
        return "红色"
    else
        return "黑色"
    end
end

function helper.print_info()
    for _, name in ipairs(order) do
        local player = players[name]
        print(string.format("名字：%s", player.name))
        print(string.format("生命：%s", player.life))
        print(string.format("手牌：%s", helper.id_to_id_and_name(player.hand_cards)))
        if player.arm then
            print(string.format("武器：%s", card_m[player.arm].name))
        end
        if player.armor then
            print(string.format("防具：%s", card_m[player.armor].name))
        end
        if player.add_dis_horse then
            print(string.format("+1马：%s", card_m[player.add_dis_horse].name))
        end
        if player.sub_dis_horse then
            print(string.format("-1马：%s", card_m[player.sub_dis_horse].name))
        end
        if next(player.judge_cards) ~= nil then
            print(string.format("判定区：%s", helper.id_to_id_and_name(player.judge_cards)))
        end
        print()
    end
end

return helper