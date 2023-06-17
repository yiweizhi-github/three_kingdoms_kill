ZhenJi = class(Player)

ZhenJi.skill["回合开始阶段"] = function (self)
    if self:has_skill("洛神") then
        self.skill["洛神"](self)
    end
end

ZhenJi.skill["洛神"] = function (self)
    if not query["询问发动技能"]("洛神") then
        return
    end
    local id = game:judge(self, "洛神")
    if self:get_color(id) == macro.color.black then
        helper.insert(self.hand_cards, id)
        self.skill["洛神"](self)
    else
        helper.insert(deck.discard_pile, id)
    end
end

ZhenJi.skill["倾国"] = function (self)
    local func = function (id) return self:get_color(id) == macro.color.black end
    local cards = self:get_cards(func, true)
    local id = query["选择一张牌"](cards, "倾国")
    helper.remove(self.hand_cards, id)
    helper.insert(deck.discard_pile, id)
end

return ZhenJi