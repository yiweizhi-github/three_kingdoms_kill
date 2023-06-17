ZhangJiao = class(Player)

ZhangJiao.skill["改判"] = function(self, id, judge_player, reason)
    if self:has_skill("鬼道") then
        return self.skill["鬼道"](self, id, judge_player, reason)
    end
end

ZhangJiao.skill["鬼道"] = function(self, id, judge_player, reason)
    local func = function (id) return resmng[id].suit == macro.suit.spade or resmng[id].suit == macro.suit.club end
    local cards = self:get_cards(func, true, true)
    if judge_player == self and reason == "八卦阵" then
        helper.remove(cards, self.armor)
    end
    if #cards == 0 then
        return
    end
    if not query["询问发动技能"]("鬼道") then
        return
    end
    local id1 = query["选择一张牌"](cards, "鬼道")
    if helper.element(self.hand_cards, id1) then
        helper.remove(self.hand_cards, id1)
    else
        self:take_off_equip(id1)
    end
    helper.insert(self.hand_cards, id)
    return id1
end

ZhangJiao.skill["雷击"] = function (self)
    if not query["询问发动技能"]("雷击") then
        return
    end
    local target = query["选择一名玩家"](game:get_other_players(self), "雷击")
    local id = game:judge(target, "雷击")
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