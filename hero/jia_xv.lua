JiaXv = class(Player)

function JiaXv:ctor()
    self["已使用乱武"] = false
end

JiaXv.check_skill["乱武"] = function (self)
    return not self["已使用乱武"]
end

JiaXv.skill["乱武"] = function (self)
    self["已使用乱武"] = true
    local settle_players = game:get_settle_players_except_self(self)
    for _, responder in ipairs(settle_players) do
        if responder:check_alive() then
            responder.respond["乱武"](responder)         
        end
    end
end

return JiaXv