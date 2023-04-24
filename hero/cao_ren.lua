CaoRen = class(Player)

function CaoRen:flip()
    if self.toward == macro.toward.up then
        self.toward = macro.toward.down
        helper.remove(self.skills, resmng[self.hero_id].skills)
    -- false表示背面翻回正面，获得武将技能，
    else
        self.toward = macro.toward.up
        helper.insert(self.skills, resmng[self.hero].skills)
        self.skill["解围-翻面"](self)
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

local function get_player_can_move_cards_and_targets(player)
    local t = {}
    local equip_cards = player:get_equip_cards()
    local judge_cards = player.judge_cards
    for _, id in ipairs(equip_cards) do
        local targets = {}
        for _, player1 in ipairs(game:get_other_players(player)) do
            if not player1:has_equip(id) then
                helper.insert(targets, player1)
            end
        end
        if #targets > 0 then
            t[id] = targets
        end
    end
    for _, id in ipairs(judge_cards) do
        local targets = {}
        for _, player1 in ipairs(game:get_other_players(player)) do
            local name = game.get_judge_card_name(id)
            -- 被转移目标判定区内不能有同名判定牌
            for _, id1 in ipairs(player1.judge_cards) do
                if name == game.get_judge_card_name(id1) then
                    goto continue
                end
            end
            -- 不能把乐不思蜀转给陆逊
            if name == "乐不思蜀" and player1:has_skill("谦逊") then
                goto continue
            end
            -- 不能把黑色牌转给贾诩
            if player1:has_skill("帷幕") and player:get_color(id) == macro.color.black then
                goto continue
            end
            helper.insert(targets, player1)
            ::continue::
        end
        if #targets > 0 then
            t[id] = targets
        end
    end
    return t
end

CaoRen.get_t["解围-翻面"] = function ()
    local t = {}
    for _, player in ipairs(game.players) do
        local t1 = get_player_can_move_cards_and_targets(player)
        if next(t1) then
            t[player] = t1 
        end
    end
    return t
end

CaoRen.skill["解围-翻面"] = function (self)
    local can_discard_cards = {}
    if next(self.get_t["解围-翻面"]()) then
        helper.insert(can_discard_cards, self.hand_cards)
    end
    for _, id in ipairs(self:get_equip_cards()) do
        self:take_off_equip(id)
        if next(self.get_t["解围-翻面"]()) then
            helper.insert(can_discard_cards, id)
        end
        self:put_on_equip(id)
    end
    -- 没有可以弃置的牌
    if not next(can_discard_cards) then
        return
    end
    if not query["询问发动技能"]("解围") then
        return
    end
    opt["弃置一张牌"](self, self, "解围", true, true)
    local t = self.get_t["解围-翻面"]()
    local targets = helper.get_keys(t)
    local target = query["选择一名玩家"](targets, "解围")
    local id = query["选择一张牌"](t[target], "解围")
    local target1 = query["选择一名玩家"](t[target][id], "解围")
    if helper.element(target:get_equip_cards(), id) then
        target:take_off_equip(id)
        target.skill["失去装备"](target)
        target1:put_on_equip(id)
    else
        helper.remove(target.judge_cards, id)
        helper.put(target1.judge_cards, id)
    end
end

CaoRen.skill["回合结束阶段"] = function (self)
    self.skill["据守"](self)
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