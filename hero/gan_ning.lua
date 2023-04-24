GanNing = class(Player)

GanNing.get_t["奇袭"] = function (self)
    local t = {}
    local func = function (v) return resmng[v].suit == macro.suit.spade or resmng[v].suit == macro.suit.club end
    for _, id in ipairs(self:get_cards(func, true, true)) do
        local targets = {}
        for _, player in ipairs(game:get_other_players(self)) do
            if player:has_skill("帷幕") and self:get_color(id) == macro.color.black then
                goto continue
            end
            if #player:get_cards(nil, true, true, true) == 0 then
                goto continue
            end
            helper.insert(targets, player)
            ::continue::
        end
        if #targets > 0 then
            t[id] = targets
        end  
    end
    return t
end

GanNing.check_skill["奇袭"] = function (self)
    if not next(self.get_t["奇袭"](self)) then
        return false
    end
    return true
end

GanNing.skill["奇袭"] = function (self)
    local t = self.get_t["奇袭"](self)
    local cards = helper.get_keys(t)
    local id = query["选择一张牌"](cards, "奇袭")
    if helper.element(self:get_equip_cards(), id) then
        self:take_off_equip(id)
    elseif helper.element(self.hand_cards, id) then
        helper.remove(self.hand_cards, id)
    end
    self:before_settle(id)
    local target = query["选择一名玩家"](t[id], "奇袭")
    target.respond["过河拆桥"](target, self)
    self:after_settle(id)
end

return GanNing