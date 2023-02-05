basic = loadfile("basic.lua")()
card_m = loadfile("card_m.lua")()
card_pile_m = loadfile("card_pile_m.lua")()
damage = loadfile("damage.lua")()
equip = loadfile("equip.lua")()
helper = loadfile("helper.lua")()
tactic = loadfile("tactic.lua")()

card_pile = card_pile_m.init()
discard_pile = {}
order = {"aa", "bb", "cc", "dd"}
players = {
    aa = {
        name = "aa",
        life = 3,
        life_limit = 3,
        hand_cards = {},
        judge_cards = {},
        sex = "man",
        flag = {} -- 特殊flag
    },
    bb = {
        name = "bb",
        life = 3,
        life_limit = 3,
        hand_cards = {},
        judge_cards = {},
        sex = "woman",
        flag = {} -- 特殊flag
    },
    cc = {
        name = "cc",
        life = 3,
        life_limit = 3,
        hand_cards = {},
        judge_cards = {},
        sex = "man",
        flag = {} -- 特殊flag
    },
    dd = {
        name = "dd",
        life = 3,
        life_limit = 3,
        hand_cards = {},
        judge_cards = {},
        sex = "woman",
        flag = {} -- 特殊flag
    }
}

local game_finish = false

function main()
    for _, v in ipairs(order) do
        local player = players[v]
        local cards = card_pile_m.draw(card_pile, discard_pile, 4)
        helper.insert_tail(player.hand_cards, cards)
    end
    helper.print_info()
    while true do
        for _, player_name in ipairs(order) do
            turn(players[player_name])
        end
        if game_finish then
            print(string.format("恭喜%s杀死所有敌人，赢得最终胜利！！！", players[order[1]].name))
            break
        end
    end
end

function turn(player)
    print(string.format("现在是%s的回合", player.name))
    start(player)
    print(string.format("现在是%s的判定阶段", player.name))  
    judge(player)
    if game_finish then
        return
    end
    if players[player.name] then
        print(string.format("现在是%s的摸牌阶段", player.name))  
        draw(player)
        print(string.format("%s摸了两张牌", player.name))
    end
    if players[player.name] and not player.flag["jump_play"] then
        print(string.format("现在是%s的出牌阶段", player.name))  
        play(player)
    end
    if game_finish then
        return
    end
    if players[player.name] then
        print(string.format("现在是%s的弃牌阶段", player.name))  
        discard(player)     
    end
    if players[player.name] then
        finish(player)
        print(string.format("%s的回合已结束", player.name))  
    end
    if players[player.name] then
        player.flag["use_kill"] = false
        player.flag["jump_play"] = false
    end
end

function start(player)
end

function judge(player)
    while next(player.judge_cards) do
        local card_id = player.judge_cards[1]
        if card_m[card_id].name == "乐不思蜀" then
            tactic.judge_lebusishu(player)
        elseif card_m[card_id].name == "闪电" then
            tactic.judge_shandian(player)
        end
        if #order == 1 then
            game_finish = true
            return
        else
            if not players[player.name] then
                return
            end
        end
    end
end

function draw(player)
    local cards = card_pile_m.draw(card_pile, discard_pile, 2)
    helper.insert_tail(player.hand_cards, cards)
end

function play(player)
    while true do
        print(string.format("%s当前的手牌为：%s", player.name, helper.id_to_id_and_name(player.hand_cards)))
        local can_use_cards = helper.check_can_use_card(player)
        if next(can_use_cards) then
            print(string.format("%s当前可用的牌为：%s", player.name, helper.id_to_id_and_name(can_use_cards)))
            print(string.format("请输入%s想使用的一张牌，输入exit进入弃牌阶段：", player.name))
            local io_data = io.read()
            if helper.element(can_use_cards, tonumber(io_data)) then
                helper.delete(player.hand_cards, tonumber(io_data))
                use_card(player, tonumber(io_data))
                helper.print_info()
                if #order == 1 then
                    game_finish = true
                    break
                end
            elseif io_data == "exit" then
                break
            else
                print("输入错误，请重新输入：")
            end
        else
            print(string.format("%s当前没有可以使用的手牌", player.name, helper.id_to_id_and_name(can_use_cards)))
            break
        end        
    end
end

function discard(player)
    if #player.hand_cards > player.life then
        local n = #player.hand_cards - player.life
        local tmp = {}
        for i = 1, n, 1 do
            while true do    
                print(string.format("%s当前的手牌为：%s", player.name, helper.id_to_id_and_name(player.hand_cards)))
                print(string.format("请输入%s想丢弃的一张牌，当前还需丢弃%d张：", player.name, n + 1 - i ))
                local io_data = io.read()
                if helper.element(player.hand_cards, tonumber(io_data)) then
                    helper.delete(player.hand_cards, tonumber(io_data))
                    table.insert(tmp, tonumber(io_data))
                    break
                else
                    print("输入错误，请重新输入：")            
                end
            end
        end
        helper.insert_tail(discard_pile, tmp)
    end
end

function finish(player)
end

function use_card(player, card_id)
    if card_m[card_id].type == "basic" or card_m[card_id].type == "tactic" then
        if card_m[card_id].name == "杀" then
            basic.kill(player, helper.get_kill_color(card_id))
        elseif card_m[card_id].name == "桃" then
            basic.peach(player)
        elseif card_m[card_id].name == "南蛮入侵" then
            tactic.nanmanruqin(player)
        elseif card_m[card_id].name == "万箭齐发" then
            tactic.wanjianqifa(player)
        elseif card_m[card_id].name == "桃园结义" then
            tactic.taoyuanjieyi(player)
        elseif card_m[card_id].name == "五谷丰登" then
            tactic.wugufengdeng(player)
        elseif card_m[card_id].name == "决斗" then
            tactic.juedou(player)
        elseif card_m[card_id].name == "顺手牵羊" then
            tactic.shunshouqianyang(player)
        elseif card_m[card_id].name == "过河拆桥" then
            tactic.guohechaiqiao(player)
        elseif card_m[card_id].name == "无中生有" then
            tactic.wuzhongshengyou(player)
        elseif card_m[card_id].name == "借刀杀人" then
            tactic.jiedaosharen(player)
        elseif card_m[card_id].name == "乐不思蜀" then
            tactic.lebusishu(player, card_id)
        elseif card_m[card_id].name == "闪电" then
            tactic.shandian(player, card_id)
        end
        table.insert(discard_pile, card_id)
    else
        if player.arm == card_id and card_m[player.arm].name == "丈八蛇矛" then
            equip.use_zhangbashemao(player)
        else
            table.insert(discard_pile, player[card_m[card_id].type])
            player[card_m[card_id].type] = card_id
        end
    end
end

main()