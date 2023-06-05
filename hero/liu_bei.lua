LiuBei = class(Player)

LiuBei.check_skill["仁德"] = function (self)
    if not next(self.hand_cards) then
        return false
    end
    return true
end

local function give_card(player, targets)
    local id = query["选择一张牌"](player.hand_cards, "仁德")
    local target = query["选择一名玩家"](targets, "仁德")
    helper.remove(player.hand_cards, id)
    helper.insert(target.hand_cards, id)
    player.flags["仁德"] = player.flags["仁德"] or 0
    player.flags["仁德"] = player.flags["仁德"] + 1
    if player.flags["仁德"] == 2 then
        player:add_life(1)
    end
end

LiuBei.skill["仁德"] = function (self)
    local targets = game:get_other_players(self)
    give_card(self, targets)
    while next(self.hand_cards) do
        if not query["二选一"]("仁德") then
            break
        end
        give_card(self, targets)
    end
end

return LiuBei