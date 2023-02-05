basic = {}

function basic.kill(player, color)
    local targets = basic.choose_kill_target(player)
    for _, v in ipairs(targets) do
        basic.block_by_armor(player, players[v], color)
    end
    player.flag["use_kill"] = true
end

function basic.choose_kill_target(player)
    local can_kill_players = helper.check_kill_targets(player)
    local targets = {}
    print(string.format("%s可以杀的玩家：%s", player.name, table.concat(can_kill_players, " ")))
    print(string.format("输入%s想杀的玩家：", player.name))
    while true do
        local io_data = io.read()
        if helper.element(can_kill_players, io_data) then
            table.insert(targets, io_data)
            helper.delete(can_kill_players, io_data)
            basic.after_choose_kill_target(player, can_kill_players, targets)           
            break
        else
            print("输入错误，请重新输入：")
        end
    end
    return targets
end

function basic.after_choose_kill_target(player, can_kill_players, targets)
    if player.arm and card_m[player.arm].name == "雌雄双股剑" and player.sex ~= players[targets[1]].sex then
        print("是否发动雌雄双股剑？输入y或n：")
        while true do
            local io_data = io.read()
            if io_data == "y" then
                equip.respond_cixiongshuanggu(player, players[targets[1]])
                break
            elseif io_data == "n" then
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    elseif player.arm and card_m[player.arm].name == "方天画戟" and #player.hand_cards == 0 then
        print("是否发动方天画戟？输入y或n：")
        while true do
            local io_data = io.read()
            if io_data == "y" then
                equip.use_fangtianhuaji(player, can_kill_players, targets)
                break
            elseif io_data == "n" then
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    end
end

function basic.block_by_armor(player1, player2, color)
    if not player2.armor or player1.arm and card_m[player1.arm].name == "青釭剑" then
         query_dodge(player1, player2)
    else
        if card_m[player2.armor].name == "仁王盾" then
            equip.use_renwangdun(player1, player2, color)
        elseif card_m[player2.armor].name == "八卦阵" then
            equip.use_baguazhen(player1, player2)
        end
    end
end

function query_dodge(player1, player2)
    local dodges = helper.check_card_in_hand_cards(player2.hand_cards, "闪")
    if next(dodges) == nil then
        print(string.format("%s手上没有闪", player2.name))
        damage.when_damage(player1, player2, "kill", 1)
    else
        print(string.format("%s可以使用的闪手牌id：%s", player2.name, table.concat(dodges, " ")))
        print("是否出闪？出输入牌id，不出输入n：")
        while true do
            local io_data = io.read()
            if helper.element(dodges, tonumber(io_data)) then
                helper.delete(player2.hand_cards, tonumber(io_data))
                table.insert(discard_pile, tonumber(io_data))
                dodge_success(player1, player2)
                break
            elseif io_data == "n" then
                damage.when_damage(player1, player2, "kill", 1)
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    end
end

function dodge_success(player1, player2)
    if player1.arm and card_m[player1.arm].name == "青龙偃月刀" then
        local kills = helper.check_card_in_hand_cards(player1.hand_cards, "杀")
        if next(kills) ~= nil then
            print("是否发动青龙偃月刀？输入y或n：")
            while true do
                local io_data = io.read()
                if io_data == "y" then
                    equip.use_qinglongyanyuedao(player1, player2, kills)
                    break
                elseif io_data == "n" then
                    break
                else
                    print("输入错误，请重新输入：")
                end
            end
        end
    elseif player1.arm and card_m[player1.arm].name == "贯石斧" and #player1.hand_cards + #equip.get_equip(player1) >= 3 then
        print("是否发动贯石斧？输入y或n：")
        while true do
            local io_data = io.read()
            if io_data == "y" then
                equip.use_guanshifu(player1, player2)
                break
            elseif io_data == "n" then
                break
            else
                print("输入错误，请重新输入：")
            end
        end
    end
end

function basic.peach(player)
    player.life = player.life + 1
end

return basic