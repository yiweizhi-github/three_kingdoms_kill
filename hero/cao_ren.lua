CaoRen = class(Player)

function CaoRen:flip()
    if self.toward == macro.toward.up then
        self.toward = macro.toward.down
        helper.remove(self.skills, resmng[self.hero_id].skills)
    -- false表示背面翻回正面，获得武将技能，
    else
        self.toward = macro.toward.up
        helper.insert(self.skills, resmng[self.hero_id].skills)
        if self:has_skill("解围") then
            self.skill["解围-翻面"](self)
        end
    end
end

CaoRen.skill["无懈可击"] = function (self)
    self.skill["解围-无懈可击"](self)
end

CaoRen.skill["解围-无懈可击"] = function (self)
    local cards = self:get_equip_cards()
    local id = query["选择一张牌"](cards, "解围")
    self:take_off_equip(id)
    self:before_settle(id)
    self:after_settle(id)
end

local function get_cards_and_targets2(player)
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

local function get_targets1_and_cards_and_targets2()
    local t = {}
    for _, player in ipairs(game.players) do
        local t1 = get_cards_and_targets2(player)
        if next(t1) then
            t[player] = t1 
        end
    end
    return t
end

CaoRen.get_t["解围-翻面"] = function (self)
    local t = {}
    for _, id in ipairs(self.hand_cards) do
        local t1 = get_targets1_and_cards_and_targets2()
        if next(t1) then
            t[id] = t1
        end
    end
    for _, id in ipairs(self:get_equip_cards()) do
        self:take_off_equip(id)
        local t1 = get_targets1_and_cards_and_targets2()
        if next(t1) then
            t[id] = t1
        end
        self:put_on_equip(id)
    end
    return t
end

CaoRen.skill["解围-翻面"] = function (self)
    local t = self.get_t["解围-翻面"](self)
    if not next(t) then
        return
    end
    if not query["询问发动技能"]("解围") then
        return
    end
    local can_discard_cards = helper.get_keys(t)
    local func = function (id) return helper.element(can_discard_cards, id) end
    local discard_id = opt["弃置一张牌"](self, self, "解围", true, true, false, func)
    local targets = helper.get_keys(t[discard_id])
    local target = query["选择一名玩家"](targets, "解围")
    local can_move_cards = helper.get_keys(t[discard_id][target])
    local move_card_id = query["选择一张牌"](can_move_cards, "解围")
    local target1 = query["选择一名玩家"](t[discard_id][target][move_card_id], "解围")
    if helper.element(target:get_equip_cards(), move_card_id) then
        target:take_off_equip(move_card_id)
        target.skill["失去装备"](target)
        target1:put_on_equip(move_card_id)
    else
        helper.remove(target.judge_cards, move_card_id)
        helper.put(target1.judge_cards, move_card_id)
    end
end

CaoRen.skill["回合结束阶段"] = function (self)
    if self:has_skill("据守") then
        self.skill["据守"](self)
    end
end

CaoRen.skill["据守"] = function (self)
    if not query["询问发动技能"]("据守") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(4))
    self:flip()
    local id = query["选择一张牌"](self.hand_cards, "据守")
    helper.remove(self.hand_cards, id)
    if resmng[id].type ~= "basic" and resmng[id].type ~= "tactic" then
        self:put_on_equip(id)
    else
        helper.insert(deck.discard_pile, id)
    end
end

return CaoRen