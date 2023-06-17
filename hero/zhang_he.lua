ZhangHe = class(Player)

ZhangHe.skill["判定阶段开始前"] = function (self)
    if self:has_skill("巧变") then
        self.skill["巧变-判定阶段开始前"](self)
    end
end

ZhangHe.skill["巧变-判定阶段开始前"] = function (self)
    if not next(self.hand_cards) then
        return 
    end
    if not query["询问发动技能"]("巧变") then
        return
    end
    opt["弃置一张牌"](self, self, "巧变", true)
    self.flags["跳过判定"] = true
end

ZhangHe.skill["摸牌阶段开始前"] = function (self)
    if self:has_skill("巧变") then
        self.skill["巧变-摸牌阶段开始前"](self)
    end
end

ZhangHe.skill["巧变-摸牌阶段开始前"] = function (self)
    if not next(self.hand_cards) then
        return 
    end
    local targets = {}
    for _, player in ipairs(game:get_other_players(self)) do
        if #player.hand_cards > 0 then
            helper.insert(targets, player)
        end
    end
    if not next(targets) then
        return
    end
    if not query["询问发动技能"]("巧变") then
        return
    end
    opt["弃置一张牌"](self, self, "巧变", true)
    self.flags["跳过摸牌"] = true
    local target = query["选择一名玩家"](targets, "巧变")
    opt["获得一张牌"](self, target, "巧变", true)
    helper.remove(targets, target)
    if next(targets) then
        if not query["二选一"]("是否继续指定抽牌的目标") then
            return true
        end
        local target1 = query["选择一名玩家"](targets, "巧变")
        opt["获得一张牌"](self, target1, "巧变", true)
    end
end

ZhangHe.skill["出牌阶段开始前"] = function (self)
    if self:has_skill("巧变") then
        self.skill["巧变-出牌阶段开始前"](self)
    end
end

local function get_cards_and_targets(player)
    local t = {}
    local equip_cards = player:get_equip_cards()
    local judge_cards = player.judge_cards
    for _, id in ipairs(equip_cards) do
        local targets = {}
        for _, target in ipairs(game:get_other_players(player)) do
            if not target:has_equip(resmng[id].type) then
                helper.insert(targets, target)
            end
        end
        if #targets > 0 then
            t[id] = targets
        end
    end
    for _, id in ipairs(judge_cards) do
        local targets = {}
        for _, target in ipairs(game:get_other_players(player)) do
            local name = game:get_judge_card_name(id)
            -- 被转移目标判定区内不能有同名判定牌
            for _, id1 in ipairs(target.judge_cards) do
                if name == game:get_judge_card_name(id1) then
                    goto continue
                end
            end
            -- 不能把乐不思蜀转给陆逊
            if name == "乐不思蜀" and target:has_skill("谦逊") then
                goto continue
            end
            -- 不能把黑色牌转给贾诩
            if target:has_skill("帷幕") and player:get_color(id) == macro.color.black then
                goto continue
            end
            helper.insert(targets, target)
            ::continue::
        end
        if #targets > 0 then
            t[id] = targets
        end
    end
    return t
end

ZhangHe.get_t["巧变-出牌阶段开始前"] = function ()
    local t = {}
    for _, player in ipairs(game.players) do
        local t1 = get_cards_and_targets(player)
        if next(t1) then
            t[player] = t1 
        end
    end
    return t
end

ZhangHe.skill["巧变-出牌阶段开始前"] = function (self)
    if self:has_flag("跳过出牌") then
        return
    end
    if not next(self.hand_cards) then
        return 
    end
    local t = self.get_t["巧变-出牌阶段开始前"](self)
    if not next(t) then
        return
    end
    if not query["询问发动技能"]("巧变") then
        return
    end
    opt["弃置一张牌"](self, self, "巧变", true)
    self.flags["跳过出牌"] = true
    local targets = helper.get_keys(t)
    local target = query["选择一名玩家"](targets, "巧变")
    local id = query["选择一张牌"](helper.get_keys(t[target]), "巧变")
    local target1 = query["选择一名玩家"](t[target][id], "巧变")
    if helper.element(target:get_equip_cards(), id) then
        target:take_off_equip(id)
        target.skill["失去装备"](target)
        target1:put_on_equip(id)
    else
        helper.remove(target.judge_cards, id)
        helper.put(target1.judge_cards, id)
    end
end

ZhangHe.skill["弃牌阶段开始前"] = function (self)
    if self:has_skill("巧变") then
        self.skill["巧变-弃牌阶段开始前"](self)
    end
end

ZhangHe.skill["巧变-弃牌阶段开始前"] = function (self)
    if not next(self.hand_cards) then
        return 
    end
    if not query["询问发动技能"]("巧变") then
        return
    end
    opt["弃置一张牌"](self, self, "巧变", true)
    self.flags["跳过弃牌"] = true
end

return ZhangHe