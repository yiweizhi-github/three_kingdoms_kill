XiaHouDun = class(Player)

XiaHouDun.skill["受到伤害后"] = function (self, causer, responder, t)
    if not self:has_skill("刚烈") then
        return
    end
    self.skill["刚烈"](self, causer, responder)
end

XiaHouDun.skill["刚烈"] = function (self, causer, responder)
    if responder ~= self then
        return
    end
    if not causer:check_alive() then
        return
    end
    if not query["询问发动技能"]("刚烈") then
        return
    end
    local id = game:judge(self)
    if self:get_suit(id) == macro.suit.heart then
        return
    end
    if #causer:get_cards(nil, true) < 2 then
        causer:sub_life({causer = self, type = macro.sub_life_type.damage, name = "刚烈", id = nil, n = 1})
        return
    end
    if query["二选一"]("刚烈") then
        opt["弃置n张牌"](causer, causer, "刚烈", true, false, 2)
    else
        causer:sub_life({causer = self, type = macro.sub_life_type.damage, name = "刚烈", id = nil, n = 1})
    end
end

return XiaHouDun