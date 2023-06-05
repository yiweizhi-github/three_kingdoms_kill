SunJian = class(Player)

SunJian.skill["回合开始阶段"] = function (self)
    self.skill["英魂"](self)
end

SunJian.skill["英魂"] = function (self)
    local n = self.life_limit - self.life
    if n == 0 then
        return
    end
    if not query["询问发动技能"]("英魂") then
        return
    end
    local target = query["选择一名玩家"](game:get_other_players(self), "英魂")
    if query["二选一"]("英魂") then
        helper.insert(target.hand_cards, deck:draw(n))
        opt["弃置一张牌"](target, target, "英魂", true, true)
    else
        helper.insert(target.hand_cards, deck:draw(1))
        opt["弃置n张牌"](target, target, "英魂", true, true, n)
    end
end

return SunJian