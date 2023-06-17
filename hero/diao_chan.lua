DiaoChan = class(Player)

DiaoChan.skill["回合结束阶段"] = function (self)
    if self:has_skill("闭月") then
        self.skill["闭月"](self)
    end
end

DiaoChan.skill["闭月"] = function (self)
    if not query["询问发动技能"]("闭月") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(1))
end

DiaoChan.get_t["离间"] = function (self)
    local t = {}
    for _, player in ipairs(game:get_other_players(self)) do
        if player.sex == "man" then
            local targets = {}
            for _, player1 in ipairs(game:get_other_players(player)) do
                if player1.sex == "woman" then
                    goto continue
                end
                if player1:has_skill("空城") and #player1.hand_cards == 0 then
                    goto continue
                end
                helper.insert(targets, player1)
                ::continue::
            end
            if #targets > 0 then
                t[player] = targets
            end
        end
    end
    return t
end

DiaoChan.check_skill["离间"] = function (self)
    if self:has_flag("使用过离间") then
        return false
    end
    if self:get_cards(nil, true, true) == 0 then
        return false
    end
    if not next(self.get_t["离间"](self)) then
        return false
    end
    return true
end

DiaoChan.skill["离间"] = function (self)
    self.flags["使用过离间"] = true
    opt["弃置一张牌"](self, self, "离间", true, true)
    local t = self.get_t["离间"](self)
    local targets = helper.get_keys(t)
    local target1 = query["选择一名玩家"](targets, "离间")
    local target2 = query["选择一名玩家"](t[target1], "离间")
    target2.respond["决斗"](target2, target1, nil)
end

return DiaoChan