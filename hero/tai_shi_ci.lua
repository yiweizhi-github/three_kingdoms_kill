TaiShiCi = class(Player)

TaiShiCi.get_targets["天义"] = function (self)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if next(target.hand_cards) then
           helper.insert(targets, target) 
        end
    end
    return targets
end

TaiShiCi.check_skill["天义"] = function (self)
    if self.has_flag("使用过天义") then
        return false
    end
    if not next(self.get_targets["天义"](self)) then
        return false
    end
    return true
end

TaiShiCi.skill["天义"] = function (self)
    self.flags["使用过天义"] = true
    local targets = self.get_targets["天义"](self)
    local target = query["选择一名玩家"](targets, "天义")
    if game:compare_points(self, target) then
        self.flags["天义-赢"] = true
    else
        self.flags["天义-输"] = true
    end
end

return TaiShiCi