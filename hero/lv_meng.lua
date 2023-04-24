LvMeng = class(Player)

LvMeng.skill["弃牌阶段开始前"] = function (self)
    if not self.flags["使用或打出过杀"] then
        self.flags["跳过弃牌"] = true
    end
end

LvMeng.use["杀"] =  function (self, t, reason, ...)
    if game.whose_turn == self then
        self.flags["使用或打出过杀"] = true
    end
    self.super.use["杀"](self, t, reason, ...)
end

return LvMeng