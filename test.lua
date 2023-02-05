discard_pile = {}
order = {"aa", "bb", "cc", "dd"}
players = {
    aa = {
        name = "aa",
        life = 3,
        life_limit = 4,
        hand_cards = {},
        arm = nil,
        armor = nil,
        add_dis_horse = nil,
        sub_dis_horse = nil,
        judge_cards = {},
        sex = "man",
        flag = {} -- 特殊flag
    },
    bb = {
        name = "bb",
        life = 3,
        life_limit = 4,
        hand_cards = {1, 1, 1},
        arm = nil,
        armor = nil,
        add_dis_horse = nil,
        sub_dis_horse = nil,
        judge_cards = {},
        sex = "woman",
        flag = {} -- 特殊flag
    },
    cc = {
        name = "cc",
        life = 3,
        life_limit = 4,
        hand_cards = {1, 2},
        arm = nil,
        armor = nil,
        add_dis_horse = nil,
        sub_dis_horse = nil,
        judge_cards = {},
        flag = {} -- 特殊flag
    },
    dd = {
        name = "dd",
        life = 3,
        life_limit = 4,
        hand_cards = {1, 2},
        arm = nil,
        armor = nil,
        add_dis_horse = nil,
        sub_dis_horse = nil,
        judge_cards = {},
        flag = {} -- 特殊flag
    }
}

basic = loadfile("basic.lua")()
card_m = loadfile("card_m.lua")()
card_pile_m = loadfile("card_pile_m.lua")()
damage = loadfile("damage.lua")()
equip = loadfile("equip.lua")()
helper = loadfile("helper.lua")()
tactic = loadfile("tactic.lua")()

card_pile = card_pile_m.init()

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

function test()
    local p1 = players["aa"]
    local p2 = players["bb"]
    local p3 = players["cc"]

    p1.hand_cards = {1, 1, 1}
    p1.judge_cards = {61, 62, 61, 62}
    p2.hand_cards = {46, 46}
    p3.hand_cards = {1, 1}
    p3.life = 1
    helper.print_info()
    judge(players["aa"]) 
    helper.print_info()
end

test()