LiuShan = class(Player)

LiuShan.skill["出牌阶段开始前"] = function (self)
    self.skill["放权-出牌阶段开始前"](self)
end

LiuShan.skill["放权-出牌阶段开始前"] = function (self)
    if self:has_flag("跳过出牌") then
        return
    end
    if not query["询问发动技能"]("放权") then
        return
    end
    self.flags["跳过出牌"] = true
    self.flags["放权"] = true
end

LiuShan.skill["回合结束阶段"] = function (self)
    self.skill["放权-回合结束阶段"](self)
end

LiuShan.skill["放权-回合结束阶段"] = function (self)
    if not self:has_flag("放权") then
        return
    end
    if #self.hand_cards == 0 then
        return
    end
    opt["弃置一张牌"](self, self, "放权",  true)
    local targets = game.get_other_selfs(self)
    local target = query["选择一名玩家"](targets, "放权")
    helper.insert(game.settle_players, self.order + 1, target)
end

LiuShan.skill["杀-成为目标后"] = function (self, causer, t)
    self.skill["享乐"](self, causer, t)
end

LiuShan.skill["享乐"] = function (self, causer, t)
    if not query["询问发动技能"]("享乐") then
        return
    end
    local func = function (id) return resmng[id].type == "basic" end
    if not next(causer:get_cards(func, true ,true)) then
        t.invalid[self] = true
        return
    end
    if query["二选一"]("享乐") then
        opt["弃置一张牌"](causer, causer, "享乐", true, true, nil, func)
    else
        t.invalid[self] = true
    end
end

return LiuShan