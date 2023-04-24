ZhouTai = class(Player)

function ZhouTai:ctor()
    self["创"] = {}
end

function ZhouTai:get_card_limit()
    return #self["创"]
end

ZhouTai.skill["失去手牌"] = function (self, causer, responder, reason)
    self.skill["奋激"](self, causer, responder, reason)
end

ZhouTai.skill["奋激"] = function (self, causer, responder, reason)
    if causer == responder then
        return
    end
    if reason ~= "弃置" and reason ~= "获得" then
        return
    end
    if not query["询问发动技能"]("奋激") then
        return
    end
    self:sub_life({casuer = self, type = macro.sub_life_type.life_loss, "奋激", card_id = nil, n = 1})
    helper.insert(responder.hand_cards, deck:draw(2))
end

ZhouTai.skill["不屈"] = function (self)
    local id = deck:draw(1)
    local flag = true
    for _, id1 in ipairs(self["创"]) do
        if resmng[id].points == resmng[id1].points then
            flag = false
            break
        end
    end
    if flag then
        self:add_life(self, 1 - self.life)
        helper.insert(self["创"], id)
    else
        helper.insert(deck.discard_pile, id)
    end
end

return ZhouTai