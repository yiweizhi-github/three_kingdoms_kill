XiaHouYuan = class(Player)

XiaHouYuan.skill["判定阶段开始前"] = function (self)
    if self:has_skill("神速") then
        self.skill["神速-判定阶段开始前"](self)
    end
end

XiaHouYuan.skill["神速-判定阶段开始前"] = function (self)
    if not query["询问发动技能"]("神速") then
        return
    end
    self.flags["跳过判定"] = true
    self.flags["跳过摸牌"] = true
    self.use["杀"](self, {is_transfer = true, transfer_type = "神速", id = nil}, "神速")
end

XiaHouYuan.skill["出牌阶段开始前"] = function (self)
    if self:has_skill("神速") then
        self.skill["神速-出牌阶段开始前"](self)
    end
end

XiaHouYuan.skill["神速-出牌阶段开始前"] = function (self)
    if self.has_flag(self, "跳过出牌") then
        return
    end
    local func = function (id) return resmng[id].type ~= "basic" and resmng[id].type ~= "tactic" end
    if not next(self.get_cards(self, func, true, true)) then
        return
    end
    if not query["询问发动技能"]("神速") then
        return
    end
    opt["弃置一张牌"](self, self, "神速", true, true, false, func)
    self.flags["跳过出牌"] = true
    self.use["杀"](self, {is_transfer = true, transfer_type = "神速", id = nil}, "神速")
end

XiaHouYuan.skill["弃牌阶段开始前"] = function (self)
    if self:has_skill("神速") then
        self.skill["神速-弃牌阶段开始前"](self)
    end
end

XiaHouYuan.skill["神速-弃牌阶段开始前"] = function (self)
    if not query["询问发动技能"]("神速") then
        return
    end
    self.flags["跳过弃牌"] = true
    self:flip()
    self.use["杀"](self, {is_transfer = true, transfer_type = "神速", id = nil}, "神速")
end

return XiaHouYuan