GuanYu = class(Player)

GuanYu.check_skill["武圣"] = function (self)
    local cards = {}
    local func = function(id) return self:get_color(id) == macro.color.red end
    if self:check_can_kill() and next(self:get_players_in_attack_range()) then
        helper.insert(cards, self:get_cards(func, true, true))
    end
    if self.arm and self:get_color(self.arm) == macro.color.red then
        local arm_id = self.arm
        self:take_off_equip(arm_id)
        if not (self:check_can_kill() and next(self:get_players_in_attack_range())) then
            helper.remove(cards, arm_id)
        end
        self:put_on_equip(arm_id)
    end
    if not next(cards) then
        return false
    end
    return true
end

GuanYu.skill["武圣"] = function (self, reason, ...)
    local func = function(id) return self:get_color(id) == macro.color.red end
    if reason == "南蛮入侵" or reason == "决斗" then
        opt["弃置一张牌"](self, self, "武圣", true, true, false, func)
    else
        local cards = self:get_cards(func, true, true)
        if reason == "正常出杀" then
            if self.arm and self:get_color(self.arm) == macro.color.red then
                local arm_id = self.arm
                self:take_off_equip(arm_id)
                if not (self:check_can_kill() and next(self:get_players_in_attack_range())) then
                    helper.remove(cards, arm_id)
                end
                self:put_on_equip(arm_id)
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