DianWei = class(Player)

DianWei.check_skill["强袭"] = function (self)
    if self:has_flag("使用过强袭") then
        return false
    end
    return true
end

DianWei.skill["强袭"] = function (self)
    self.flags["使用过强袭"] = true
    local target = query["选择一名玩家"](self:get_players_in_attack_range(), "强袭")
    local func = function (id) return resmng[id].type ~= "basic" and resmng[id].type ~= "tactic" end
    local cards = self:get_cards(func, true, true)
    if next(cards) then
        if query["二选一"]("强袭") then
            self:sub_life({causer = nil, type = macro.sub_life_type.life_loss, name = "强袭", card_id = nil, n = 1})
            if self:check_alive() then
                target:sub_life({causer = self, type = macro.sub_life_type.damage, name = "强袭", card_id = nil, n = 1})
            end
        else
            opt["弃置一张牌"](self, self, "强袭", true, true, false, func)
            target:sub_life({causer = self, type = macro.sub_life_type.damage, name = "强袭", card_id = nil, n = 1})
        end
    else
        self:sub_life({causer = nil, type = macro.sub_life_type.life_loss, name = "强袭", card_id = nil, n = 1})
        if self:check_alive() then
            target:sub_life({causer = self, type = macro.sub_life_type.damage, name = "强袭", card_id = nil, n = 1})
        end
    end
end

return DianWei