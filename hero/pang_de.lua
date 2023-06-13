PangDe = class(Player)

function PangDe:get_distance(another)
    local dis = Player.get_distance(self, another)
    if self:has_skill("马术") then
        dis = dis - 1
    end
    return dis > 0 and dis or 0 
end

PangDe.skill["杀-指定目标后"] = function (self, target, t)
    self.skill["鞬出"](self, target, t)
    if self:has_skill("雌雄双股剑") then
        self.skill["雌雄双股剑"](self, target)
    end
end

PangDe.skill["鞬出"] = function (self, target, t)
    if not next(target:get_cards(nil, true ,true)) then
        return
    end
    if not query["询问发动技能"]("鞬出") then
        return
    end
    local id = opt["弃置一张牌"](self, target, "鞬出", true, true)
    if resmng[id].type ~= "basic" and resmng[id].type ~= "tactic" then
        t.can_dodge[target] = false
    else
        if helper.equal(game.settling_card[#game.settling_card], t.id) then
            helper.pop(game.settling_card)
            helper.insert(target.hand_cards, t.id)
        end
    end
end

return PangDe