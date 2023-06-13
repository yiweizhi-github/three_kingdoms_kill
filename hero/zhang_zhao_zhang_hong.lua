ZhangZhaoZhangHong = class(Player)

ZhangZhaoZhangHong.skill["固政"] = function (self, discard_player, cards)
    if not query["询问发动技能"]("固政") then
        return
    end
    local id = query["选择一张牌"](cards, "固政")
    helper.remove(deck.discard_pile, cards)
    helper.insert(discard_player.hand_cards, id)
    helper.remove(cards, id)
    helper.insert(self.hand_cards, cards)
end

ZhangZhaoZhangHong.get_t["直谏"] = function (self)
    local t = {}
    local func = function (id) return resmng[id].type ~= "basic" and resmng[id].type ~= "tactic" end
    local cards = self:get_cards(func, true)
    for _, id in ipairs(cards) do
        local targets = {}
        for _, target in ipairs(game:get_other_players(self)) do
            if not target:has_equip(resmng[id].type) then
                helper.insert(targets, target)
            end
        end
        if next(targets) then
            t[id] = targets
        end
    end
    return t
end

ZhangZhaoZhangHong.check_skill["直谏"] = function (self)
    if not next(self.get_t["直谏"](self)) then
        return false
    end
    return true
end

ZhangZhaoZhangHong.skill["直谏"] = function (self)
    local t = self.get_t["直谏"](self)
    local cards  = helper.get_keys(t)
    local id = query["选择一张牌"](cards, "直谏")
    local target = query["选择一名玩家"](t[id], "直谏")
    helper.remove(self.hand_cards, id)
    target:put_on_equip(id)
    helper.insert(self.hand_cards, deck:draw(1))
end

return ZhangZhaoZhangHong