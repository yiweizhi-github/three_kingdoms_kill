ZhuRong = class(Player)

ZhuRong.skill["巨象"] = function (self, id)
    if not query["询问发动技能"]("巨象") then
        return false
    end
    helper.insert(self.hand_cards, id)
    return true
end

ZhuRong.skill["造成伤害后"] = function (self, causer, responder, t)
    if not self:has_skill("烈刃") then
        return
    end
    self.skill["烈刃"](self, causer, responder, t)
end

ZhuRong.skill["烈刃"] = function (self, causer, responder, t)
    if self ~= causer then
        return
    end
    if not responder:check_alive() then
        return
    end
    if t.name ~= "杀" then
        return
    end
    if not next(self.hand_cards) or not next(responder.hand_cards) then
        return
    end
    if not query["询问发动技能"]("烈刃") then
        return
    end
    if game:compare_points(self, responder) then
        opt["获得一张牌"](self, responder, "烈刃", true, true)
    end
end

return ZhuRong