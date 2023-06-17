LuXvn = class(Player)

LuXvn.skill["失去手牌"] = function (self, causer, responder, reason)
    if self:has_skill("连营") then
        self.skill["连营"](self, causer, responder, reason)
    end
end

LuXvn.skill["连营"] = function (self, causer, responder, reason)
    if self ~= responder then
        return
    end
    if #self.hand_cards ~= 0 then
        return
    end
    if not query["询问发动技能"]("连营") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(1))
end

return LuXvn