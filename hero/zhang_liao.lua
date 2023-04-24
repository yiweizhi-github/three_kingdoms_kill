ZhangLiao = class(Player)

function ZhangLiao:draw()
    text("现在是%s的摸牌阶段", self.name)
    if self:has_flag("跳过摸牌") then
        return
    end
    self.skill["突袭"](self)
end

ZhangLiao.skill["突袭"] = function (self)
    local targets = {}
    for _, player in ipairs (game:get_other_players(self)) do
        if #player.hand_cards > 0 then
            helper.insert(targets, player)
        end
    end
    if not next(targets) then
        return
    end
    if not query["询问发动技能"]("突袭") then
        return
    end
    local target = query["选择一名玩家"](targets, "突袭")
    opt["获得一张牌"](self, target, "突袭", true)
    if next(targets) then
        if not query["二选一"]["是否继续指定突袭的目标"] then
            return true
        end
        local target1 = query["选择一名玩家"](targets, "突袭")
        opt["获得一张牌"](self, target1, "突袭", true)
    end
end

return ZhangLiao