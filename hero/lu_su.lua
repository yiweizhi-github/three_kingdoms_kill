LuSu = class(Player)

function LuSu:draw()
    text("现在是%s的摸牌阶段", self.name)
    if self:has_flag("跳过摸牌") then
        return
    end
    self.skill["好施"](self)
end

LuSu.skill["好施"] = function (self)
    if not query["询问发动技能"]("好施") then
        return false
    end
    helper.insert(self.hand_cards, deck:draw(4))
    if #self.hand_cards > 5 then
        local n = math.floor(#self.hand_cards)
        local cards = {}
        for _ = 1, n, 1 do
            local id = query["选择一张牌"](self.hand_cards, "好施")
            helper.remove(self.hand_cards, id)
            helper.insert(cards, id)
        end
        local min_n = #game.players[1].hand_cards
        local targets = {game.players[1]}
        for i = 2, #game.players, 1 do
            if #game.players[i].hand_cards == min_n then
                helper.insert(targets, game.players[i])
            elseif #game.players[i].hand_cards < min_n then
                min_n = #game.players[i].hand_cards
                helper.clear(targets)
                helper.insert(targets, game.players[i])
            end
        end
        local target = query["选择一名玩家"](targets, "好施")
        helper.insert(target.hand_cards, cards)
    end
end

LuSu.get_t["缔盟"] = function (self)
    local others1 = game:get_other_players(self)
    if #others1 < 2 then
        return {}
    end
    local t = {}
    for _, target in ipairs(others1) do
        local targets = {}
        local others2 = game:get_other_players(target)
        helper.remove(others2, self)
        for _, target1 in ipairs(others2) do
            local n = math.abs(#target.hand_cards - #target1.hand_cards)
            local cards = self:get_cards(self, nil, true, true)
            if #cards >= n then
                helper.insert(targets, target1)
            end
        end
        if next(targets) then
            t[target] = targets
        end
    end
    return t
end

LuSu.check_skill["缔盟"] = function (self)
    if self:has_flag("使用过缔盟") then
        return false
    end
    if not next(self.get_t["缔盟"](self)) then
        return false
    end
    return true
end

LuSu.skill["缔盟"] = function (self)
    self.flags["使用过缔盟"] = true
    local t = self.get_t["缔盟"](self)
    local targets = helper.get_keys(t)
    local target1 = query["选择一名玩家"](targets, "缔盟")
    local target2 = query["选择一名玩家"](t[target1], "缔盟")
    local n = math.abs(#target1.hand_cards - #target2.hand_cards)
    opt["弃置n张牌"](self, self, "缔盟", true, true, n)
    target1.hand_cards, target2.hand_cards = target2.hand_cards, target1.hand_cards
end

return LuSu