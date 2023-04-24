CaoCao = class(Player)

CaoCao.skill["受到伤害后"] = function (self, causer, responder, t)
    self.skill["奸雄"](self, responder, t)
end

CaoCao.skill["奸雄"] = function (self, responder, t)
    if responder ~= self then
        return
    end
    if not t.id then
        return
    end
    if not query["询问发动技能"]("奸雄") then
        return
    end
    if helper.equal(game.settling_card[#game.settling_card], t.id) then
        helper.pop(game.settling_card)
        helper.insert(self.hand_cards, t.id)
    end
end

return CaoCao