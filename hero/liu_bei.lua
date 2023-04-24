LiuBei = class(Player)

LiuBei.check_skill["仁德"] = function (self)
    if not next(self.hand_cards) then
        return false
    end
    return true
end

LiuBei.skill["仁德"] = function (self)
    local targets = game:get_other_players(self)
    while next(self.hand_cards) do
        if not query["二选一"]("仁德") then
            break
        end
        local id = query["选择一张牌"](self.hand_cards, "仁德")
        local target = query["选择一名玩家"](targets, "仁德")
        helper.remove(self.hand_cards, id)
        helper.insert(target.hand_cards, id)
        self.flags["仁德"] = self.flags["仁德"] or 0
        self.flags["仁德"] = self.flags["仁德"] + 1
        if self.flags["仁德"] == 2 then
            self:add_life(1)
        end
    end
end

return LiuBei