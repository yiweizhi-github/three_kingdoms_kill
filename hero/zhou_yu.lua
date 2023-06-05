ZhouYu = class(Player)

function ZhouYu:draw()
    text("现在是%s的摸牌阶段", self.name)
    if self:has_flag("跳过摸牌") then
        return
    end
    self.skill["英姿"](self)
end

ZhouYu.skill["英姿"] = function (self)
    if not query["询问发动技能"]("英姿") then
        helper.insert(self.hand_cards, deck:draw(2))
    else
        helper.insert(self.hand_cards, deck:draw(3))
    end
end

ZhouYu.check_skill["反间"] = function (self)
    if self:has_flag("使用过反间") then
        return false
    end
    if not next(self.hand_cards) then
        return false
    end
    return true
end

ZhouYu.skill["反间"] = function (self)
    self.flags["使用过反间"] = true
    local targets = game:get_other_players(self)
    local target = query["选择一名玩家"](targets, "反间")
    local suit = query["选择花色"]({macro.suit.spade, macro.suit.heart, macro.suit.club, macro.suit.diamond})
    local n = math.random(#self.hand_cards)
    local id = self.hand_cards[n]
    helper.remove(self.hand_cards, id)
    if resmng[id].suit ~= suit then
        target:sub_life({causer = self, type = macro.sub_life_type.damage, name = "反间", card_id = nil, n = 1})
    end
    if target:check_alive() then
        helper.insert(target.hand_cards, id)
    else
        helper.insert(deck.discard_pile, id)
    end
end

return ZhouYu