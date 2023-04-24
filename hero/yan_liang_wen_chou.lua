YanLiangWenChou = class(Player)

function YanLiangWenChou:draw()
    text("现在是%s的摸牌阶段", self.name)
    if self:has_flag("跳过摸牌") then
        return
    end
    self.skill["双雄-摸牌阶段"](self)
end

YanLiangWenChou.skill["双雄-摸牌阶段"] = function (self)
    if not query["询问发动技能"]("双雄") then
        return false
    end
    local id = game:judge(self)
    helper.insert(self.hand_cards, id)
    self.flags["双雄"] = self:get_color(id)
end

YanLiangWenChou.get_t["双雄"] = function (self)
    local t = {}
    local cards = {}
    for _, id in ipairs(self.hand_cards) do
        if self:get_color(id) ~= self.flags["双雄"] then
            helper.insert(cards, id)
        end
    end
    for _, id in ipairs(cards) do
        local targets = {}
        for _, target in ipairs(game:get_other_players(self)) do
            if target:has_skill("帷幕") and self:get_color(id) == macro.color.black then
                goto continue
            end
            if target:has_skill("空城") and #target.hand_cards == 0 then
                goto continue
            end
            helper.insert(targets, target)
            ::continue::
        end
        if next(targets) then
            t[id] = targets
        end
    end
    return t
end

YanLiangWenChou.check_skill["双雄"] = function (self)
    if not self:has_flag("双雄") then
        return false
    end
    if not next(self.get_t["双雄"](self)) then
        return false
    end
    return true
end

YanLiangWenChou.skill["双雄"] = function (self)
    local t = self.get_t["双雄"](self)
    local cards = helper.get_keys(t)
    local id = query["选择一张牌"](cards, "双雄")
    helper.remove(self.hand_cards, id)
    local target = query["选择一名玩家"](t[id], "双雄")
    target.skill["决斗-成为目标后"](target, self, id)
    self:before_settle(id)
    target.respond["决斗"](target, self, id)
    self:after_settle(id)
end

return YanLiangWenChou