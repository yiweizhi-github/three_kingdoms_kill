SunQuan = class(Player)

SunQuan.check_skill["制衡"] = function (self)
    if self:has_flag("使用过制衡") then
        return false
    end
    if not next(self:get_cards(nil, true, true)) then
        return false
    end
    return true
end

SunQuan.skill["制衡"] = function (self)
    self.flags["使用过制衡"] = true
    local cards = self:get_cards(nil, true, true)
    local zhiheng_cards = {}
    local id = query["选择一张牌"](cards, "制衡")
    helper.remove(cards, id)
    helper.insert(zhiheng_cards, id)
    while next(cards) do
        if not query["二选一"]("制衡") then
            break
        end
        id = query["选择一张牌"](cards, "制衡")
        helper.remove(cards, id)
        helper.insert(zhiheng_cards, id)
    end
    for _, id in ipairs(zhiheng_cards) do
        if helper.element(self.hand_cards, id) then
            helper.remove(self.hand_cards, id)
        else
            self:take_off_equip(id)
        end
    end
    helper.insert(deck.discard_pile, zhiheng_cards)
    helper.insert(self.hand_cards, deck:draw(#zhiheng_cards))
end

return SunQuan