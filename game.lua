Game = class()

Game.skill = {}

function Game:init()
    self.players = {}
    self.whose_turn = nil -- 当前是谁的回合
    self.transfer_delay_tactics = {} -- 记录大乔-国色转化的乐不思蜀
    self.old_kill_target = nil -- 使用方天画戟或天义时，若大乔流离转移，则此变量指向大乔避免其再次成为可选目标
    self.settling_card = {}
    self.finish = false
    self.settle_players = {} -- 回合顺序
    
    -- local hero_ids = {}
    -- for i = 1, 4, 1 do
    --     local hero_id = math.random(resmng.hero_finish_id - resmng.hero_start_id + 2 - i)
    --     for _, hero_id1 in ipairs(hero_ids) do
    --         if hero_id >= hero_id1 then
    --             hero_id = hero_id + 1
    --         end
    --     end
    --     helper.insert(hero_ids, hero_id)
    --     table.sort(hero_ids)
    --     hero_id = hero_id + resmng.hero_start_id - 1
    --     local hero_class = require("hero." .. resmng[hero_id].module_name)
    --     local player = hero_class.new(i, hero_id, i)
    --     helper.insert(self.players, player)
    --     helper.insert(player.hand_cards, deck:draw(4))
    -- end
end

function Game:get_player(id)
    for _, player in ipairs(self.players) do
        if player.id == id then
            return player
        end
    end
end

function Game:get_other_players(player)
    local players = {}
    for _, player1 in ipairs(self.players) do
        if player1 ~= player then
            helper.insert(players, player1)
        end
    end
    return players
end

function Game:compare_points(player1, player2)
    local id1 = query["选择一张牌"](player1.hand_cards, "拼点")
    helper.remove(player1.hand_cards, id1)
    self.skill["失去手牌"](self, player1, player1, "拼点")
    local id2 = query["选择一张牌"](player2.hand_cards, "拼点")
    helper.remove(player2.hand_cards, id2)
    self.skill["失去手牌"](self, player2, player2, "拼点")
    text("%s的点数为:%d", player1.name, resmng[id1].points)
    text("%s的点数为:%d", player2.name, resmng[id2].points)
    helper.insert(deck.discard_pile, {id1, id2})
    return resmng[id1].points > resmng[id2].points
end

function Game:judge(player, reason)
    local id = deck:draw(1)
    text("判定牌为%d-%s, 花色为%s, 点数为%d", id, resmng[id].name, get_suit_str(player:get_suit(id)), resmng[id].points)
    id = self.skill["改判"](self, player, id, player, reason)
    return id
end

Game.skill["改判"] = function (self, first_settle_player, id, judge_player, reason)
    local settle_players = self:get_settle_players(first_settle_player)
    for _, settle_player in ipairs(settle_players) do
        local id1 = settle_player.skill["改判"](settle_player, id, judge_player, reason)
        if id1 then
            return self.skill["改判"](self, settle_player, id1, judge_player, reason)          
        end
    end
    return id
end

Game.skill["失去手牌"] = function (self, causer, responder, reason)
    local settle_players = self:get_settle_players(self.whose_turn)
    for _, player in ipairs(settle_players) do
        player.skill["失去手牌"](player, causer, responder, reason)
    end
end

Game.skill["造成伤害时"] = function (self, causer, responder, t)
    local settle_players = self:get_settle_players(self.whose_turn)
    for _, player in ipairs(settle_players) do
        player.skill["造成伤害时"](player, causer, responder, t)
    end
end

Game.skill["受到伤害时"] = function (self, causer, responder, t)
    local settle_players = self:get_settle_players(self.whose_turn)
    for _, player in ipairs(settle_players) do
        player.skill["受到伤害时"](player, causer, responder, t)
    end
end

Game.skill["造成伤害后"] = function (self, causer, responder, t)
    local settle_players = self:get_settle_players(self.whose_turn)
    for _, player in ipairs(settle_players) do
        player.skill["造成伤害后"](player, causer, responder, t)
    end
end

Game.skill["受到伤害后"] = function (self, causer, responder, t)
    local settle_players = self:get_settle_players(self.whose_turn)
    for _, player in ipairs(settle_players) do
        player.skill["受到伤害后"](player, causer, responder, t)
    end
end

function Game:main()
    while true do
        self.settle_players = self:get_settle_players(self.players[1])
        for _, player in ipairs(self.settle_players) do
            if not player:check_alive() then
                goto continue
            end
            if player:check_jump_turn() then
                goto continue
            end
            player:before_turn()
            player:turn()
            if self.finish then
                text("恭喜%s杀死所有敌人，赢得最终胜利！", self.players[1].name)
                return
            end
            player:after_turn()
            ::continue::
        end
    end
end

-- 判定牌可能由大乔-国色转换而来，所以要判断下
function Game:get_judge_card_name(id)
    if self.transfer_delay_tactics[id] then
        return self.transfer_delay_tactics[id]
    else
        return resmng[id].name
    end
end

-- 获取一个将玩家按照结算顺序依次排列的列表，
-- 比如有玩家1、2、3、4，输入的player参数为玩家3，
-- 则结算列表为{玩家3，玩家4，玩家1，玩家2} 
function Game:get_settle_players(player)
    local settle_players = {}
    for i = player.order, #self.players, 1 do
        helper.insert(settle_players, self.players[i])          
    end
    for i = 1, player.order - 1, 1 do
        helper.insert(settle_players, self.players[i])                 
    end
    return settle_players
end

-- 获取一个将玩家按照结算顺序依次排列的列表，
-- 但列表中不包含player代表的玩家
function Game:get_settle_players_except_self(player)
    local settle_players = {}
    for i = player.order + 1, #self.players, 1 do
        helper.insert(settle_players, self.players[i])          
    end
    for i = 1, player.order - 1, 1 do
        helper.insert(settle_players, self.players[i])                 
    end
    return settle_players
end

return Game