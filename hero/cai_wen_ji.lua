CaiWenJi = class(Player)

CaiWenJi.skill["受到伤害后"] = function (self, causer, responder, t)
    if self:has_skill("悲歌") then
        self.skill["悲歌"](self, causer, responder, t)
    end
end

CaiWenJi.skill["悲歌"] = function (self, causer, responder, t)
    if t.name ~= "杀" then
        return
    end
    if not next(self:get_cards(nil, true, true)) then
        return
    end
    if not query["询问发动技能"]("悲歌") then
        return
    end
    opt["弃置一张牌"](self, self, "悲歌", true, true)
    local id = game:judge(responder, "悲歌")
    if not (responder:has_skill(responder, "天妒") and responder.skill["天妒"](responder, id)) then
         helper.insert(deck.discard_pile, id)   
    end
    local suit = responder:get_suit(id)
    if suit == macro.suit.heart  then
        responder:add_life(1)
    elseif suit == macro.suit.diamond  then
        helper.insert(responder.hand_cards, deck:draw(2))
    elseif suit == macro.suit.club and causer:check_alive() then
        if #causer:get_cards(nil, true, true) >= 2 then
            opt["弃置n张牌"](causer, causer, "悲歌", true, true, 2)
        elseif #causer:get_cards(nil, true, true) == 1 then
            opt["弃置一张牌"](causer, causer, "悲歌", true, true)
        end
    elseif suit == macro.suit.spade and causer:check_alive() then
        causer:flip()
    end
end

CaiWenJi.skill["断肠"] = function (self, causer)
    if not query["询问发动技能"]("断肠") then
        return
    end
    helper.clear(causer.skills)
    if causer["田"] and next(causer["田"]) then
        helper.insert(deck.discard_pile, causer["田"])
        helper.clear(causer["田"])
    elseif causer["创"] and next(causer["创"]) then
        helper.insert(deck.discard_pile, causer["创"])
        helper.clear(causer["创"])
    end
end

return CaiWenJi