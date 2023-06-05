ZhaoYun = class(Player)

ZhaoYun.check_skill["龙胆"] = function (self)
    if not self:check_can_kill() then
        return false
    end
    local func = function (id) return resmng[id].name == "闪" end
    local cards = {}
    if self:check_can_kill() and next(self:get_players_in_attack_range()) then
        helper.insert(cards, self:get_cards(func, true))
    end
    if not next(cards) then
        return false
    end
    return true
end

ZhaoYun.skill["龙胆"] = function (self, reason, ...)
    if reason == "被杀" or reason == "万箭齐发" then
        local func = function (id) return resmng[id].name == "杀" end
        local cards = self:get_cards(func, true)
        local id = query["选择一张牌"](cards, "龙胆")
        helper.remove(self.hand_cards, id)
        helper.insert(deck.discard_pile, id)
    else
        local func = function (id) return resmng[id].name == "闪" end
        local cards = self:get_cards(func, true)
        local id = query["选择一张牌"](cards, "龙胆")
        helper.remove(self.hand_cards, id)
        self:before_settle(id)
        self.use["杀"](self, {is_transfer = true, transfer_type = "龙胆", id = id}, reason, ...)
        self:after_settle(id)
    end
end

return ZhaoYun