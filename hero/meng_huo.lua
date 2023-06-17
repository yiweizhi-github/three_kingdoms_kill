MengHuo = class(Player)

function MengHuo:draw()
    text("现在是%s的摸牌阶段", self.name)
    self.skill["摸牌阶段开始前"](self)
    if self:has_flag("跳过摸牌") then
        return
    end
    if self:has_skill("再起") then
        self.skill["再起"](self)
    else
        helper.insert(self.hand_cards, deck:draw(2))
    end
end

MengHuo.skill["再起"] = function (self)
    local n = self.life_limit - self.life
    if n == 0 then
        return
    end
    if not query["询问发动技能"]("再起") then
        return false
    end
    local cards = deck:draw(n + 1)
    local n1 = 0
    local cards1 = {}
    for _, id in pairs(cards) do
        if resmng[id].suit == macro.suit.heart then
            n1 = n1 + 1
            helper.insert(cards1, id)
        end
    end
    self:add_life(n1)
    helper.remove(cards, cards1)
    helper.insert(self.hand_cards, cards)
    helper.insert(deck.discard_pile, cards1)
end

return MengHuo