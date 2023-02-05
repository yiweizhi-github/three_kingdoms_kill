tactic = {}

function tactic.foreach_exclude_self(func, player, ...)
    local player_queue = {}
    local pos = helper.find(order, player.name)
    for i = pos + 1, #order, 1 do
        table.insert(player_queue, order[i])        
    end
    for i = 1, pos - 1, 1 do
        table.insert(player_queue, order[i])             
    end
    for i = 1, #player_queue, 1 do
        func(player, players[player_queue[i]], ...)
    end    
end

function tactic.foreach(func, player, ...)
    local player_queue = {}
    local pos = helper.find(order, player.name)
    for i = pos, #order, 1 do
        table.insert(player_queue, order[i])        
    end
    for i = 1, pos - 1, 1 do
        table.insert(player_queue, order[i])             
    end
    for i = 1, #player_queue, 1 do
        func(player, players[player_queue[i]], ...)
    end
end

function tactic.nanmanruqin(player)
    tactic.foreach_exclude_self(tactic.respond_nannanmanruqin, player)
end

function tactic.respond_nannanmanruqin(player1, player2)
    if tactic.query_wuxiekeji(player1, player2, false) then
        return
    end
    print(string.format("%s结算南蛮入侵：", player2.name))
    local kills = helper.check_card_in_hand_cards(player2.hand_cards, "杀")
    if next(kills) == nil then
        print(string.format("%s手上没有杀", player2.name))
        damage.when_damage(player1, player2, "tatic", 1)
    else
        print(string.format("%s可以使用的杀手牌id：%s", player2.name, table.concat(kills, " ")))
        print("是否出杀？出输入牌id，不出输入n：")
        while true do
            local io_data = io.read()
            if helper.element(kills, tonumber(io_data)) then
                helper.delete(player2.hand_cards, tonumber(io_data))
                table.insert(discard_pile, io_data)
                break
            elseif io_data == "n" then
                damage.when_damage(player1, player2, "tatic", 1)
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    end
end

function tactic.wanjianqifa(player)
    tactic.foreach_exclude_self(tactic.respond_wanjianqifa, player)
end

function tactic.respond_wanjianqifa(player1, player2)
    if tactic.query_wuxiekeji(player1, player2, false) then
        return
    end
    print(string.format("%s结算万箭齐发：", player2.name))
    local dodges = helper.check_card_in_hand_cards(player2.hand_cards, "闪")
    if next(dodges) == nil then
        print(string.format("%s手上没有闪", player2.name))
        damage.when_damage(player1, player2, "tatic", 1)
    else
        print(string.format("%s可以使用的闪手牌id：%s", player2.name, table.concat(dodges, " ")))
        print("是否出闪？出输入牌id，不出输入n：")
        while true do
            local io_data = io.read()
            if helper.element(dodges, tonumber(io_data)) then
                helper.delete(player2.hand_cards, tonumber(io_data))
                table.insert(discard_pile, io_data)
                break
            elseif io_data == "n" then
                damage.when_damage(player1, player2, "tatic", 1)
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    end
end

function tactic.juedou(player)
    local targets = helper.get_others(player)
    print(string.format("%s可以选择的决斗对象：%s", player.name, table.concat(targets, " ")))
    print(string.format("请输入%s要决斗的对象：", player.name))
    while true do
        local io_data = io.read()
        if players[io_data] then
            if tactic.query_wuxiekeji(player, players[io_data], false) then
                return
            end
            tactic.respond_juedou(player, players[io_data])
            break
        else
            print("输入错误，请重新输入：")
        end
    end
end

function tactic.respond_juedou(player1, player2)
    print(string.format("%s结算决斗：", player2.name))
    local kills = helper.check_card_in_hand_cards(player2.hand_cards, "杀")
    if next(kills) == nil then
        print("%s手上没有杀")
        damage.when_damage(player1, player2, "tatic", 1)
    else
        local s = ""
        for _, v in ipairs(kills) do
            s = s.." "..tostring(v)
        end
        print(string.format("%s可以使用的杀手牌id：%s", player2.name, s))
        print("是否出杀？出输入牌id，不出输入n：")
        while true do
            local io_data = io.read()
            if helper.element(kills, tonumber(io_data)) then
                helper.delete(player2.hand_cards, tonumber(io_data))
                table.insert(discard_pile, tonumber(io_data))
                tactic.respond_juedou(player2, player1)
                break
            elseif io_data == "n" then
                damage.when_damage(player1, player2, "tatic", 1)
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    end
end

function tactic.shunshouqianyang(player)
    local targets = helper.check_shunshouqianyang_targets(player)
    print(string.format("%s可以选择的顺手牵羊对象：%s", player.name, table.concat(targets, " ")))
    print(string.format("请输入%s要顺手牵羊的对象：", player.name))
    while true do
        local io_data = io.read()
        if helper.element(targets, io_data) then
            if tactic.query_wuxiekeji(player, players[io_data], false) then
                return
            end
            tactic.do_shunshouqianyang(player, players[io_data])
            break
        else
            print("输入错误，请重新输入：")
        end
    end 
end

function tactic.do_shunshouqianyang(player1, player2)
    local equip_cards = equip.get_equip(player2)
    local cards = {}
    helper.insert_tail(cards, equip_cards)
    helper.insert_tail(cards, player2.judge_cards)
    local s = ""
    for i = 1, #player2.hand_cards, 1 do
        s = s.."手牌"..tostring(i).." "
    end
    s = s..helper.id_to_id_and_name(cards)
    print(string.format("%s可以获得的%s的牌：%s", player1.name, player2.name, s))
    if next(cards) then
        print(string.format("想获得%s装备区或判定区的牌，输入对应id：", player2.name))
    end
    if next(player2.hand_cards) ~= nil then
        print(string.format("想随机获得%s的一张手牌，输入hand_card：", player2.name))    
    end
    while true do
        local io_data = io.read()
        if helper.element(cards, tonumber(io_data)) then
            if helper.element(equip_cards, tonumber(io_data)) then
                if player2.arm == tonumber(io_data) then
                    player2.arm = nil
                elseif player2.armor == tonumber(io_data) then
                    player2.armor = nil
                elseif player2.add_dis_horse == tonumber(io_data) then
                    player2.add_dis_horse = nil
                else
                    player2.sub_dis_horse = nil
                end
                table.insert(player1.hand_cards, tonumber(io_data))
            else
                helper.delete(player2.judge_cards, tonumber(io_data))
                table.insert(player1.hand_cards, tonumber(io_data))
            end
            break
        elseif io_data == "hand_card" and next(player2.hand_cards) ~= nil then
            local n = math.random(#player2.hand_cards)
            local id = player2.hand_cards[n]
            table.remove(player2.hand_cards, n)
            table.insert(player1.hand_cards, id)
            break
        else
            print("输入错误，请重新输入：")
        end
    end
end

function tactic.guohechaiqiao(player)
    local targets = helper.check_guohechaiqiao_targets(player)
    print(string.format("%s可以选择的过河拆桥对象：%s", player.name, table.concat(targets, " ")))
    print(string.format("请输入%s要过河拆桥的对象：", player.name))
    while true do
        local io_data = io.read()
        if helper.element(targets, io_data) then
            if tactic.query_wuxiekeji(player, players[io_data], false) then
                return
            end
            tactic.do_guohechaiqiao(player, players[io_data])
            break
        else
            print("输入错误，请重新输入：")
        end
    end 
end

function tactic.do_guohechaiqiao(player1, player2)
    local equip_cards = equip.get_equip(player2)
    local cards = {}
    helper.insert_tail(cards, equip_cards)
    helper.insert_tail(cards, player2.judge_cards)
    local s = ""
    for i = 1, #player2.hand_cards, 1 do
        s = s.."手牌"..tostring(i).." "
    end
    s = s..helper.id_to_id_and_name(cards)
    print(string.format("%s可以弃置的%s的牌：%s", player1.name, player2.name, s))
    if next(cards) then
        print(string.format("想弃置%s装备区或判定区的牌，输入对应id：", player2.name))
    end
    if next(player2.hand_cards) ~= nil then
        print(string.format("想随机弃置%s的一张手牌，输入hand_card：", player2.name))    
    end
    while true do
        local io_data = io.read()
        if helper.element(cards, tonumber(io_data)) then
            if helper.element(equip_cards, tonumber(io_data)) then
                if player2.arm == tonumber(io_data) then
                    player2.arm = nil
                elseif player2.armor == tonumber(io_data) then
                    player2.armor = nil
                elseif player2.add_dis_horse == tonumber(io_data) then
                    player2.add_dis_horse = nil
                else
                    player2.sub_dis_horse = nil
                end
                table.insert(discard_pile, tonumber(io_data))
            else
                helper.delete(player2.judge_cards, tonumber(io_data))
                table.insert(discard_pile, tonumber(io_data))
            end
            break
        elseif io_data == "hand_card" and (player2.hand_cards) then
            local n = math.random(#player2.hand_cards)
            local id = player2.hand_cards[n]
            table.remove(player2.hand_cards, n)
            table.insert(discard_pile, id)
            break
        else
            print("输入错误，请重新输入：")
        end
    end
end

function tactic.wuzhongshengyou(player)
    if tactic.query_wuxiekeji(player, player, false) then
        return
    end
    local cards = card_pile_m.draw(card_pile, discard_pile, 2)
    helper.insert_tail(player.hand_cards, cards)
end

function tactic.taoyuanjieyi(player)
    tactic.foreach(tactic.respond_taoyuanjieyi, player)
end

function tactic.respond_taoyuanjieyi(player1, player2)
    if tactic.query_wuxiekeji(player1, player2, false) then
        return
    end
    if player2.life < player2.life_limit then
        player2.life = player2.life + 1
    end
end

function tactic.wugufengdeng(player)
    local cards = card_pile_m.draw(card_pile, discard_pile, #order)
    tactic.foreach(tactic.respond_wugufengdeng, player, cards)
end

function tactic.respond_wugufengdeng(player1, player2, cards)
    if tactic.query_wuxiekeji(player1, player2, false) then
        return
    end
    print(string.format("%s结算五谷丰登：", player2.name))
    local s = helper.id_to_id_and_name(cards)
    print(string.format("%s可以获得的牌：%s", player2.name, s))
    print(string.format("请输入%s想获得的牌id：", player2.name))
    while true do
        local io_data = io.read()
        if helper.element(cards, tonumber(io_data)) then
                helper.delete(cards, tonumber(io_data))
                table.insert(player2.hand_cards, tonumber(io_data))
            break
        else
            print("输入错误，请重新输入：")
        end
    end
end

function tactic.jiedaosharen(player)
    local targets = helper.check_jiedaosharen_targets(player)
    print(string.format("%s可以选择的借刀杀人对象：%s", player.name, table.concat(targets, " ")))
    print(string.format("请输入%s要借刀杀人的对象：", player.name))
    while true do
        local io_data = io.read()
        if helper.element(targets, io_data) then
            if tactic.query_wuxiekeji(player, players[io_data], false) then
                return
            end
            local targets1 = helper.check_kill_targets(players[io_data])
            print(string.format("%s可以杀到的人：%s", players[io_data].name, table.concat(targets1, " ")))
            print(string.format("请输入%s要%s杀的人：", player.name, players[io_data].name))
            while true do
                local io_data1 = io.read()
                if helper.element(targets1, io_data1) then
                    tactic.respond_jiedaosharen(player, players[io_data], players[io_data1])
                    break
                else
                    print("输入错误，请重新输入：")
                end
            end
            break
        else
            print("输入错误，请重新输入：")
        end
    end 
end

function tactic.respond_jiedaosharen(player1, player2, player3)
    print(string.format("%s结算借刀杀人：", player2.name))
    print(string.format("%s指定%s对%s使用一张杀", player1.name, player2.name, player3.name))
    local kills = helper.check_card_in_hand_cards(player2.hand_cards, "杀")
    if next(kills) == nil then
        print(string.format("%s手上没有杀，只能把武器交给%s", player2.name, player1.name))
        local arm = player2.arm
        player2.arm = nil
        table.insert(player1.hand_cards, arm)
    else
        print(string.format("%s可以使用的杀手牌id：%s", player2.name, table.concat(kills, " ")))
        while true do
            print(string.format("%s是否出杀？出输入牌id，不出输入n并把武器交给%s：", player2.name, player1.name))
            local io_data = io.read()
            if helper.element(kills, tonumber(io_data)) then
                helper.delete(player2.hand_cards, tonumber(io_data))
                local can_kill_players = helper.check_kill_targets(player2)
                local targets = {}
                table.insert(targets, player3.name)
                helper.delete(can_kill_players, player3.name)
                basic.after_choose_kill_target(player2, can_kill_players, targets)
                for _, v in ipairs(targets) do
                    basic.block_by_armor(player2, players[v], helper.get_kill_color(tonumber(io_data)))
                end    
                table.insert(discard_pile, tonumber(io_data))
                break
            elseif io_data == "n" then
                local arm = player2.arm
                player2.arm = nil
                table.insert(player1.hand_cards, arm)
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    end
end

function tactic.query_wuxiekeji(player1, player2, valid)
    local player_queue = {}
    local pos = helper.find(order, player1.name)
    for i = pos, #order, 1 do
        table.insert(player_queue, order[i])        
    end
    for i = 1, pos - 1, 1 do
        table.insert(player_queue, order[i])             
    end
    local use = false
    local player
    for i = 1, #player_queue, 1 do
        player = players[player_queue[i]]
        local wuxiekejis = helper.check_card_in_hand_cards(player.hand_cards, "无懈可击")
        if next(wuxiekejis) ~= nil then
            print(string.format("%s对%s使用了锦囊牌", player1.name, player2.name))
            print(string.format("%s可以使用的无懈可击牌id：%s", player.name, table.concat(wuxiekejis, " ")))
            print(string.format("%s是否使用无懈可击？是输入牌id，否输入n：", player.name))
            while true do
                local io_data = io.read()
                if helper.element(wuxiekejis, tonumber(io_data)) then
                    helper.delete(player.hand_cards, tonumber(io_data))
                    table.insert(discard_pile, tonumber(io_data))
                    use = true
                    break
                elseif io_data == "n" then
                    break
                else
                    print("输入错误，请重新输入：")
                end
            end
        end
        if use then
            break
        end
    end
    if use then
        return tactic.query_wuxiekeji(player, player1, not valid)
    else
        return valid
    end
end

function tactic.lebusishu(player, card_id)
    local targets = helper.get_others(player)
    print(string.format("%s可以选择的乐不思蜀对象：%s", player.name, table.concat(targets, " ")))
    print(string.format("请输入%s要乐不思蜀的对象：", player.name))
    while true do
        local io_data = io.read()
        if helper.element(targets, io_data) then
            table.insert(players[io_data].judge_cards, 1, card_id)
            break
        else
            print("输入错误，请重新输入：")
        end
    end 
end

function tactic.shandian(player, card_id)
    table.insert(player.judge_cards, 1, card_id)
end

function tactic.judge_lebusishu(player)
    print(string.format("%s判定乐不思蜀", player.name))
    if not tactic.query_wuxiekeji(player, player, false) then
        local card = card_pile_m.draw(card_pile, discard_pile, 1)[1]
        if card_m[card].suit ~= "红桃" then
            print(string.format("%s判定乐不思蜀的结果为%s，跳过出牌阶段", player.name, card_m[card].suit))
            player.flag["jump_play"] = true
        else
            print(string.format("%s判定乐不思蜀的结果为红桃，无需跳过出牌阶段", player.name))
        end
        table.insert(discard_pile, card)
    end   
    table.insert(discard_pile, table.remove(player.judge_cards, 1))
end

function tactic.judge_shandian(player)
    print(string.format("%s判定闪电", player.name))
    local valid = false
    if not tactic.query_wuxiekeji(player, player, false) then
        local card = card_pile_m.draw(card_pile, discard_pile, 1)[1]
        if card_m[card].suit ~= "黑桃" or card_m[card].points < 2 or card_m[card].points > 9 then
            print(string.format("%s判定闪电的结果为%s%d，不受到伤害", player.name, card_m[card].suit, card_m[card].points))
        else
            print(string.format("%s判定闪电的结果为%s%d，受到3点伤害", player.name, card_m[card].suit, card_m[card].points))
            damage.when_damage(nil, player, "tactic", 3)
            valid = true
        end
        table.insert(discard_pile, card)
    end
    if valid then
        table.insert(discard_pile, table.remove(player.judge_cards, 1))
    else
        local i = helper.find(order, player.name)
        if i == #order then
            i = 0
        end
        local next_player = players[order[i+1]]
        print(string.format("闪电移动到%s的判定区", next_player.name))
        table.insert(next_player.judge_cards, table.remove(player.judge_cards, 1))
    end 
end

return tactic