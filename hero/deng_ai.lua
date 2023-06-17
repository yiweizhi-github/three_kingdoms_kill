DengAi = class(Player)

function DengAi:ctor()
    self["田"] = {}
end

function DengAi:get_distance(another)
    local dis = Player.get_distance(self, another)
    if self:has_skill("屯田") then
        dis = dis - #self["田"]
    end
    return dis > 0 and dis or 0
end

DengAi.skill["回合开始阶段"] = function (self)
    if self:has_skill("凿险") then
        self.skill["凿险"](self)  
    end
end

DengAi.skill["凿险"] = function (self)
    if #self["田"] < 3 then
        return
    end
    if not query["询问发动技能"]("凿险") then
        return
    end
    self.life_limit = self.life_limit - 1
    self.life = self.life > self.life_limit and self.life_limit or self.life
    helper.remove(self.skills, resmng.get_skill_id("凿险"))
    helper.insert(self.skills, resmng.get_skill_id("急袭"))
end

DengAi.skill["失去手牌"] = function (self, causer, responder, reason)
    if self:has_skill("屯田") then
        self.skill["屯田"](self, responder)
    end
end

DengAi.skill["失去装备"] = function (self)
    if self:has_skill("屯田") then
        self.skill["屯田"](self, self)
    end
end

DengAi.skill["屯田"] = function (self, responder)
    if self ~= responder then
        return
    end
    if game.whose_turn == self then
        return
    end
    if not query["询问发动技能"]("屯田") then
        return
    end
    local id = game:judge(self, "屯田")
    if resmng[id].suit ~= macro.suit.heart then
        helper.insert(self["田"], id)
    else
        helper.insert(deck.discard_pile, id)
    end
end

DengAi.get_t["急袭"] = function (self)
    local t = {}
    for _, id in ipairs(self["田"]) do
        local targets = {}
        for _, player in ipairs(game:get_other_players(self)) do
            if player:has_skill("帷幕") and self:get_color(id) == macro.color.black then
                goto continue
            end
            if #player:get_cards(nil, true, true, true) == 0 then
                goto continue
            end
            if player:has_skill("谦逊") then
                goto continue
            end
            if self:get_distance(player) > 0 then
                goto continue
            end
            helper.insert(targets, player)
            ::continue::
        end
        if #targets > 0 then
            t[id] = targets
        end  
    end
    return t
end

DengAi.check_skill["急袭"] = function (self)
    if not next(self.get_t["急袭"](self)) then
        return false
    end
    return true
end

DengAi.skill["急袭"] = function (self)
    local t = self.get_t["急袭"](self)
    local cards = helper.get_keys(t)
    local id = query["选择一张牌"](cards, "急袭")
    helper.remove(self["田"], id)
    self:before_settle(id)
    local target = query["选择一名玩家"](t[id], "急袭")
    target.respond["顺手牵羊"](target, self)
    self:after_settle(id)
end

return DengAi