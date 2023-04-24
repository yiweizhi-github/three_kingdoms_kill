SunCe = class(Player)

SunCe.skill["回合开始阶段"] = function (self)
    self.skill["魂姿"](self)
end

SunCe.skill["魂姿"] = function (self)
    if self.life > 1 then
        return
    end
    if not query["询问发动技能"]("魂姿") then
        return
    end
    self.life_limit = self.life_limit - 1
    helper.remove(self.skills, resmng.get_skill_id("魂姿"))
    helper.insert(self.skills, resmng.get_skill_id("英姿"))
    helper.insert(self.skills, resmng.get_skill_id("英魂"))
end

SunCe.skill["杀-指定目标后"] = function (self, target, t)
    self.skill["激昂"](self, self, "杀", t)
    if self:has_skill("雌雄双股剑") then
        self.skill["雌雄双股剑"](self, target)
    end
end

SunCe.skill["杀-成为目标后"] = function (self, causer, t)
    self.skill["激昂"](self, causer, "杀", t)
end

SunCe.skill["决斗-指定目标后"] = function (self, id)
    self.skill["激昂"](self, self, "决斗", id)
end

SunCe.skill["决斗-成为目标后"] = function (self, causer, id)
    self.skill["激昂"](self, causer, "决斗", id)
end

SunCe.skill["激昂"] = function (self, causer, reason, args)
    if not query["询问发动技能"]("激昂") then
        return
    end
    local color
    if reason == "杀" then
        color = causer:get_kill_color(args)
    elseif reason == "决斗" then
        color = causer:get_color(args)   
    end
    if color == macro.color.red then
        helper.insert(self.hand_cards, deck:draw(1))
    end
end

return SunCe