damage = {}

function damage.when_damage(player1, player2, type, n)
    if type == "kill" then
        if player1.arm and card_m[player1.arm].name == "麒麟弓" and (player2.add_dis_horse or player2.sub_dis_horse) then
            print("是否发动麒麟弓？输入y或n:")
            while true do
                local io_data = io.read()
                if io_data == "y" then
                    equip.use_qilingong(player1, player2)
                    break
                elseif io_data == "n" then
                    break
                else
                    print("输入错误，请重新输入：")
                end
            end
            when_be_damaged(player1, player2, n)
        elseif player1.arm and card_m[player1.arm].name == "寒冰剑" and #player2.hand_cards + #equip.get_equip(player2) > 0 then
            print("是否发动寒冰剑？输入y或n:")
            while true do
                local io_data = io.read()
                if io_data == "y" then
                    equip.use_hanbingjian(player1, player2)
                    break
                elseif io_data == "n" then
                    when_be_damaged(player1, player2, n)
                    break
                else
                    print("输入错误，请重新输入：")
                end
            end
        else
            when_be_damaged(player1, player2, n)
        end
    else
        when_be_damaged(player1, player2, n)
    end
end

function when_be_damaged(player1, player2, n)
    sub_life(player1, player2, n)
end

function sub_life(player1, player2, n)
    player2.life = player2.life - n
    if player2.life <= 0 then
        dying(player1, player2)
    else
        after_damage(player1, player2)
    end
end

function dying(player1, player2)
    local player_orders = {}
    local pos = helper.find(order, player2.name)
    for i = pos, #order, 1 do
        table.insert(player_orders, i)        
    end
    for i = 1, pos - 1, 1 do
        table.insert(player_orders, i)        
    end
    local i = 1
    while true do
        local player = players[order[player_orders[i]]]
        local alive = false
        print(string.format("%s即将死亡，询问%s是否出桃", player2.name, player.name))
        local peachs = helper.check_card_in_hand_cards(player.hand_cards, "桃")
        if next(peachs) == nil then
            print(string.format("%s手上没有桃", player.name))
        else
            while true do
                print(string.format("%s可以使用的桃手牌id：%s", player.name, table.concat(peachs, " ")))
                print("是否出桃？出输入牌id，不出输入n：")
                local use_peach = false
                while true do
                    local io_data = io.read()
                    if helper.element(peachs, tonumber(io_data)) then
                        helper.delete(player.hand_cards, tonumber(io_data))
                        player2.life = player2.life + 1
                        if player2.life > 0 then
                            alive = true
                        end
                        table.insert(discard_pile, tonumber(io_data))
                        helper.delete(peachs, tonumber(io_data))
                        use_peach = true
                        break
                    elseif io_data == "n" then
                        break
                    else
                        print("输入错误，请重新输入：")
                    end
                end
                if not use_peach or alive or next(peachs) == nil then
                    break
                end
            end
        end
        if alive then
            after_damage(player1, player2)
            break
        end
        if i == #player_orders then
            dead(player1, player2)
            break
        else
            i = i + 1
        end
    end
end

function after_damage(player1, player2)
    after_be_damaged(player1, player2)
end

function after_be_damaged(player1, player2)

end

function dead(player1, player2)
    helper.insert_tail(discard_pile, player2.hand_cards)
    player2.hand_cards = {}
    helper.insert_tail(discard_pile, player2.judge_cards)
    player2.judge_cards = {}
    if player2.arm  then
        table.insert(discard_pile, player2.arm)
        player2.arm = nil
    end
    if player2.armor then
        table.insert(discard_pile, player2.armor)
        player2.armor = nil
    end
    if player2.add_dis_horse then
        table.insert(discard_pile, player2.add_dis_horse)
        player2.add_dis_horse = nil
    end
    if player2.sub_dis_horse then
        table.insert(discard_pile, player2.sub_dis_horse)
        player2.sub_dis_horse = nil
    end
    helper.delete(order, player2.name)
    players[player2.name] = nil
    local cards = card_pile_m.draw(card_pile, discard_pile, 3)
    if player1 then
        helper.insert_tail(player1.hand_cards, cards) 
    end
    print(string.format("%s已经死亡", player2.name))
end

return damage