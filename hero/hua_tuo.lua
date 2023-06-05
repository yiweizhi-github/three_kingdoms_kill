HuaTuo = class(Player)

HuaTuo.get_targets["青囊"] = function (self)
    local targets = {}
    for _, target in ipairs(game.players) do
        if target.life < target.life_limit then
           helper.insert(targets, target) 
        end
    end
    return targets
end

HuaTuo.check_skill["青囊"] = function (self)
    if self:has_flag("使用过青囊") then
        return false
    end
    if not next(self.hand_cards) then
        return false
    end
    if not next(self.get_targets["青囊"](self)) then
        return false
    end
    return true
end

HuaTuo.skill["青囊"] = function (self)
    self.flags["使用过青囊"] = true
    local targets = self.get_targets["青囊"](self)
    local target = query["选择一名玩家"](targets, "青囊")
    opt["弃置一张牌"](self, self, "青囊", true)
    target:add_life(1)
end

HuaTuo.skill["急救"] = function (self, target)
    local func = function (id) return self:get_color(id) == macro.color.red end
    local cards = self:get_cards(func, true, true)
    local id = query["选择一张牌"](cards, "急救")
    if helper.element(self.hand_cards, id) then
        helper.remove(self.hand_cards, id)
    elseif helper.element(self:get_equip_cards(), id) then
        self:take_off_equip(id)
    end
    helper.insert(deck.discard_pile, id)
    target:add_life(1)
end

return HuaTuo