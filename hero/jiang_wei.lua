JiangWei = class(Player)

JiangWei.skill["回合开始阶段"] = function (self)
    self.skill["志继"](self)
end

JiangWei.skill["志继"] = function (self)
    if #self.hand_cards > 0 then
        return
    end
    if not query["询问发动技能"]("志继") then
        return
    end
    if self.life < self.life_limit then
        if not query["二选一"]("志继") then
            helper.insert(self.hand_cards, deck:draw(2))
        else
            self:add_life(1)
        end
    else
        helper.insert(self.hand_cards, deck:draw(2))
    end
    self.life_limit = self.life_limit - 1
    helper.remove(self.skills, resmng.get_skill_id("志继"))
    helper.insert(self.skills, resmng.get_skill_id("观星"))
end

JiangWei.get_targets["挑衅"] = function (self)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if helper.element(target:get_players_in_attack_range(), self) then
           helper.insert(targets, target) 
        end
    end
    return targets
end

JiangWei.check_skill["挑衅"] = function (self)
    if self.has_flag("使用过挑衅") then
        return false
    end
    if not next(self.get_targets["挑衅"](self)) then
        return false
    end
    return true
end

JiangWei.skill["挑衅"] = function (self)
    self.flags["使用过挑衅"] = true
    local targets = self.get_targets["挑衅"](self)
    local target = query["选择一名玩家"](targets, "挑衅")
    local func = function (id) return resmng[id].name == "杀" end
    local kills = target:get_cards(func, true, true)
    local skills = target:get_skills_can_be_card("杀")
    if next(kills) or next(skills) then
        if query["二选一"]("挑衅") then
            local id = query["询问出牌"](kills, skills, "杀", true)
            if resmng.check_card(id) then
                helper.remove(target.hand_cards, id)
                game.skill["失去手牌"](game, target, target, "使用")
                self:before_settle(id)
                target.use["杀"](target, {id = id}, "挑衅", self)
                self:after_settle(id)
            elseif resmng.check_skill(id) then
                self.skill["杀"](target, id, "挑衅", self)
            end
        else
            opt["弃置一张牌"](self, target, true, true)
        end  
    else
        opt["弃置一张牌"](self, target, true, true)
    end
end

return JiangWei