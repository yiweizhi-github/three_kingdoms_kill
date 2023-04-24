PangTong = class(Player)

function PangTong:ctor()
    self["已使用涅槃"] = false
end

PangTong.skill["涅槃"] = function (self)
    self["已使用涅槃"] = true
    local cards
    if next(self.hand_cards) then
        helper.insert(cards, self.hand_cards)
        helper.clear(self.hand_cards)
    end
    if self.arm then
        helper.insert(cards, self.arm)
        self.arm = nil
    end
    if self.armor then
        helper.insert(cards, self.armor)
        self.armor = nil
    end
    if self.add_horse then
        helper.insert(cards, self.add_horse)
        self.add_horse = nil
    end
    if self.sub_horse then
        helper.insert(cards, self.sub_horse)
        self.sub_horse = nil
    end
    if next(self.judge_cards) then
        helper.insert(cards, self.judge_cards)
        helper.clear(self.judge_cards)
    end
    helper.insert(deck.discard_pile, cards)
    helper.insert(self.hand_cards, deck:draw(3))
    self:add_life(3)
end

return PangTong