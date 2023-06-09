require("class")
require("deck")
require("game")
require("helper")
require("macro")
require("opt")
require("player")
require("query")
require("resmng")

function new_test_hero(hero_id)
    local hero_class = require("hero." .. resmng[hero_id].module_name)
    local player = hero_class.new(#game.players + 1, hero_id, #game.players + 1)
    helper.insert(game.players, player)
    return player
end

function new_player_no_skill()
    local player = Player.new(#game.players + 1, 220, #game.players + 1)
    helper.clear(player.skills)
    helper.insert(game.players, player)
    helper.insert(player.hand_cards, deck:draw(4))
    return player
end

deck = Deck:new()
game = Game:new()

deck:init()
game:init()

-- game模块测试
-- game.whose_turn = game.players[2]
-- local player2 = game:get_player(2)
-- print(player2.id, player2.name)
-- local other_players = game:get_other_players(player2)
-- for _, player in ipairs(other_players) do
--     print(player.id, player.name)
-- end
-- local player1 = game:get_player(1)
-- helper.insert(player1.hand_cards, 13)
-- helper.insert(player2.hand_cards, 13)
-- for _ = 1, 3, 1 do
--     print_player_info(player1)
--     print_player_info(player2)
--     print(game:compare_points(player1, player2))
--     print(deck.discard_pile[#deck.discard_pile], deck.discard_pile[#deck.discard_pile - 1])
--     print_player_info(player1)
--     print_player_info(player2)
-- end
-- print(game:get_judge_card_name(1))
-- game.transfer_delay_tactics[1] = "乐不思蜀"
-- print(game:get_judge_card_name(1))
-- local settle_players = game:get_settle_players(player2)
-- for _, player in ipairs(settle_players) do
--     print(player.id, player.name)
-- end
-- local settle_players = game:get_settle_players_except_self(player2)
-- for _, player in ipairs(settle_players) do
--     print(player.id, player.name)
-- end

-- player模块测试
-- local player1 = game.players[1]
-- local player2 = game.players[2]
-- local player3 = game.players[3]
-- local player4 = game.players[4]
-- helper.clear(player1.hand_cards)
-- helper.clear(player2.hand_cards)
-- helper.clear(player3.hand_cards)
-- helper.clear(player4.hand_cards)
-- game.whose_turn = player1
-- player1.life = -11
-- helper.insert(player1.judge_cards, 61)
-- table.insert(deck.card_pile, 1, 1)
-- helper.insert(player1.hand_cards, {75})
-- helper.insert(player2.hand_cards, {46})
-- helper.insert(player3.hand_cards, {66, 66, 66})
-- helper.insert(player4.hand_cards, {66, 66})
-- player1:play()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 黄月英测试
-- local player1 = new_test_hero(201)
-- game.whose_turn = player1
-- helper.insert(player1.hand_cards, {70, 63})
-- local player2 = new_player_no_skill()
-- local player3 = new_player_no_skill()
-- local player4 = new_player_no_skill()
-- local player5 = new_player_no_skill()
-- player1:play()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 关羽测试
-- local player1 = new_test_hero(202)
-- game.whose_turn = player1
-- helper.insert(player1.hand_cards, {1, 45, 45, 45, 45, 45, 91})
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {54, 81, 1, 1})
-- player2.life = 10
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 刘备测试
-- local player1 = new_test_hero(203)
-- player1.life = 3
-- game.whose_turn = player1
-- helper.insert(player1.hand_cards, {1, 45, 45, 45, 45, 45, 91, 23})
-- local player2 = new_player_no_skill()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 张飞测试
-- local player1 = new_test_hero(204)
-- game.whose_turn = player1
-- helper.insert(player1.hand_cards, {1, 1, 1, 1})
-- local player2 = new_player_no_skill()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 诸葛亮测试
-- local player1 = new_test_hero(205)
-- player1.life = 3
-- game.whose_turn = player1
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {1, 81})
-- local player3 = new_player_no_skill()
-- local player4 = new_player_no_skill()
-- -- player2.flags["跳过判定"] = true
-- -- player2.flags["跳过摸牌"] = true
-- -- player2.flags["跳过弃牌"] = true
-- -- player2:before_turn()
-- -- player2:turn()
-- -- player2:after_turn()
-- -- helper.insert(player1.hand_cards, 3)
-- -- player2.flags["跳过判定"] = true
-- -- player2.flags["跳过摸牌"] = true
-- -- player2.flags["跳过弃牌"] = true
-- -- player2:before_turn()
-- -- player2:turn()
-- -- player2:after_turn()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))
-- text("牌堆底:%s", t2s({ deck.card_pile[#deck.card_pile - 3], deck.card_pile[#deck.card_pile - 2], deck.card_pile[#deck.card_pile - 1], deck.card_pile[#deck.card_pile]}))

-- 赵云测试
-- local player1 = new_test_hero(206)
-- game.whose_turn = player1
-- helper.insert(player1.hand_cards, {1, 45, 45, 45, 45, 45})
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {54, 81, 1, 57})
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 马超测试
-- local player1 = new_test_hero(207)
-- game.whose_turn = player1
-- helper.insert(player1.hand_cards, {1, 1, 91, 70})
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {45, 45})
-- player2:put_on_equip(105)
-- table.insert(deck.card_pile, 1, 47)
-- table.insert(deck.card_pile, 2, 54)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 甄姬测试
-- local player1 = new_test_hero(208)
-- helper.insert(player1.hand_cards, {})
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {1, 57})
-- table.insert(deck.card_pile, 1, 1)
-- table.insert(deck.card_pile, 2, 1)
-- table.insert(deck.card_pile, 3, 56)
-- table.insert(deck.card_pile, 4, 48)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 司马懿测试
-- local player1 = new_test_hero(209)
-- helper.insert(player1.hand_cards, {1, 57, 43, 88})
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {1, 57})
-- player2:put_on_equip(108)
-- helper.put(player2.judge_cards, 61)
-- table.insert(deck.card_pile, 1, 77)
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 夏侯惇测试
-- local player1 = new_test_hero(210)
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {57, 57, 57})
-- table.insert(deck.card_pile, 1, 1)
-- table.insert(deck.card_pile, 2, 1)
-- table.insert(deck.card_pile, 3, 1)
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 张辽测试
-- local player1 = new_test_hero(211)
-- local player2 = new_player_no_skill()
-- local player3 = new_player_no_skill()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 曹操测试
-- local player1 = new_test_hero(212)
-- local player2 = new_test_hero(212)
-- local player3 = new_player_no_skill()
-- helper.insert(player3.hand_cards, {57, 57, 57})
-- player3.flags["跳过判定"] = true
-- player3.flags["跳过弃牌"] = true
-- player3:before_turn()
-- player3:turn()
-- player3:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 许褚测试
-- local player1 = new_test_hero(213)
-- local player2 = new_player_no_skill()
-- helper.insert(player1.hand_cards, {1, 81, 81})
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 郭嘉测试
-- local player1 = new_test_hero(214)
-- helper.put(player1.judge_cards, 63)
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {1, 81, 81})
-- player1:judge()
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 大乔测试
-- local player1 = new_test_hero(215)
-- helper.insert(player1.hand_cards, {107, 102, 2})
-- local player2 = new_player_no_skill()
-- local player3 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {1, 81, 81})
-- table.insert(deck.card_pile, 1, 105)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- -- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 孙尚香测试
-- local player1 = new_test_hero(216)
-- helper.insert(player1.hand_cards, {95, 100, 105, 106, 1})
-- local player2 = new_player_no_skill()
-- player2.life = 2
-- helper.insert(player2.hand_cards, {73, 73, 79})
-- table.insert(deck.card_pile, 1, 105)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 吕蒙测试
-- local player1 = new_test_hero(217)
-- helper.insert(player1.hand_cards, {95, 100, 100, 81, 100, 105, 106, 1, 1, 1})
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {81, 1})
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 周瑜测试
-- local player1 = new_test_hero(218)
-- helper.insert(player1.hand_cards, {1, 1, 1, 1, 1, 1})
-- local player2 = new_player_no_skill()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 孙权测试
-- local player1 = new_test_hero(219)
-- local player2 = new_player_no_skill()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player1.armor = 100
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 甘宁、陆逊测试
-- local player1 = new_test_hero(220)
-- local player2 = new_test_hero(221)
-- local player3 = new_player_no_skill()
-- helper.clear(player2.hand_cards)
-- helper.insert(player2.hand_cards, 17)
-- helper.insert(player1.hand_cards, {1, 1, 1, 1, 98, 99, 74})
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 黄盖、华佗测试
-- local player1 = new_test_hero(222)
-- player1.life = 1
-- local player2 = new_test_hero(224)
-- helper.insert(player2.hand_cards, {88, 105})
-- print(game.finish)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- print(game.finish)
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 吕布、貂蝉测试
-- local player1 = new_test_hero(223)
-- local player2 = new_test_hero(225)
-- local player3 = new_player_no_skill()
-- player3.sex = "woman"
-- local player4 = new_player_no_skill()
-- player4.sex = "woman"
-- helper.insert(player1.hand_cards, {99, 45, 74})
-- player1:put_on_equip(91)
-- helper.insert(player2.hand_cards, {1, 1, 1, 1, 81})
-- helper.insert(player3.hand_cards, {1, 1, 1, 1, 1, 1})
-- helper.insert(player4.hand_cards, {1, 1, 1, 1, 1, 1, 31, 31, 31})
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 魏延测试
-- local player1 = new_tsest_hero(226)
-- player1.life = 1
-- player1:put_on_equip(98)
-- helper.insert(player1.hand_cards, {1, 1, 1, 1, 1, 1, 46, 46, 46})
-- local player2 = new_player_no_skill()
-- helper.clear(player2.hand_cards)
-- player2:put_on_equip(105)
-- local player3 = new_player_no_skill()
-- helper.clear(player3.hand_cards)
-- player3:put_on_equip(105)
-- local player4 = new_player_no_skill()
-- helper.clear(player4.hand_cards)
-- player4:put_on_equip(105)
-- local player5 = new_player_no_skill()
-- helper.clear(player5.hand_cards)
-- player5:put_on_equip(105)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 黄忠测试
-- local player1 = new_test_hero(227)
-- player1.life = 3
-- player1:put_on_equip(90)
-- helper.insert(player1.hand_cards, {1, 1, 8, 8, 8, 8, 8, 9, 8})
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, 33)
-- player2:put_on_equip(105)
-- local player3 = new_player_no_skill()
-- helper.insert(player3.hand_cards, 33)
-- player3:put_on_equip(105)
-- local player4 = new_player_no_skill()
-- helper.insert(player4.hand_cards, 33)
-- player4:put_on_equip(105)
-- local player5 = new_player_no_skill()
-- helper.insert(player5.hand_cards, 33)
-- player5:put_on_equip(105)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 贾诩测试
-- local player1 = new_test_hero(246)
-- helper.insert(player1.hand_cards, {61, 62, 1})
-- local player3 = new_player_no_skill()
-- helper.insert(player3.hand_cards, 46)
-- helper.put(player3.judge_cards, 62)
-- table.insert(deck.card_pile, 1, 46)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player3.flags["跳过摸牌"] = true
-- player3.flags["跳过弃牌"] = true
-- player3:before_turn()
-- player3:turn()
-- player3:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 贾诩乱武测试
-- local player1 = new_test_hero(246)
-- player1:put_on_equip(105)
-- local player2 = new_test_hero(227)
-- helper.insert(player2.hand_cards, {30})
-- local player3 = new_player_no_skill()
-- helper.clear(player3.hand_cards)
-- player3:put_on_equip(105)
-- local player4 = new_test_hero(205)
-- helper.clear(player4.hand_cards)
-- local player5 = new_test_hero(215)
-- helper.insert(player5.hand_cards, {1})
-- player5:put_on_equip(105)
-- local player6 = new_player_no_skill()
-- helper.insert(player6.hand_cards, {1})
-- player6:put_on_equip(105)
-- player6:put_on_equip(96)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 夏侯渊测试
-- local player1 = new_test_hero(228)
-- helper.insert(player1.hand_cards, {1, 1, 1, 1, 1, 1, 1, 1})
-- player1:put_on_equip(105)
-- helper.put(player1.hand_cards, 61)
-- local player2 = new_player_no_skill()
-- player2.life = 6
-- helper.insert(player2.hand_cards, {1})
-- player2:put_on_equip(105)
-- player1:before_turn()
-- player1:turn()
-- player1:check_jump_turn()
-- player1:after_turn()
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 曹仁测试
-- local player1 = new_test_hero(229)
-- helper.insert(player1.hand_cards, {105})
-- player1:put_on_equip(106)
-- player1:put_on_equip(95)
-- helper.put(player1.judge_cards, 63)
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {75})
-- player2:put_on_equip(107)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- player1:check_jump_turn()
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 张郃测试
-- local player1 = new_test_hero(249)
-- helper.insert(player1.hand_cards, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1})
-- player1:put_on_equip(106)
-- player1:put_on_equip(95)
-- helper.put(player1.judge_cards, 63)
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {1})
-- player2:put_on_equip(105)
-- local player3 = new_player_no_skill()
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 小乔测试
-- local player1 = new_test_hero(230)
-- helper.insert(player1.hand_cards, {1, 1, 22})
-- helper.put(player1.judge_cards, 63)
-- local player2 = new_player_no_skill()
-- player2:put_on_equip(102)
-- local player3 = new_player_no_skill()
-- table.insert(deck.card_pile, 1, 1)
-- -- player1:before_turn()
-- -- player1:turn()
-- -- player1:after_turn()
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 周泰测试
-- local player1 = new_test_hero(231)
-- player1.life = 4
-- helper.insert(player1.hand_cards, {1, 2, 3, 4, 5, 6, 7, 8, 9, 48, 70})
-- local player2 = new_player_no_skill()
-- player2:put_on_equip(90)
-- helper.insert(player2.hand_cards, {1, 1, 1, 1, 1, 1, 1, 1, 48, 70, 75})
-- table.insert(deck.card_pile, 1, 97)
-- table.insert(deck.card_pile, 2, 99)
-- table.insert(deck.card_pile, 3, 97)
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 卧龙诸葛测试
-- local player1 = new_test_hero(233)
-- player1:put_on_equip(102)
-- helper.insert(player1.hand_cards, {1, 22})
-- local player2 = new_player_no_skill()
-- player2:put_on_equip(90)
-- helper.insert(player2.hand_cards, {1, 1, 22, 22, 54})
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 庞统测试
-- local player1 = new_test_hero(234)
-- player1.life = -2
-- player1:put_on_equip(90)
-- helper.put(player1.judge_cards, 61)
-- helper.insert(player1.hand_cards, {1, 50})
-- local player2 = new_player_no_skill()
-- player2:put_on_equip(90)
-- helper.insert(player2.hand_cards, {1, 1, 22, 22, 54})
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 典韦测试
-- local player1 = new_test_hero(235)
-- player1.life = 2
-- player1:put_on_equip(90)
-- helper.insert(player1.hand_cards, {1, 90})
-- local player2 = new_player_no_skill()
-- player2.life = 3
-- local player3 = new_player_no_skill()
-- player3.life = 1
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 荀彧测试
-- local player1 = new_test_hero(236)
-- helper.insert(player1.hand_cards, {1, 108})
-- player1:put_on_equip(105)
-- local player2 = new_player_no_skill()
-- helper.clear(player2.hand_cards)
-- helper.insert(player2.hand_cards, {1, 108})
-- -- player2:put_on_equip(105)
-- local player3 = new_player_no_skill()
-- -- helper.clear(player3.hand_cards)
-- -- helper.insert(player3.hand_cards, {1, 108})
-- player3:put_on_equip(105)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- player1:take_off_equip(105)
-- player2:take_off_equip(105)
-- player3:take_off_equip(105)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 太史慈测试
-- local player1 = new_test_hero(237)
-- helper.insert(player1.hand_cards, {1, 1, 98, 108})
-- player1:put_on_equip(90)
-- local player2 = new_player_no_skill()
-- local player3 = new_player_no_skill()
-- local player4 = new_test_hero(215)
-- helper.insert(player4.hand_cards, {1, 1, 1})
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过摸牌"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- 庞德测试
local player1 = new_test_hero(238)
helper.insert(player1.hand_cards, {1})
-- player1:put_on_equip(98)
local player2 = new_player_no_skill()
player2:put_on_equip(105)
helper.insert(player2.hand_cards, 32)
local player3 = new_player_no_skill()
helper.clear(player3.hand_cards)
helper.insert(player3.hand_cards, 2)
local player4 = new_test_hero(212)
helper.insert(player4.hand_cards, {32, 32})
player4:put_on_equip(105)
player1.flags["跳过判定"] = true
player1.flags["跳过摸牌"] = true
player1.flags["跳过弃牌"] = true
player1:before_turn()
player1:turn()
player1:after_turn()
text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 祝融测试
-- local player1 = new_player_no_skill()
-- player1.life = 2
-- player1:put_on_equip(90)
-- helper.insert(player1.hand_cards, {54, 54})
-- local player2 = new_test_hero(212)
-- helper.insert(player2.hand_cards, {1})
-- local player3 = new_test_hero(241)
-- helper.insert(player3.hand_cards, {1, 1, 1, 1, 1, 1, 105, 90})
-- -- player1.flags["跳过判定"] = true
-- -- player1.flags["跳过弃牌"] = true
-- -- player1:before_turn()
-- -- player1:turn()
-- -- player1:after_turn()
-- -- player2.flags["跳过判定"] = true
-- -- player2.flags["跳过摸牌"] = true
-- -- player2.flags["跳过弃牌"] = true
-- -- player2:before_turn()
-- -- player2:turn()
-- -- player2:after_turn()
-- player3.flags["跳过判定"] = true
-- player3.flags["跳过摸牌"] = true
-- player3.flags["跳过弃牌"] = true
-- player3:before_turn()
-- player3:turn()
-- player3:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))

-- -- 孟获测试
-- local player1 = new_test_hero(242)
-- player1:put_on_equip(90)
-- local player2 = new_player_no_skill()
-- helper.insert(player2.hand_cards, {54, 1, 83})
-- local player3 = new_test_hero(210)
-- table.insert(deck.card_pile, 1, 1)
-- player2.flags["跳过判定"] = true
-- player2.flags["跳过摸牌"] = true
-- player2.flags["跳过弃牌"] = true
-- player2:before_turn()
-- player2:turn()
-- player2:after_turn()
-- table.insert(deck.card_pile, 1, 97)
-- table.insert(deck.card_pile, 2, 57)
-- table.insert(deck.card_pile, 3, 17)
-- table.insert(deck.card_pile, 4, 17)
-- player1.flags["跳过判定"] = true
-- player1.flags["跳过弃牌"] = true
-- player1:before_turn()
-- player1:turn()
-- player1:after_turn()
-- text("弃牌堆:%s", t2s(deck.discard_pile))
