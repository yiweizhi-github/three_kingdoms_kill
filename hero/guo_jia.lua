GuoJia = class(Player)

GuoJia.skill["天妒"] = function (self, id)
    if not query["询问发动技能"]("天妒") then
        return false
    end
    helper.insert(self.hand_cards, id)
    return true
end

GuoJia.skill["受到伤害后"] = function (self, causer, responder, t)
    if self:has_skill("遗计") then
        self.skill["遗计"](self, responder)
    end
end

GuoJia.skill["遗计"] = function (self, responder)
    if responder ~= self then
        return
    end
    if not query["询问发动技能"]("遗计") then
        return
    end
    for _ = 1, 2, 1 do
        local target = query["选择一名玩家"](game.players, "遗计")
        helper.insert(target.hand_cards, deck:draw(1))
    end
end

return GuoJia