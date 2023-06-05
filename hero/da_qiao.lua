DaQiao = class(Player)

DaQiao.get_t["国色"] = function (self)
    local t = {}
    local func = function (v) return resmng[v].suit == macro.suit.diamond end
    local cards = self:get_cards(func, true, true)
    for _, id in ipairs(cards) do
        local targets = {}
        for _, player in ipairs(game:get_other_players(self)) do
            local name = game:get_judge_card_name(id)
            -- 被转移目标判定区内不能有同名判定牌
            for _, id1 in ipairs(player.judge_cards) do
                if name == game:get_judge_card_name(id1) then
                    goto continue
                end
            end
            -- 不能把乐不思蜀转给陆逊
            if name == "乐不思蜀" and player:has_skill("谦逊") then
                goto continue
            end
            -- 不能把黑色牌转给贾诩
            if player:has_skill("帷幕") and self:get_color(id) == macro.color.black then
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

DaQiao.check_skill["国色"] = function (self)
    if not next(self.get_t["国色"](self)) then
        return false
    end
    return true
end

DaQiao.skill["国色"] = function (self)
    local t = self.get_t["国色"](self)
    local cards = helper.get_keys(t)
    local id = query["选择一张牌"](cards, "国色")
    if helper.element(self.hand_cards, id) then
        helper.remove(self.hand_cards, id)
    elseif helper.element(self:get_equip_cards(), id) then
        self:take_off_equip(id)
    end
    local target = query["选择一名玩家"](t[id], "国色")
    helper.put(target.judge_cards, id)
    game.transfer_delay_tactics[id] = "乐不思蜀"
end

DaQiao.skill["流离"] = function (self, causer)
    local targets = self:get_players_in_attack_range()
    -- 不能转移给杀的使用者
    helper.remove(targets, causer)
    if not next(targets) then
        return
    end
    if not next(self:get_cards(nil, true, true)) then
        return
    end
    if not query["询问发动技能"]("流离") then
        return 
    end
    opt["弃置一张牌"](self, self, "流离", true, true)
    local target = query["选择一名玩家"](targets, "流离")
    game.old_kill_target = self
    return target
end

return DaQiao