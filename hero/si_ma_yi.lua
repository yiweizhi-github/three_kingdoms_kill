SiMaYi = class(Player)

SiMaYi.skill["改判"] = function (self, id)
    return self.skill["鬼才"](self, id)
end

SiMaYi.skill["鬼才"] = function (self, id)
    local cards = self:get_cards(nil, true)
    if #cards == 0 then
        return
    end
    if not query["询问发动技能"]("鬼才") then
        return
    end
    local id1 = query["选择一张牌"](cards, "鬼才")
    helper.remove(self.hand_cards, id1)
    helper.insert(deck.discard_pile, id)
    return id1
end

SiMaYi.skill["受到伤害后"] = function (self, causer, responder, t)
    self.skill["反馈"](self, causer, responder)
end

SiMaYi.skill["反馈"] = function (self, causer, responder)
    if responder ~= self then
        return
    end
    if not causer:check_alive() then
        return
    end
    if not next(causer:get_cards(nil, true, true)) then
        return
    end
    if not query["询问发动技能"]("反馈") then
        return
    end
    opt["获得一张牌"](self, causer, "反馈", true, true)
end

return SiMaYi