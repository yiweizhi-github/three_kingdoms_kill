HuangZhong = class(Player)

HuangZhong.respond["乱武"] = function (self)
    local targets = self.get_targets["乱武"](self)
    local func = function (id) return resmng[id].name == "杀" end
    local cards = self.get_cards(func, true)
    local t = {}
    for _, id in ipairs(cards) do
        local targets1 = {}
        for _, target in ipairs(targets) do
            if resmng[id].points > self:get_distance(target) then
                helper.insert(targets1, target)
            elseif helper.element(self:get_players_in_attack_range(), target) then
                helper.insert(targets1, target)
            end
        end
        if next(targets1) then
            t[id] = targets1
        end
    end
    if next(t) then
        local cards1 = helper.get_keys(t)
        local id = query["询问出牌"](cards1, {}, "杀")
        if resmng.check_card(id) then
            helper.remove(self.hand_cards, id)
            self:before_settle(id)
            self.use["杀"](self, {id = id}, "乱武", t[id])
            self:after_settle(id)
        elseif resmng.check_skill(id) then
            self.skill["杀"](self, id, "乱武", t[id])
        else
            self:sub_life({causer = self, type = macro.sub_life_type.life_loss, name = "乱武", card_id = nil, n = 1})
        end
    else
        self:sub_life({causer = self, type = macro.sub_life_type.life_loss, name = "乱武", card_id = nil, n = 1})
    end
end

return HuangZhong