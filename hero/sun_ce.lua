SunCe = class(Player)

SunCe.skill["回合开始阶段"] = function (self)
    if self:has_skill("魂姿") then
        self.skill["魂姿"](self)   
    end
    if self:has_skill("英魂") then
        self.skill["英魂"](self)   
    end
end

SunCe.skill["魂姿"] = function (self)
    if self.life > 1 then
        return
    end
    if not query["询问发动技能"]("魂姿") then
        return
    end
    self.life_limit = self.life_limit - 1
    self.life = self.life > self.life_limit and self.life_limit or self.life
    helper.remove(self.skills, resmng.get_skill_id("魂姿"))
    helper.insert(self.skills, resmng.get_skill_id("英姿"))
    helper.insert(self.skills, resmng.get_skill_id("英魂"))
end

function SunCe:draw()
    text("现在是%s的摸牌阶段", self.name)
    if self:has_flag("跳过摸牌") then
        return
    end
    if self:has_skill("英姿") then
        self.skill["英姿"](self)
    end
end

SunCe.skill["英姿"] = function (self)
    if not query["询问发动技能"]("英姿") then
        helper.insert(self.hand_cards, deck:draw(2))
    else
        helper.insert(self.hand_cards, deck:draw(3))
    end
end

SunCe.skill["英魂"] = function (self)
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
        local card_n = #target:get_cards(nil, true, true)
        n = n > card_n and card_n or n
        opt["弃置n张牌"](target, target, "英魂", true, true, n)
    end
end

SunCe.skill["杀-指定目标后"] = function (self, target, t)
    if self:has_skill("雌雄双股剑") then
        self.skill["雌雄双股剑"](self, target)
    end
    if self:has_skill("激昂") then
        self.skill["激昂"](self, self, "杀", t)
    end
end

SunCe.skill["杀-成为目标后"] = function (self, causer, t)
    if self:has_skill("激昂") then
        self.skill["激昂"](self, causer, "杀", t)
    end
end

SunCe.skill["决斗-指定目标后"] = function (self, id)
    if self:has_skill("激昂") then
        self.skill["激昂"](self, self, "决斗", id)
    end
end

SunCe.skill["决斗-成为目标后"] = function (self, causer, id)
    if self:has_skill("激昂") then
        self.skill["激昂"](self, causer, "决斗", id)
    end
end

SunCe.skill["激昂"] = function (self, causer, reason, args)
    local color
    if reason == "杀" then
        color = causer:get_kill_color(args)
    elseif reason == "决斗" then
        color = causer:get_color(args)   
    end
    if color ~= macro.color.red then
        return
    end
    if not query["询问发动技能"]("激昂") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(1))
end

return SunCe