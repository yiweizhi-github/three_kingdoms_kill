XvnYu = class(Player)

XvnYu.get_t["驱虎"] = function (self)
    local t = {}
    for _, target in ipairs(game:get_other_players(self)) do    
        if next(target.hand_cards) and target.life > self.life then
            local targets = target:get_players_in_attack_range()
            if next(targets) then
                t[target] = targets
            end
        end
    end
    return t
end

XvnYu.check_skill["驱虎"] = function (self)
    if self:has_flag("使用过驱虎") then
        return false
    end
    if not next(self.get_t["驱虎"](self)) then
        return false
    end
    return true
end

XvnYu.skill["驱虎"] = function (self)
    self.flags["使用过驱虎"] = true
    local t = self.get_t["驱虎"](self)
    local targets = helper.get_keys(t)
    local target = query["选择一名玩家"](targets, "驱虎")
    if game:compare_points(self, target) then
        local target1 = query["选择一名玩家"](t[target], "驱虎")
        target1:sub_life({causer = target, type = macro.sub_life_type.damage, name = "驱虎", card_id = nil, n = 1})
    else
        self:sub_life({causer = target, type = macro.sub_life_type.damage, name = "驱虎", card_id = nil, n = 1})
    end
end

XvnYu.skill["受到伤害后"] = function (self, causer, responder, t)
    self.skill["节命"](self, responder, t)
end

XvnYu.skill["节命"] = function (self, responder, t)
    if responder ~= self then
        return
    end
    if not query["询问发动技能"]("节命") then
        return
    end
    for _ = 1, t.n, 1 do
        local target = query["选择一名玩家"](game.players, "节命")
        local limit = target.life_limit <= 5 and target.life_limit or 5
        helper.insert(target.hand_cards, deck:draw(limit - #target.hand_cards))
    end
end

return XvnYu