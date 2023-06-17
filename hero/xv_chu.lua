XvChu = class(Player)

function XvChu:draw()
    text("现在是%s的摸牌阶段", self.name)
    self.skill["摸牌阶段开始前"](self)
    if self:has_flag("跳过摸牌") then
        return
    end
    if self:has_skill("裸衣") then
        self.skill["裸衣"](self)
    else
        helper.insert(self.hand_cards, deck:draw(2))
    end
end

XvChu.skill["裸衣"] = function (self)
    if self:has_flag("跳过摸牌") then
        return
    end
    if not query["询问发动技能"]("裸衣") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(1))
    self.flags["裸衣"] = true
end

return XvChu