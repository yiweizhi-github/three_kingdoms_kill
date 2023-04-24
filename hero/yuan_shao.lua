YuanShao = class(Player)

YuanShao.get_t["乱击"] = function (self)
    local t = {}
    local suits = {macro.suit.spade, macro.suit.heart, macro.suit.club, macro.suit.diamond}
    for _, suit in ipairs(suits) do
        local cards = {}
        for _, id in ipairs(self.hand_cards) do
            if resmng[id].suit == suit then
                helper.insert(cards, id)
            end
        end
        if #cards < 2 then
            goto continue
        end
        local has_targets = false
        for _, target in ipairs(game:get_other_players(self)) do
            if not (target:has_skill("帷幕") and (suit == macro.suit.spade or suit == macro.suit.club)) then
                has_targets = true
                break
            end
        end
        if not has_targets then
            goto continue
        end
        t[suit] = cards
        ::continue::
    end
    return t
end

YuanShao.check_skill["乱击"] = function (self)
    if not next(self.get_t["急袭"](self)) then
        return false
    end
    return true
end

YuanShao.skill["乱击"] = function (self)
    local t = self.get_t["乱击"](self)
    local suits = helper.get_keys(t)
    local suit = query["乱击-选择花色"](suits)
    local id1 = query["选择一张牌"](t[suit], "乱击")
    helper.remove(t[suit], id1)
    local id2 = query["选择一张牌"](t[suit], "乱击")
    local ids = {id1, id2}
    helper.remove(self.hand_cards, ids)
    self:before_settle(ids)
    local settle_players = game:get_settle_players_except_self(self)
    for _, player in ipairs(settle_players) do
        if player:check_alive() then
            if not (player:has_skill("帷幕") and self:get_color(id1) == macro.color.black) then
                player.respond["万箭齐发"](player, self, ids)           
            end
        end
    end
    self:after_settle(ids)
end

return YuanShao