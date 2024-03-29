MaChao = class(Player)

function MaChao:get_distance(another)
    local dis = Player.get_distance(self, another)
    if self:has_skill("马术") then
        dis = dis - 1
    end
    return dis > 0 and dis or 0
end

MaChao.skill["杀-指定目标后"] = function (self, target, t)
    self.skill["铁骑"](self, target, t)
    if self:has_skill("雌雄双股剑") then
        self.skill["雌雄双股剑"](self, target)
    end
end

MaChao.skill["铁骑"] = function (self, target, t)
    if not query["询问发动技能"]("铁骑") then
        return
    end
    local id = game:judge(self, "铁骑")
    if self:get_color(id) == macro.color.red then
        t.can_dodge[target] = false
    end
    helper.insert(deck.discard_pile, id)
end

return MaChao