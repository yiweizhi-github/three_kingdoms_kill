ZhuGeLiang = class(Player)

ZhuGeLiang.skill["回合开始阶段"] = function (self)
    self.skill["观星"]()
end

ZhuGeLiang.skill["观星"] = function ()
    if not query["询问发动技能"]("观星") then
        return
    end
    local n = #game.players > 5 and 5 or #game.players
    local cards = deck:draw(n)
    cards = type(cards) == "number" and {cards} or cards
    local cards1 = query["观星-调整牌序"](cards)
    if query["二选一"]("观星") then
        for i, v in ipairs(cards1) do
            table.insert(deck.card_pile, i, v)
        end
    else
        helper.insert(deck.card_pile, cards1)
    end
end

return ZhuGeLiang