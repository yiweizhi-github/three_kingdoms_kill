WoLongZhuGe = class(Player)

WoLongZhuGe.skill["看破"] = function (self)
    local func = function (id) return self:get_color(id) == macro.color.black end
    local cards = self:get_cards(func, true)
    local id = query["选择一张牌"](cards, "看破")
    helper.remove(self.hand_cards, id)
    self:before_settle(id)
    self:after_settle(id)
end

WoLongZhuGe.skill["八阵"] = function (self)
    if self.armor then
        return false
    end
    if not query["询问发动技能"]("八阵") then
        return false
    end
    local id = game:judge(self)
    helper.insert(deck.discard_pile, id)
    if self:get_suit(id) == macro.color.red then
        return true
    else
        return false
    end
end

return WoLongZhuGe