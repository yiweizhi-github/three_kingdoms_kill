XiaoQiao = class(Player)

function XiaoQiao:get_suit(id)
    if  resmng[id].suit == macro.suit.spade and not helper.element(self.judge_cards, id) then
        return macro.suit.heart
    else
        return resmng[id].suit
    end
end

XiaoQiao.skill["受到伤害时"] = function (self, causer, responder, t)
    self.skill["天香"](self, t)
end

XiaoQiao.skill["天香"] = function (self, t)
    local func = function (id) return self:get_suit(id) == macro.suit.heart end
    if not next(self:get_cards(func, true)) then
        return
    end
    if not query["询问发动技能"]("天香") then
        return
    end
    t.settle_finish = true
    local targets = game:get_other_players(self)
    local target = query["选择一名玩家"](targets, "天香")
    local id = opt["弃置一张牌"](self, self, "天香",  true, false, false, func)
    if query["二选一"]("天香") then
        target:sub_life({causer = target, type = macro.sub_life_type.damage, name = "天香", card_id = nil, n = 1})
        if target:check_alive() then
            local n = target.life_limit - target.life
            if n > 5 then
                n = 5
            end
            helper.insert(target.hand_cards, deck:draw(n))  
        end
    else
        target:sub_life({causer = nil, type = macro.sub_life_type.life_loss, name = "天香", card_id = nil, n = 1})
        if target:check_alive() then
            helper.remove(deck.discard_pile, id)    
            helper.insert(target.hand_cards, id)    
        end
    end
end

return XiaoQiao