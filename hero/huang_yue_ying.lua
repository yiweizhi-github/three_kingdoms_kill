HuangYueYing = class(Player)

HuangYueYing.skill["集智"] = function (self)
    if not query["询问发动技能"]("集智") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(1))
end

return HuangYueYing