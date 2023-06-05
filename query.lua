query = {}

-- query模块用于获取玩家输入返回给调用者，实现I/O层与逻辑层的分离。

local str = {}

query["出牌阶段"] = function (player)
    text("你的手牌为:%s", t2s(player.hand_cards))
    local can_use_cards = player:get_can_use_cards()
    text("你可用的手牌为:%s", t2s(can_use_cards))
    local can_use_skills = player:get_can_use_skills()
    text("你可用的技能为:%s", t2s(can_use_skills))
    while true do
        text("请输入您想使用的手牌id或想发动的技能id，输入0结束出牌阶段")
        local id = io.read("n")
        if helper.element(can_use_cards, id) or helper.element(can_use_skills, id) or id == 0 then
            return id
        else
            text("错误输入，请重新输入")
        end
    end
end

query["询问出牌"] = function (cards, skills, card_name, must_use)
    while true do
        if next(cards) then
            text("你可以打出的%s为：%s，请输入你想打出的%sid", card_name, t2s(cards), card_name)   
        end
        if next(skills) then
            text("你此时可以发动的技能为：%s，请输入你想发动的技能id", t2s(skills))   
        end
        if not must_use then
            text("输入0不出%s也不发动技能", card_name)
        end
        local id = io.read("n")
        if not must_use and id == 0 or helper.element(cards, id) or helper.element(skills, id) then
            return id
        else
            text("错误输入，请重新输入")
        end
    end
end

query["选择一张牌"] = function (cards, reason)
    while true do
        text("正在结算%s，", reason)
        text("你可以选择的牌为%s:", t2s(cards))
        local id = io.read("n")
        if helper.element(cards, id) then
            return id
        else
            text("错误输入，请重新输入")
        end
    end
end

query["选一张明牌或抽一张暗牌"] = function (hand_cards, other_cards, reason)
    while true do
        text("正在结算%s，", reason)
        if next(other_cards) then
            text("你可以选的牌为%s, 请输入你想选的牌id", t2s(other_cards))
        end
        if next(hand_cards) then
            text("输入0随机选一张手牌")
        end
        local id = io.read("n")
        if helper.element(other_cards, id) or next(hand_cards) and id == 0 then
            return id
        else
            text("错误输入，请重新输入")
        end
    end
end

query["选择一名玩家"] = function (targets, reason)
    while true do
        text("正在结算%s", reason)
        text("你可以选的目标有%s, 请输入你想选的目标id", t2s(targets))
        local target_ids = {}
        for _, target in ipairs(targets) do
            helper.insert(target_ids, target.id)
        end
        local id = io.read("n")
        if helper.element(target_ids, id) then
            return game:get_player(id)
        else
            text("错误输入，请重新输入")
        end
    end
end

query["询问发动技能"] = function (skill_name)
    while true do
        text("是否发动技能：%s，输入1发动，输入0不发动", skill_name)
        local id = io.read("n")
        if id == 1 then
            return true
        elseif id == 0 then
            return false
        else
            text("错误输入，请重新输入")
        end
    end
end

str["二选一"] = {}
str["二选一"]["是否继续指定杀的目标"] = "你的杀还可以指定目标，输入1继续指定，输入0不指定"
str["二选一"]["是否继续指定抽牌的目标"] = "你还可以抽其他玩家的手牌，输入1继续，输入0退出"
str["二选一"]["雌雄双股剑"] = "输入1弃一张手牌，输入0让对手摸一张牌"
str["二选一"]["享乐"] = "输入1弃置一张基本牌，输入0该杀无效"
str["二选一"]["刚烈"] = "输入1弃置两张手牌，输入0受到一点伤害"
str["二选一"]["狂骨"] = "输入1回复一点体力，输入0摸一张牌"
str["二选一"]["制衡"] = "输入1继续选择制衡的牌，输入0不选择"
str["二选一"]["天香"] = "输入1让目标受到一点伤害，摸损失的体力值的牌，输入0让目标失去一点体力，获得你弃置的牌"
str["二选一"]["英魂"] = "输入1让目标摸n张弃1张，输入0让目标摸1张弃n张,n为你已损失的体力值"
str["二选一"]["观星"] = "输入1把牌放回牌堆顶，输入0把牌放回牌堆底"
str["二选一"]["志继"] = "输入1摸两张牌，输入0回复1点体力"
str["二选一"]["强袭"] = "输入1失去1点体力，输入0弃置1张装备牌"
str["二选一"]["挑衅"] = "输入1对姜维出杀，输入0被姜维弃置1张牌"
str["二选一"]["仁德"] = "输入1继续发动仁德，输入0不发动"

query["二选一"] = function (reason)
    while true do
        text(str["二选一"][reason])
        local id = io.read("n")
        if id == 1 then
            return true
        elseif id == 0 then
            return false
        else
            text("错误输入，请重新输入")
        end
    end
end

query["选择花色"] = function (suits)
    while true do
        text("你可以选择的花色为:")
        for i, suit in ipairs(suits) do
            text("%d-%s", i, get_suit_str(suit))
        end
        text("请输入你想选的花色id")
        local id = io.read("n")
        if id >= 1 and id <= #suits then
            return suits[id]
        else
            text("错误输入，请重新输入")
        end
    end
end

query["观星-调整牌序"] = function (cards)
    local cards1 = {}
    while next(cards) do
        text("你可以调整顺序的牌有：%s，输入你想放在第%d位的牌的id", t2s(cards), #cards1 + 1)
        local id = io.read("n")
        if helper.element(cards, id) then
            helper.remove(cards ,id)
            helper.insert(cards1 ,id)
        else
            text("错误输入，请重新输入")
        end
        text("已调整的牌按顺序排列为：%s", t2s(cards1))
    end
    return cards1
end

query["奇谋"] = function (life)
    text("请输入你想失去的体力点数，当前体力为：%d", life)
    return io.read("n")
end

return query