GuanYu = class(Player)

GuanYu.check_skill["武圣"] = function (self)
    if not self:check_can_kill() then
        return false
    end
    local func = function (id) return self:get_color(id) == macro.color.red end
    local cards = self:get_cards(func, true, true)
    if self.arm and resmng[self.arm].name == "诸葛连弩" and self:get_color(self.arm) == macro.color.red then
        if self.flags["杀-剩余次数"] == 0 then
            helper.remove(cards, self.arm)
        end
    end
    if not next(cards) then
        return false
    end
    return true
end

GuanYu.skill["武圣"] = function (self, reason, ...)
    if not reason then
        reason = "正常出杀"
    end
    if reason == "南蛮入侵" or reason == "决斗" then
        local func = function (id) return self:get_color(id) == macro.color.red end
        opt["弃置一张牌"](self, self, "武圣", true, true, false, func)
    else
        local func = function (id) return self:get_color(id) == macro.color.red end
        local cards = self:get_cards(func, true, true)
        if reason == "正常出杀" then
            if self.arm and resmng[self.arm].name == "诸葛连弩" and self:get_color(self.arm) == macro.color.red then
                if self.flags["杀-剩余次数"] == 0 then
                    helper.remove(cards, self.arm)
                end
            end
        end
        local id = query["选择一张牌"](cards, "武圣")
        if helper.element(self:get_equip_cards(), id) then
            self:take_off_equip(id)
        elseif helper.element(self.hand_cards, id) then
            helper.remove(self.hand_cards, id)
        end
        self:before_settle(id)
        self.use["杀"](self, {is_transfer = true, transfer_type = "武圣", id = id}, reason, ...)
        self:after_settle(id)
    end
end

return GuanYu