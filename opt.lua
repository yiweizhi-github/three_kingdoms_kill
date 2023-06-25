opt = {}

opt["弃置一张牌"] = function (causer, responder, reason, use_hand_cards, use_equip_cards, use_judge_cards, func)
    local cards = {}
    local hand_cards = {}
    local equip_cards = responder:get_equip_cards()
    local judge_cards = responder.judge_cards
    if use_hand_cards then
        hand_cards = responder.hand_cards
    end
    if causer == responder then
        helper.insert(cards, hand_cards)
    end
    if use_equip_cards then
        helper.insert(cards, equip_cards)
    end
    if use_judge_cards then
        helper.insert(cards, judge_cards)
    end
    if func then
        local cards1 = {}
        for _, id in ipairs(cards) do
            if func(id) then
                helper.insert(cards1, id)
            end
        end
        cards = cards1
    end
    local id
    -- 可选的牌包括别人手牌
    if causer ~= responder and use_hand_cards then
        id = query["选一张明牌或抽一张暗牌"](hand_cards, cards, reason)
    -- 所有可选的牌为明牌，即不包括别人手牌
    else
        id = query["选择一张牌"](cards, reason)
    end
    -- 弃装备
    if helper.element(equip_cards, id) then
        responder:take_off_equip(id)
        responder.skill["失去装备"](responder)
    -- 弃自己手牌
    elseif causer == responder and helper.element(hand_cards, id) then
        helper.remove(hand_cards, id)
        game.skill["失去手牌"](game, causer, responder, "弃置")
    -- 弃别人手牌
    elseif causer ~= responder and id== 0 then
        local n = math.random(#hand_cards)
        id = hand_cards[n]
        helper.remove(hand_cards, id)
        game.skill["失去手牌"](game, causer, responder, "弃置")
    -- 弃判定区的牌    
    elseif helper.element(judge_cards, id) then
        helper.remove(judge_cards, id)
    end
    helper.insert(deck.discard_pile, id)
    return id
end

opt["获得一张牌"] = function (causer, responder, reason, use_hand_cards, use_equip_cards, use_judge_cards)
    local cards = {}
    local hand_cards = {}
    local equip_cards = responder:get_equip_cards()
    local judge_cards = responder.judge_cards
    if use_hand_cards then
        hand_cards = responder.hand_cards
    end
    if use_equip_cards then
        helper.insert(cards, equip_cards)
    end
    if use_judge_cards then
        helper.insert(cards, judge_cards)
    end
    local id
    -- 可选的牌包括别人手牌
    if causer ~= responder and use_hand_cards then
        id = query["选一张明牌或抽一张暗牌"](hand_cards, cards, reason)
    -- 所有可选的牌为明牌，即不包括别人手牌
    else
        id = query["选择一张牌"](cards, reason)
    end
    -- 拿装备
    if helper.element(equip_cards, id) then
        responder:take_off_equip(id)
        responder.skill["失去装备"](responder)
    -- 拿别人手牌
    elseif id == 0 then
        local n = math.random(#hand_cards)
        id = hand_cards[n]
        helper.remove(hand_cards, id)
        game.skill["失去手牌"](game, causer, responder, "获得")
    -- 拿判定区的牌    
    elseif helper.element(judge_cards, id) then
        helper.remove(judge_cards, id)
    end
    helper.insert(causer.hand_cards, id)
end

opt["弃置n张牌"] = function(causer, responder, reason, use_hand_cards, use_equip_cards, n, func)
    local ids = {}
    local discard_hand = nil
    if causer == responder then
        local cards = {}
        local equip_cards = responder:get_equip_cards()
        if use_hand_cards then
            helper.insert(cards, responder.hand_cards)
        end
        if use_equip_cards then
            helper.insert(cards, equip_cards)
        end
        if func then
            local cards1 = {}
            for _, id in ipairs(cards) do
                if func(id) then
                    helper.insert(cards1, id)
                end
            end
            cards = cards1
        end
        for _ = 1, n, 1 do
            local id = query["选择一张牌"](cards, reason)
            helper.remove(cards, id)
            if helper.element(equip_cards, id) then
                responder:take_off_equip(id)
            else
                helper.remove(responder.hand_cards, id)
                discard_hand = true
            end
            helper.insert(ids, id)
        end
        if discard_hand then
            game.skill["失去手牌"](game, causer, responder, "弃置")
        end
        for _, id in ipairs(ids) do
            if helper.element(equip_cards, id) then
                responder.skill["失去装备"](responder)
            end
        end
    else
        local cards
        local hand_cards = {}
        local equip_cards = responder:get_equip_cards()
        if use_hand_cards then
            helper.insert(hand_cards, responder.hand_cards)
        end
        if use_equip_cards then
            helper.insert(cards, equip_cards)
        end
        if func then
            local hand_cards1 = {}
            for _, id in ipairs(hand_cards) do
                if func(id) then
                    helper.insert(hand_cards1, id)
                end
            end
            hand_cards = hand_cards1
            local cards1 = {}
            for _, id in ipairs(cards) do
                if func(id) then
                    helper.insert(cards1, id)
                end
            end
            cards = cards1
        end
        for _ = 1, n, 1 do
            local id = query["选一张明牌或抽一张暗牌"](hand_cards, cards, reason)
            if helper.element(cards, id) then
                responder:take_off_equip(id)
                helper.remove(cards, id)
            else
                local n1 = math.random(#hand_cards)
                id = hand_cards[n1]
                helper.remove(responder.hand_cards, id)
                helper.remove(hand_cards, id)
                discard_hand = true
            end
            helper.insert(ids, id)
        end
        if discard_hand then
            game.skill["失去手牌"](game, causer, responder, "弃置")
        end
        for _, id in ipairs(ids) do
            if helper.element(equip_cards, id) then
                responder.skill["失去装备"](responder)
            end
        end
    end
    helper.insert(deck.discard_pile, ids)
    return ids
end
