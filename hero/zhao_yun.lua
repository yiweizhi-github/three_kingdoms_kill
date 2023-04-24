ZhaoYun = class(Player)

ZhaoYun.check_skill["龙胆"] = function (self)
    if not self:check_can_kill() then
        return false
    end
    local func = function (id) return resmng[id].name == "闪" end
    if not next(self:get_cards(func, true)) then
        return false
    end
    return true
end

ZhaoYun.skill["龙胆"] = function (self, reason, ...)
    if not reason then
        reason = "正常出杀"
    end
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