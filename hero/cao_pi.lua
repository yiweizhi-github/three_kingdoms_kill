CaoPi = class(Player)

CaoPi.skill["行殇"] = function (self, target)
    if not query["询问发动技能"]("行殇") then
        return
    end
    local cards = {}
    if next(target.hand_cards) then
        helper.insert(cards, target.hand_cards)
        helper.clear(target.hand_cards)
    end
    if target.arm then
        helper.insert(cards, target.arm)
        target.arm = nil
    end
    if target.armor then
        helper.insert(cards, target.armor)
        target.armor = nil
    end
    if target.add_horse then
        helper.insert(cards, target.add_horse)
        target.add_horse = nil
    end
    if target.sub_horse then
        helper.insert(cards, target.sub_horse)
        target.sub_horse = nil
    end
    helper.insert(self.hand_cards, cards)
end

CaoPi.skill["受到伤害后"] = function (self, causer, responder, t)
    if self:has_skill("放逐") then
        self.skill["放逐"](self, responder)
    end
end

CaoPi.skill["放逐"] = function (self, responder)
    if responder ~= self then
        return
    end
    if not query["询问发动技能"]("放逐") then
        return
    end
    local targets = game:get_other_players(self)
    local target = query["选择一名玩家"](targets, "放逐")
    target:flip()
    local n = self.life_limit - self.life
    helper.insert(target.hand_cards, deck:draw(n))
end

return CaoPi