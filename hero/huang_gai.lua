HuangGai = class(Player)

HuangGai.check_skill["苦肉"] = function (self)
    return true
end

HuangGai.skill["苦肉"] = function (self)
    self:sub_life({causer = nil, type = macro.sub_life_type.life_loss, name = "苦肉", card_id = nil, n = 1})
    if self:check_alive() then
        helper.insert(self.hand_cards, deck:draw(2))
    end
end

return HuangGai