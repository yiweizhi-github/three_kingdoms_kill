WeiYan = class(Player)

function WeiYan:ctor()
    self["已使用奇谋"] = false
end

function WeiYan:get_distance(another)
    local dis = Player.get_distance(self, another)
    if self.flags["奇谋"] then
        dis = dis - self.flags["奇谋"]
    end
    return dis > 0 and dis or 0 
end

WeiYan.skill["造成伤害后"] = function (self, causer, responder, t)
    if not self:has_skill("狂骨") then
        return
    end
    self.skill["狂骨"](self, causer, t)
end

WeiYan.skill["狂骨"] = function (self, causer, t)
    if self ~= causer then
        return
    end
    if not self["狂骨"] then
        return
    end
    if not query["询问发动技能"]("狂骨") then
        return
    end
    self["狂骨"] = nil
    for _ = 1, t.n, 1 do
        if query["二选一"]("狂骨") then
            self:add_life(1)
        else
            helper.insert(self.hand_cards, deck:draw(1))
        end
    end
end

WeiYan.check_skill["奇谋"] = function (self)
    return not self["已使用奇谋"]
end

WeiYan.skill["奇谋"] = function (self)
    self["已使用奇谋"] = true
    local loss_life_n = query["奇谋"](self.life)
    self:sub_life({causer = self, type = macro.sub_life_type.life_loss, name = "奇谋", card_id = nil, n = loss_life_n})
    if self:check_alive() then
        self.flags["奇谋"] = loss_life_n
        self.flags["杀-剩余次数"] = self.flags["杀-剩余次数"] + loss_life_n
    end
end

return WeiYan