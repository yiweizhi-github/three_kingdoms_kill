equip = {}

function equip.respond_cixiongshuanggu(player1, player2)
    print(string.format("%s结算雌雄双股剑：", player2.name))
    if next(player2.hand_cards) ~= nil then
        print(string.format("输入y%s摸一张牌，输入n%s弃一张手牌", player1.name, player2.name))
        while true do
            local io_data = io.read()
            if io_data == "y" then
                local card = card_pile_m.draw(card_pile, discard_pile, 1)[1]
                print("card", card)
                table.insert(player1.hand_cards, card)
                break
            elseif io_data == "n" then
                print(string.format("%s当前的手牌为：%s", player2.name, helper.id_to_id_and_name(player2.hand_cards)))
                print(string.format("请输入%s想丢弃的手牌id：", player2.name))
                while true do
                    io_data = io.read()
                    if helper.element(player2.hand_cards, tonumber(io_data)) then
                        helper.delete(player2.hand_cards, tonumber(io_data))
                        table.insert(discard_pile, tonumber(io_data))
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
    else
        print(string.format("%s没有手牌，%s摸一张牌：", player2.name, player1.name))
        local card = card_pile_m.draw(card_pile, discard_pile, 1)[1]
        print("card", card)
        table.insert(player1.hand_cards, card)
    end
end

function equip.use_fangtianhuaji(player, can_kill_players, targets)
    local n = #can_kill_players
    if n > 2 then
        n = 2
    end
    local i = 1
    while i <= n do
        print(string.format("%s可以杀的玩家：%s", player.name, table.concat(can_kill_players, " ")))
        print(string.format("%s还可以指定%d名玩家，请输入想杀的玩家名字，输入exit退出", player.name, n - i + 1))
        local io_data = io.read()
        if helper.element(can_kill_players, io_data) then
            table.insert(targets, io_data)
            helper.delete(can_kill_players, io_data)
            i = i + 1
        elseif io_data == "exit" then
            break
        else
            print("输入错误，请重新输入：")
        end
    end
end

function equip.use_renwangdun(player1, player2, color)
    if color == "红色" then
        print("仁王盾无法阻挡红杀")
        query_dodge(player1, player2)
    else
        print(string.format("%s对%s使用的黑杀被仁王盾阻挡", player1.name, player2.name))
    end
end

function equip.use_baguazhen(player1, player2)
    print("是否发动八卦阵？输入y或n：")
        while true do
            local io_data = io.read()
            if io_data == "y" then
                local card = card_pile_m.draw(card_pile, discard_pile, 1)[1]
                if card_m[card].suit == "红桃" or card_m[card].suit == "方块" then
                    print(string.format("八卦阵判定结果为%s，闪避成功", card_m[card].suit))
                    dodge_success(player1, player2)
                else
                    print(string.format("八卦阵判定结果为%s，闪避失败", card_m[card].suit))
                    query_dodge(player1, player2)
                end
                table.insert(discard_pile, card)
                break
            elseif io_data == "n" then
                query_dodge(player1, player2)  
                break
            else
                print("输入错误，请重新输入：")
            end
        end
end

function equip.use_qinglongyanyuedao(player1, player2, kills)
    print(string.format("%s可以使用的杀手牌id：%s", player1.name, table.concat(kills, " ")))
    print(string.format("%s输入要出的杀的牌id：", player1.name))
    while true do
        local io_data = io.read()
        if helper.element(kills, tonumber(io_data)) then
            helper.delete(player1.hand_cards, tonumber(io_data))
            table.insert(discard_pile, tonumber(io_data))
            basic.block_by_armor(player1, player2, helper.get_kill_color(tonumber(io_data)))
            break
        else
            print("输入错误，请重新输入：")
        end
    end
end

function equip.use_guanshifu(player1, player2)
    local i = 1
    while i <= 2 do
        local equip_cards = equip.get_equip(player1)
        helper.delete(equip_cards, card_m[player1.arm].id)
        local s = ""
        s = s..helper.id_to_id_and_name(player1.hand_cards)..helper.id_to_id_and_name(equip_cards)
        print(string.format("%s可以弃置的牌：%s", player1.name, s))
        print(string.format("输入%s想弃置的牌id：", player1.name))
        local io_data = io.read()
        if helper.element(equip_cards, tonumber(io_data)) then
            if player1.arm == tonumber(io_data) then
                player1.arm = nil
            elseif player1.armor == tonumber(io_data) then
                player1.armor = nil
            elseif player1.add_dis_horse == tonumber(io_data) then
                player1.add_dis_horse = nil
            else
                player1.sub_dis_horse = nil
            end
            table.insert(discard_pile, tonumber(io_data))
            i = i + 1
        elseif helper.element(player1.hand_cards, tonumber(io_data)) then
            helper.delete(player1.hand_cards,tonumber(io_data))
            table.insert(discard_pile, tonumber(io_data))
            i = i + 1
        else
            print("输入错误，请重新输入：")
        end 
    end
    damage.when_damage(player1, player2, "kill", 1)
end

function equip.use_qilingong(player1, player2)
    local horses = {}
    if player2.add_dis_horse then
        table.insert(horses, player2.add_dis_horse)
    end
    if player2.sub_dis_horse then
        table.insert(horses, player2.sub_dis_horse)
    end
    print(string.format("%s拥有的马匹：%s", player2.name, helper.id_to_id_and_name(horses)))
    print(string.format("输入%s想弃置的%s的马匹id：", player1.name, player2.name))
    while true do
        local io_data = io.read()
        if helper.element(horses, tonumber(io_data)) then
            if player2.add_dis_horse == tonumber(io_data) then
                player2.add_dis_horse = nil
            else
                player2.sub_dis_horse = nil
            end
            table.insert(discard_pile, tonumber(io_data))
            break
        else
            print("输入错误，请重新输入：")
        end
    end
end

function equip.use_hanbingjian(player1, player2)
    local n = #player2.hand_cards + #equip.get_equip(player2)
    if n > 2 then
        n = 2
    end
    local i = 1
    while i <= n do
        local equip_cards = equip.get_equip(player2)
        local s = ""
        for i1 = 1, #player2.hand_cards, 1 do
            s = s.."手牌"..tostring(i1).." "
        end
        s = s..helper.id_to_id_and_name(equip_cards)
        print(string.format("%s可以弃置的%s的牌：%s，还可以弃置%s的%d张牌", player1.name, player2.name, s, player2.name, n - i + 1))
        if next(equip_cards) then
            print(string.format("想弃置%s装备区的牌，输入对应id：", player2.name))
        end
        if next(player2.hand_cards) ~= nil then
            print(string.format("想随机弃置%s的一张手牌，输入hand_card：", player2.name))    
        end
        local io_data = io.read()
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
            i = i + 1
        elseif io_data == "hand_card" and next(player2.hand_cards) ~= nil then
            local n1 = math.random(#player2.hand_cards)
            local id = player2.hand_cards[n1]
            table.remove(player2.hand_cards, n1)
            table.insert(discard_pile, id)
            i = i + 1
        else
            print("输入错误，请重新输入：")
        end
    end
end

function equip.use_zhangbashemao(player)
    local cards = {}
    local i = 1
    while i <= 2 do
        print(string.format("%s当前的手牌为：%s", player.name, helper.id_to_id_and_name(player.hand_cards)))
        print(string.format("请输入%s想丢弃的手牌id：", player.name))
        local io_data = io.read()
        if helper.element(player.hand_cards, tonumber(io_data)) then
            helper.delete(player.hand_cards, tonumber(io_data))
            table.insert(discard_pile, tonumber(io_data))
            table.insert(cards, tonumber(io_data))
            i = i + 1
        else
            print("输入错误，请重新输入：")            
        end
    end
    local color
    if card_m[cards[1]].suit == "红桃" or card_m[cards[1]].suit == "方块" then
        if card_m[cards[2]].suit == "红桃" or card_m[cards[2]].suit == "方块" then
            color = "红色"
        end
    end
    if card_m[cards[1]].suit == "黑桃" or card_m[cards[1]].suit == "梅花" then
        if card_m[cards[2]].suit == "黑桃" or card_m[cards[2]].suit == "梅花" then
            color = "黑色"
        end
    end
    basic.kill(player, color)
end

function equip.get_equip(player)
    local equip_cards = {}
    if player.arm then
        table.insert(equip_cards, player.arm)
    end
    if player.armor then
        table.insert(equip_cards, player.armor)
    end
    if player.add_dis_horse then
        table.insert(equip_cards, player.add_dis_horse)
    end
    if player.sub_dis_horse then
        table.insert(equip_cards, player.sub_dis_horse)
    end
    return equip_cards
end

return equip