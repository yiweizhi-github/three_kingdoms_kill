ZhangJiao = class(Player)

ZhangJiao.skill["改判"] = function (self, id)
    return self.skill["鬼道"](self, id)
end

ZhangJiao.skill["鬼道"] = function (self, id)
    local func = function (v) return resmng[v].suit == macro.suit.spade or resmng[v].suit == macro.suit.club end
    local cards = self:get_cards(func, true, true)
    if #cards == 0 then
        return
    end
    if not query["询问发动技能"]("鬼道") then
        return
    end
    local id1 = query["选择一张牌"](cards, "鬼道")
    helper.remove(self.hand_cards, id1)
    helper.insert(self.hand_cards, id)
    return id1
end

ZhangJiao.skill["雷击"] = function (self)
    if not query["询问发动技能"]("雷击") then
        return
    end
    local target = query["选择一名玩家"](self:get_other_players(), "雷击")
    local id = game:judge(target)
    if not (target:has_skill("天妒") and target.skill["天妒"](target, id)) then
        helper.insert(deck.discard_pile, id)   
    end
    if target:get_suit(id) == macro.suit.spade then
        target:sub_life({causer = self, type = macro.sub_life_type.damage, name = "雷击", card_id = nil, n = 2})
    elseif target:get_suit(id) == macro.suit.club then
        self:add_life(1)
        target:sub_life({causer = self, type = macro.sub_life_type.damage, name = "雷击", card_id = nil, n = 1})
    end
end

return ZhangJiao