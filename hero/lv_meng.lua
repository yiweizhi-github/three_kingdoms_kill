LvMeng = class(Player)

LvMeng.skill["弃牌阶段开始前"] = function (self)
    if not self.flags["使用或打出过杀"] then
        self.flags["跳过弃牌"] = true
    end
end

return LvMeng