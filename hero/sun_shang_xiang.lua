SunShangXiang = class(Player)

SunShangXiang.skill["失去装备"] = function (self)
    if self:has_skill("枭姬") then
        self.skill["枭姬"](self)
    end
end

SunShangXiang.skill["枭姬"] = function (self)
    if not query["询问发动技能"]("枭姬") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(2))
end

SunShangXiang.get_targets["结姻"] = function (self)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if target.sex == "man" and target.life < target.life_limit then
            helper.insert(targets, target)
        end
    end
    return targets
end

SunShangXiang.check_skill["结姻"] = function (self)
    if self:has_flag("使用过结姻") then
        return false
    end
    if #self.hand_cards < 2 then
        return false
    end
    if not next(self.get_targets["结姻"](self)) then
        return false
    end
    return true
end

SunShangXiang.skill["结姻"] = function (self)
    self.flags["使用过结姻"] = true
    opt["弃置n张牌"](self, self, "结姻", true, false, 2)
    local targets = self.get_targets["结姻"](self)
    local target = query["选择一名玩家"](targets, "结姻")
    self:add_life(1)
    target:add_life(1)
end

return SunShangXiang