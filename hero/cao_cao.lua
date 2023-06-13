CaoCao = class(Player)

CaoCao.skill["受到伤害后"] = function (self, causer, responder, t)
    if not self:has_skill("奸雄") then
        return
    end
    self.skill["奸雄"](self, responder, t)
end

CaoCao.skill["奸雄"] = function (self, responder, t)
    if responder ~= self then
        return
    end
    if not t.card_id then
        return
    end
    if not helper.equal(game.settling_card[#game.settling_card], t.card_id) then
        return
    end
    if not query["询问发动技能"]("奸雄") then
        return
    end
    helper.pop(game.settling_card)
    helper.insert(self.hand_cards, t.card_id)
end

return CaoCao