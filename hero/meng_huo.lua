MengHuo = class(Player)

function MengHuo:draw()
    if self:has_flag("跳过摸牌") then
        return
    end
    self.skill["再起"](self)
end

MengHuo.skill["再起"] = function (self)
    local n = self.life_limit - self.life
    if n == 0 then
        return
    end
    if not query["询问发动技能"]("再起") then
        return false
    end
    local cards = deck:draw(n)
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
    helper.insert(self.hand_cards, cards1)
    helper.insert(deck.discard_pile, cards)
end

return MengHuo