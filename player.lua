Player = class()

-- 使用某张卡
Player.use = {}  
-- 响应某张卡或某个技能
Player.respond = {}
-- 使用某个技能
Player.skill = {}
-- 检查某个主动技能是否可以发动
Player.check_skill = {}
-- 获取某张卡或某个技能可以操作的目标玩家
Player.get_targets = {}
-- 获取一个t, 该t存储某个技能可以操作的玩家和卡, 不同技能的t的内部结构也不同, 但都是key_value的形式
Player.get_t = {}

function Player:ctor(id, hero_id, order)
    self.id = id
    self.hero_id = hero_id
    self.order = order
    self.name = resmng[hero_id].name
    self.sex = resmng[hero_id].sex
    self.hand_cards = {}
    self.judge_cards = {}
    self.arm = nil
    self.armor = nil
    self.add_horese = nil
    self.sub_horse = nil
    self.skills = {}
    helper.insert(self.skills, resmng[hero_id].skills)
    self.flags = {}
    self.toward = macro.toward.up
    self.life = resmng[hero_id].life
    self.life_limit = resmng[hero_id].life
end

function Player:has_skill(skill_name)
    for _, id in ipairs(self.skills) do
        if resmng[id] == skill_name then
            return true
        end
    end
end

function Player:has_flag(flag_name)
    return self.flags[flag_name]
end

function Player:get_hand_cards_limit()
    return self.life
end

function Player:has_equip(type)
    return self[type] and true or false
end

function Player:get_equip_cards()
    local cards = {}
    if self.arm then
        helper.insert(cards, self.arm)
    end
    if self.armor then
        helper.insert(cards, self.armor)
    end
    if self.add_horse then
        helper.insert(cards, self.add_horse)
    end
    if self.sub_horse then
        helper.insert(cards, self.sub_horse)
    end
    return cards
end

function Player:put_on_equip(id)
    local type = resmng[id].type
    self[type] = id
    if type == "arm" or type == "armor" then
        helper.insert(self.skills, resmng[id].skill)
    end
end

function Player:take_off_equip(id)
    local type = resmng[id].type
    self[type] = nil
    if type == "arm" or type == "armor" then
        helper.remove(self.skills, resmng[id].skill)
    end
end

function Player:get_distance(another)
    local i1 = self.order
    local i2 = another.order
    local dis = math.min(math.abs(i1 - i2), #game.players - math.abs(i1 - i2))
    if self.sub_horse then
        dis = dis - 1
    end
    if another.add_horse then
        dis = dis + 1
    end
    return dis > 0 and dis or 0
end

function Player:get_players_in_attack_range()
    local targets = {}
    local attack_range = self.arm and resmng[self.arm].range or 1
    for _, target in ipairs(game:get_other_players(self)) do
        if self:get_distance(target) <= attack_range then
            helper.insert(targets, target)
        end
    end
    return targets
end

function Player:get_suit(id)
    return resmng[id].suit
end

function Player:get_color(id)
    local suit = self:get_suit(id)
    if suit == macro.suit.spade or suit == macro.suit.club then
        return macro.color.black
    else
        return macro.color.red
    end
end

function Player:get_cards(func, use_hand_cards, use_equip_cards, use_judge_cards)
    local cards = {}
    if use_hand_cards then
        for _, id in ipairs(self.hand_cards) do
            if func and func(id) or not func then
                helper.insert(cards, id)
            end
        end
    end
    if use_equip_cards then
        for _, id in ipairs(self:get_equip_cards()) do
            if func and func(id) or not func then
                helper.insert(cards, id)
            end
        end
    end
    if use_judge_cards then
        for _, id in ipairs(self.judge_cards) do
            if func and func(id) or not func then
                helper.insert(cards, id)
            end
        end
    end
    return cards
end

function Player:check_alive()
    return game.players[self.order] == self
end

function Player:check_jump_turn()
    if self.toward == macro.toward.down then
        self:flip()
        return true
    end
end

function Player:flip()
    if self.toward == macro.toward.up then
        self.toward = macro.toward.down
        helper.remove(self.skills, resmng[self.hero_id].skills)
    else
        self.toward = macro.toward.up
        helper.insert(self.skills, resmng[self.hero_id].skills)
    end
end

function Player:before_turn()
    game.whose_turn = self
    self.flags["杀-剩余次数"] = 1
end

function Player:turn()
    self:start()
    self:judge()
    if not self:check_alive() or game.finish then
        return
    end
    self:draw()
    if not self:check_alive() or game.finish then
        return
    end
    self:play()
    if not self:check_alive() or game.finish then
        return
    end
    self:discard()
    if not self:check_alive() or game.finish then
        return
    end
    self:finish()
end

Player.skill["回合开始阶段"] = function (self)
    
end

function Player:start()
    text("现在是%s的回合开始阶段", self.name)
    self.skill["回合开始阶段"](self)
end

Player.skill["判定阶段开始前"] = function (self)
    
end

function Player:judge()
    text("现在是%s的判定阶段", self.name)
    self.skill["判定阶段开始前"](self)
    if self:has_flag("跳过判定") then
        return
    end
    local judge_cards = {}
    for _, id in ipairs(self.judge_cards) do
        helper.insert(judge_cards, id)
    end
    for _, id in ipairs(judge_cards) do
        local name = game:get_judge_card_name(id)
        self.respond[name](self, id)
        if name == "乐不思蜀" then
            game.transfer_delay_tactics[id] = nil
        end
    end
end

Player.skill["摸牌阶段开始前"] = function (self)
    
end

function Player:draw()
    text("现在是%s的摸牌阶段", self.name)
    self.skill["摸牌阶段开始前"](self)
    if self:has_flag("跳过摸牌") then
        return
    end
    helper.insert(self.hand_cards, deck:draw(2))
end

Player.skill["出牌阶段开始前"] = function (self)
    
end

function Player:play()
    text("现在是%s的出牌阶段", self.name)
    self.skill["出牌阶段开始前"](self)
    if self:has_flag("跳过出牌") then
        return
    end
    while true do
        print_game_info()
        local id = query["出牌阶段"](self)
        if resmng.check_card(id) then
            self:use_card(id)
        elseif resmng.check_skill(id) then
            self:use_skill(id)
        else
            break
        end
        if not self:check_alive() or game.finish then
            return
        end
    end
end

Player.skill["弃牌阶段开始前"] = function (self)
    
end

function Player:discard()
    text("现在是%s的弃牌阶段", self.name)
    self.skill["弃牌阶段开始前"](self)
    if self:has_flag("跳过弃牌") then
        return
    end
    local hand_cards_limit = self:get_hand_cards_limit()
    local n = #self.hand_cards - hand_cards_limit
    if n > 0 then
        local cards = opt["弃置n张牌"](self, self, "普通弃牌", true, false, n)
        local settle_players = game:get_settle_players_except_self(self)
            for _, player in ipairs(settle_players) do
                if player:has_skill("固政") then
                    player.skill["固政"](player, self, cards)
                    break
                end
            end
    end
end

Player.skill["回合结束阶段"] = function (self)
    
end

function Player:finish()
    text("现在是%s的回合结束阶段", self.name)
    self.skill["回合结束阶段"](self)
end

function Player:after_turn()
    helper.clear(self.flags)
end

function Player:before_settle(id)
    helper.put(game.settling_card, id)
end

function Player:after_settle(id)
    -- 结算完的牌可能由于曹操-奸雄等技能已经从结算区被拿走，所以要判断下再放入弃牌区
    if not helper.equal(game.settling_card[#game.settling_card], id) then
        return
    end
    helper.pop(game.settling_card)
    if type(id) == "number" and resmng[id].name == "南蛮入侵" then
        local settle_players = game:get_settle_players(game.whose_turn)
        local need_discard = true
        for _, player in ipairs(settle_players) do
            if player:has_skill("巨象") then
                if player.skill["巨象"](player, id) then
                    need_discard = false
                end
                break
            end
        end
        if need_discard then
            helper.insert(deck.discard_pile, id)
        end
    else
        helper.insert(deck.discard_pile, id)
    end
end

Player.skill["失去手牌"] = function (self, causer, responder, reason)

end

Player.skill["失去装备"] = function (self)
    
end

Player.skill["改判"] = function (self, id, judge_player, reason)
    
end

function Player:use_card(id)
    local type = resmng[id].type
    local name = resmng[id].name
    helper.remove(self.hand_cards, id)
    game.skill["失去手牌"](game, self, self, "使用")
    if type == "basic" then
        self:before_settle(id)
        if name == "杀" then
            self.use["杀"](self, {id = id})
        elseif name == "桃" then
            self.use["桃"](self, self)
        end
        self:after_settle(id)
    elseif type == "tactic" then
        if name == "乐不思蜀" or name == "闪电" then
            self.use[name](self, id)
        else
            if self:has_skill("集智") then
                self.skill["集智"](self)
            end
            self:before_settle(id)
            self.use[name](self, id)
            self:after_settle(id)
        end
    else
        if not self:has_equip(type) then
            self:put_on_equip(id)
        else
            local old_equip_id = self[type]
            self:take_off_equip(old_equip_id)
            helper.insert(deck.discard_pile, old_equip_id)
            self:put_on_equip(id)
        end
    end
end

function Player:get_can_use_cards()
    local cards = {}
    for _, id in ipairs(self.hand_cards) do
        local type = resmng[id].type
        local name = resmng[id].name
        if type ~= "basic" and type ~= "tactic" then
            helper.insert(cards, id)
        elseif name == "杀" then
            if self:check_can_kill() and next(self.get_targets["杀"](self, {id = id})) then
                helper.insert(cards, id)
            end
        elseif name == "闪" or name == "无懈可击" then
            goto continue
        elseif name == "桃" then
            if self.life == self.life_limit then
                goto continue
            end
            helper.insert(cards, id)
        elseif name == "无中生有" or name == "五谷丰登" or name == "桃园结义" then
            helper.insert(cards, id)
        elseif name == "闪电" then
            if self:has_skill("帷幕") and self:get_color(id) == macro.color.black then
                goto continue
            end
            helper.insert(cards, id)
        else
            if not next(self.get_targets[name](self, id)) then
                goto continue
            end
            helper.insert(cards, id)
        end
        ::continue::
    end
    return cards
end

function Player:get_can_use_skills()
    local skills = {}
    for _, id in ipairs(self.skills) do
        if self.check_skill[resmng[id]] and self.check_skill[resmng[id]](self) then
            helper.insert(skills, id)
        end
    end
    return skills
end

function Player:use_skill(id)
    if resmng[id] == "武圣" then
        self.skill["武圣"](self, "正常出杀")
    elseif resmng[id] == "龙胆" then
        self.skill["龙胆"](self, "正常出杀")
    else
        self.skill[resmng[id]](self)
    end
end

Player.skill["杀"] = function (self, id, reason, ...)
    self.skill[resmng[id]](self, reason, ...)
end

Player.skill["闪"] = function (self, id, reason)
    self.skill[resmng[id]](self, reason)
end

Player.skill["桃"] = function (self, id)
    self.skill[resmng[id]](self)
end

Player.skill["无懈可击"] = function (self, id)
    self.skill[resmng[id]](self)
end

function Player:get_skills_can_be_card(card_name)
    local skills = {}
    if card_name == "杀" then
        for _, id in ipairs(self.skills) do
            if resmng[id] == "武圣" then
                local func = function (id1) return self:get_color(id1) == macro.color.red end
                if next(self:get_cards(func, true, true)) then
                    helper.insert(skills, id)
                end
            elseif resmng[id] == "龙胆" then
                local func = function (id1) return resmng[id1].name == "闪" end
                if next(self:get_cards(func, true)) then
                    helper.insert(skills, id)
                end
            elseif resmng[id] == "丈八蛇矛" then
                if self.hand_cards >= 2 then
                    helper.insert(skills, id)
                end
            end
        end
    elseif card_name == "闪" then
        for _, id in ipairs(self.skills) do
            if resmng[id] == "倾国" then
                local func = function (id1) return self:get_color(id1) == macro.color.black end
                if next(self:get_cards(func, true)) then
                    helper.insert(skills, id)
                end
            elseif resmng[id] == "龙胆" then
                local func = function (id1) return resmng[id1].name == "杀" end
                if next(self:get_cards(func, true)) then
                    helper.insert(skills, id)
                end
            end
        end
    elseif card_name == "无懈可击" then
        for _, id in ipairs(self.skills) do
            if resmng[id] == "看破" then
                local func = function (id1) return self:get_color(id1) == macro.color.black end
                local cards = self:get_cards(func, true)
                if next(cards) then
                    helper.insert(skills, id)
                end
            elseif resmng[id] == "解围" then
                local cards = self:get_cards(nil, false, true)
                if next(cards) then
                    helper.insert(skills, id)
                end
            end
        end
    end
    return skills
end

Player.get_targets["乱武"] = function (self)
    local targets = {}
    local min_dis
    for _, target in ipairs(self:get_players_in_attack_range()) do
        local dis = self:get_distance(target)
        if next(targets) then
            if dis < min_dis then
                min_dis = dis
                targets = {target}
            elseif dis == min_dis then
                helper.insert(targets, target)
            end
        else
            min_dis = dis
            targets = {target}
        end
    end
    for _, target in ipairs(targets) do
        if target:has_skill("空城") and #target.hand_cards == 0 then
            helper.remove(targets, target)
        end
    end
    return targets
end

Player.respond["乱武"] = function (self)
    local targets = self.get_targets["乱武"](self)
    if not next(targets) then
        self:sub_life({causer = self, type = macro.sub_life_type.life_loss, name = "乱武", card_id = nil, n = 1})
        return
    end
    if not helper.element(self:get_players_in_attack_range(), targets[1]) then
        self:sub_life({causer = self, type = macro.sub_life_type.life_loss, name = "乱武", card_id = nil, n = 1})
        return
    end
    local func = function (id) return resmng[id].name == "杀" end
    local kills = self:get_cards(func, true)
    local skills = self:get_skills_can_be_card("杀")
    if next(kills) or next(skills) then
        local id = query["询问出牌"](kills, skills, "杀")
        if resmng.check_card(id) then
            helper.remove(self.hand_cards, id)
            game.skill["失去手牌"](game, self, self, "使用")
            self:before_settle(id)
            self.use["杀"](self, {id = id}, "乱武", targets)
            self:after_settle(id)
        elseif resmng.check_skill(id) then
            self.skill["杀"](self, id, "乱武", targets)
        else
            self:sub_life({causer = self, type = macro.sub_life_type.life_loss, name = "乱武", card_id = nil, n = 1})
        end
    else
        self:sub_life({causer = self, type = macro.sub_life_type.life_loss, name = "乱武", card_id = nil, n = 1})
    end
end

function Player:check_can_kill()
    if self:has_flag("天义-输") then
        return false
    end
    if not (self:has_skill("诸葛连弩") or self:has_skill("咆哮") or self.flags["杀-剩余次数"] > 0) then
        return false
    end
    return true
end

-- 杀的t结构示例
-- t = {is_transfer = true, 
--     transfer_type = "神速",
--     id = 1,
--     targets = {},
--     invalid = {}, 
--     can_dodge = {}, 
--     need_dodge = 2, 
--     damage = {}}

Player.use["杀"] = function (self, t, reason, ...)
    if self:has_skill("克己") and game.whose_turn == self then
        self.flags["使用或打出过杀"] = true
    end
    if not reason then
        reason = "正常出杀"
    end
    if reason == "正常出杀" then
        self.flags["杀-剩余次数"] = self.flags["杀-剩余次数"] - 1
        self:kill_set_target(t, self.get_targets["杀"](self, t))
    elseif reason == "神速" then
        self:kill_set_target(t, self.get_targets["杀"](self, t))
    elseif reason == "借刀杀人" or reason == "挑衅" then
        local target = ...
        t.targets = {target}
        self:kill_set_extra_target(t)
    elseif reason == "青龙偃月刀" then
        local target = ...
        t.targets = {target}
        self:kill_set_args(t)
    elseif reason == "乱武" then
        local targets = ...
        self:kill_set_target(t, targets)
    end
end

function Player:kill_set_target(t, targets)
    t.targets = {}
    local target = query["选择一名玩家"](targets, "杀")
    helper.insert(t.targets, target)
    self:kill_set_extra_target(t)
end

local function adjust_kill_targets_order(causer, targets)
    local targets1 = {}
    local settle_players = game:get_settle_players_except_self(causer)
    for _, target in ipairs(settle_players) do
        local flag = true
        -- targets中同一个target可能有多个，所以要用while
        while flag do
            if helper.element(targets, target) then
                helper.remove(targets, target)
                helper.insert(targets1, target)
            else
                flag = false
            end
        end
    end
    return targets1
end

function Player:kill_set_extra_target(t)
    local n = 0
    if self:has_flag("天义-赢") then
        n = n + 1
    end
    if self:has_skill("方天画戟") and #self.hand_cards == 0 and t.transfer_type ~= "神速" then
        n = n + 2
    end

    local targets = self.get_targets["杀"](self, t)
    helper.remove(targets, t.targets)
    
    if n > #targets then
        n = #targets
    end
    if n > 0 then
        text("本次杀你可以额外指定%d名目标", n)    
    end

    for _ = 1, n, 1 do
        if not next(targets) then
            break
        end
        if not query["二选一"]("是否继续指定杀的目标") then
            break
        end
        local target = query["选择一名玩家"](targets, "杀")
        helper.remove(targets, target)
        helper.insert(t.targets, target)
    end

    self:kill_set_args(t)
end

function Player:kill_set_args(t)
    for _, target in ipairs(t.targets) do
        if target:has_skill("流离") then
            local new_target = target.skill["流离"](target, self)
            if new_target then
                helper.remove(t.targets, target)
                helper.insert(t.targets, new_target)
            end
            break
        end
    end

    if #t.targets > 1 then
        t.targets = adjust_kill_targets_order(self, t.targets)
    end

    t.need_dodge = {}
    for _, target in ipairs(t.targets) do
        t.need_dodge[target] = 1
        if self:has_skill("无双") then
            t.need_dodge[target] = t.need_dodge[target] + 1
        end
    end

    t.can_dodge = {}
    for _, target in ipairs(t.targets) do
        t.can_dodge[target] = true
        if self:has_skill("烈弓") and #self.hand_cards >= #target.hand_cards then
            t.can_dodge[target] = false
        end
    end

    t.damage = {}
    for _, target in ipairs(t.targets) do
        t.damage[target] = 1
        if self:has_flag("裸衣") then
            t.damage[target] = t.damage[target] + 1
        end
        if self:has_skill("烈弓") and self.life <= target.life then
            t.damage[target] = t.damage[target] + 1
        end
    end

    local not_duplicate_targets = {}
    local last_target
    for _, target in ipairs(t.targets) do
        if target ~= last_target then
            helper.insert(not_duplicate_targets, target)
            last_target = target
        end
    end
    
    for _, target in ipairs(not_duplicate_targets) do
        self.skill["杀-指定目标后"](self, target, t)  
    end

    t.invalid = {}
    for _, target in ipairs(not_duplicate_targets) do
        target.skill["杀-成为目标后"](target, self, t)  
    end
    
    for _, target in ipairs(t.targets) do
        if not self:has_skill("青釭剑") then
            if target:has_skill("仁王盾") and self:get_kill_color(t) == macro.color.black then
                t.invalid[target] = true
            end
        end
    end

    for _, target in ipairs(t.targets) do
        target.respond["杀"](target, self, t)
    end
end

Player.respond["杀"] = function (self, causer, t)
    if t.invalid[self] then
        return
    end
    if not t.can_dodge[self] then
        self:sub_life({causer = causer, type = macro.sub_life_type.damage, name = "杀", card_id = t.id, n = t.damage[self]})
        return
    end
    if not causer:has_skill("青釭剑") then
        local skill_name
        if self:has_skill("八卦阵") then
            skill_name = "八卦阵"
        elseif self:has_skill("八阵") then
            skill_name = "八阵"
        end
        if skill_name then
            while t.need_dodge[self] > 0 do
                if self.skill[skill_name](self) then
                    if self:has_skill("雷击") then
                        self.skill["雷击"](self)
                    end
                    if game.finish then
                        return
                    end
                    t.need_dodge[self] = t.need_dodge[self] - 1
                else
                    break
                end
            end
        end
    end
    while t.need_dodge[self] > 0 do
        local func = function (id) return resmng[id].name == "闪" end
        local dodges = self:get_cards(func, true)
        local skills = self:get_skills_can_be_card("闪")
        if next(dodges) or next(skills) then
            local id = query["询问出牌"](dodges, skills, "闪")
            if resmng.check_card(id) then
                helper.remove(self.hand_cards, id)
                game.skill["失去手牌"](game, self, self, "使用")
                helper.insert(deck.discard_pile, id)
                if self:has_skill("雷击") then
                    self.skill["雷击"](self)
                end
                if game.finish then
                    return
                end
                t.need_dodge[self] = t.need_dodge[self] - 1
            elseif resmng.check_skill(id) then
                self.skill["闪"](self, id, "被杀")
                t.need_dodge[self] = t.need_dodge[self] - 1
            else
                break        
            end
        else
            break     
        end
    end
    if t.need_dodge[self] == 0 then
        if causer:check_alive() then
            if causer:has_skill("贯石斧") then
                causer.skill["贯石斧"](causer, self, t)
            elseif causer:has_skill("青龙偃月刀") then
                causer.skill["青龙偃月刀"](causer, self)
            end
        end
    else
        self:sub_life({causer = causer, type = macro.sub_life_type.damage, name = "杀", card_id = t.id, n = t.damage[self]})
    end
end

function Player:get_kill_color(t)
    local color
    if t.is_transfer then
        if t.transfer_type == "丈八蛇矛" then
            local color1 = self:get_color(t.id[1])
            local color2 = self:get_color(t.id[2])
            if color1 == color2 then
                color = color1
            end
        elseif t.transfer_type == "神速" then
            color = nil
        end
    else
        color = self:get_color(t.id)
    end
    return color
end

Player.skill["杀-指定目标后"] = function (self, target, t)
    if self:has_skill("雌雄双股剑") then
        self.skill["雌雄双股剑"](self, target)
    end
end

Player.skill["杀-成为目标后"] = function (target, self, t)

end

Player.skill["决斗-指定目标后"] = function (self, id)

end

Player.skill["决斗-成为目标后"] = function (self, causer, id)

end

Player.use["桃"] = function (self, target)
    target:add_life(1)
end

Player.skill["八卦阵"] = function (self)
    if not query["询问发动技能"]("八卦阵") then
        return false
    end
    local id = game:judge(self, "八卦阵")
    if not (self:has_skill("天妒") and self.skill["天妒"](self, id)) then
        helper.insert(deck.discard_pile, id)   
    end
    return self:get_color(id) == macro.color.red and true or false
end

Player.check_skill["丈八蛇矛"] = function (self)
    if not self:check_can_kill() then
        return false
    end
    if #self.hand_cards < 2 then
        return false
    end
    return true
end

Player.skill["丈八蛇矛"] = function (self, reason, ...)
    local id1 = query["选择一张牌"](self.hand_cards, "丈八蛇矛")
    helper.remove(self.hand_cards, id1)
    local id2 = query["选择一张牌"](self.hand_cards, "丈八蛇矛")
    helper.remove(self.hand_cards, id2)
    local ids = {id1, id2}
    game.skill["失去手牌"](game, self, self, "使用")
    if not reason then
        reason = "正常出杀"
    end
    if reason == "南蛮入侵" or reason == "决斗" then
        helper.insert(deck.discard_pile, ids)
    else
        self:before_settle(ids)
        self.use["杀"](self, {is_transfer = true, transfer_type = "丈八蛇矛", id = ids}, reason, ...)
        self:after_settle(ids)
    end
end

Player.skill["雌雄双股剑"] = function (self, target, t)
    if self.sex == target.sex then
        return
    end
    if not query["询问发动技能"]("雌雄双股剑") then
        return
    end
    local hand_cards = target.hand_cards
    if #hand_cards == 0 then
        helper.insert(self.hand_cards, deck:draw(1))
    else
        if query["二选一"]("雌雄双股剑") then
            opt["弃置一张牌"](target, target, "雌雄双股剑", true)
        else
            helper.insert(self.hand_cards, deck:draw(1))
        end
    end
end

Player.skill["贯石斧"] = function (self, target, t)
    local func = function (id) return resmng[id].name ~= "贯石斧" end
    if #self:get_cards(func, true, true) < 2 then
        return
    end
    if not query["询问发动技能"]("贯石斧") then
        return
    end
    opt["弃置n张牌"](self, self, "贯石斧", true, true, 2, func)
    target:sub_life({causer = self, type = macro.sub_life_type.damage, name = "杀", card_id = t.id, n = t.damage[target]})
end

Player.skill["青龙偃月刀"] = function (self, target)
    local func = function (id) return resmng[id].name == "杀" end
    local kills = self:get_cards(func, true)
    local skills = self:get_skills_can_be_card("杀")
    if not next(kills) and not next(skills) then
        return
    end
    if not query["询问发动技能"]("青龙偃月刀") then
        return
    end
    local id = query["询问出牌"](kills, skills, "杀")
    if resmng.check_card(id) then
        helper.remove(self.hand_cards, id)
        game.skill["失去手牌"](game, self, self, "使用")
        self:before_settle(id)
        self.use["杀"](self, {id = id}, "青龙偃月刀", target)
        self:after_settle(id)
    elseif resmng.check_skill(id) then
        self.skill["杀"](self, id, "青龙偃月刀", target)
    end
end

Player.skill["寒冰剑"] = function (self, causer, target, t)
    if self ~= causer then
        return
    end
    local cards = target:get_cards(nil, true, true)
    if not next(cards) then
        return
    end
    if not query["询问发动技能"]("寒冰剑") then
        return
    end
    opt["弃置一张牌"](self, target, "寒冰剑", true, true)
    if next(target:get_cards(nil, true, true)) then
        opt["弃置一张牌"](self, target, "寒冰剑", true, true)
    end
    t.settle_finish = true
end

Player.skill["麒麟弓"] = function (self, causer, target, t)
    if self ~= causer then
        return
    end
    if t.name ~= "杀" then
        return
    end
    local func = function (id) return resmng[id].type == "add_horse" or resmng[id].type == "sub_horse" end
    if not next(target:get_cards(func, false, true)) then
        return
    end
    if not query["询问发动技能"]("麒麟弓") then
        return
    end
    opt["弃置一张牌"](self, target, "麒麟弓", false, true, false, func)
end

function Player:add_life(n)
    if self.life + n > self.life_limit then
        self.life = self.life_limit
    else
        self.life = self.life + n
    end
end

-- t包含casuer, type, name, card_id（牌）, n, settle_finish 
function Player:sub_life(t)
    -- 体力流失
    if t.type == macro.sub_life_type.life_loss then
        self.life = self.life - t.n
        text("%s因%s流失%d点体力", self.name, t.name, t.n)
        if self.life <= 0 then
            self:dying(t)
        end
    -- 受到伤害
    else
        if t.causer:has_skill("狂骨") then
            if t.causer:get_distance(self) <= 1 then
                t.causer["狂骨"] = true
            end
        end
        game.skill["造成伤害时"](game, t.causer, self, t)
        if t.settle_finish then
            return
        end
        game.skill["受到伤害时"](game, t.causer, self, t)
        if t.settle_finish then
            return
        end
        if t.causer:has_skill("狂骨") then
            if t.causer:get_distance(self) <= 1 then
                t.causer["狂骨"] = true
            end
        end
        self.life = self.life - t.n
        text("%s因%s受到%d点伤害", self.name, t.name, t.n)
        if self.life <= 0 then
            self:dying(t)
        end
        if game.finish then
            return
        end
        game.skill["造成伤害后"](game, t.causer, self, t)
        game.skill["受到伤害后"](game, t.causer, self, t)
    end
end

-- 造成伤害时
Player.skill["造成伤害时"] = function (self, causer, responder, t)
    if self:has_skill("寒冰剑") then
        self.skill["寒冰剑"](self, causer, responder, t)
    elseif self:has_skill("麒麟弓") then
        self.skill["麒麟弓"](self, causer, responder, t)
    end
end

-- 受到伤害时
Player.skill["受到伤害时"] = function (self, causer, responder, t)

end

-- 濒死
function Player:dying(t)
    local settle_players
    if game.whose_turn:has_skill("完杀") then
        settle_players = game.whose_turn == self and {self} or {game.whose_turn, self}
    else
        settle_players = game:get_settle_players(game.whose_turn)
    end
    local check_peach_func = function (id) return resmng[id].name == "桃" end
    for _, player in ipairs(settle_players) do
        if player == self and self:has_skill("不屈") then
            self.skill["不屈"](self)
        end
        while self.life <= 0 do
            local peachs = player:get_cards(check_peach_func, true)
            local skills = {}
            if player == self and self:has_skill("涅槃") then
                if not self["已使用涅槃"] then
                    helper.insert(skills, resmng.get_skill_id("涅槃"))   
                end
            elseif player:has_skill("急救") then
                local check_red_func = function (id) return self:get_color(id) == macro.color.red end
                local cards = self:get_cards(check_red_func, true, true)
                if next(cards) and game.whose_turn ~= self then
                    helper.insert(skills, resmng.get_skill_id("急救"))
                end
            end
            if next(peachs) or next(skills) then
                local id = query["询问出牌"](peachs, skills, "桃")
                if resmng.check_card(id) then
                    helper.remove(player.hand_cards, id)
                    game.skill["失去手牌"](game, player, player, "使用")
                    player:before_settle(id)
                    player.use["桃"](player, self)
                    player:after_settle(id)
                elseif resmng.check_skill(id) then
                    if resmng[id] == "急救" then
                        player.skill["急救"](player, self)
                    elseif resmng[id] == "涅槃" then
                        self.skill["涅槃"](self)
                    end
                else
                    break
                end
            else
                break
            end
        end
        if self.life > 0 then
            break
        end
    end
    if self.life <= 0 then
        text("%s已死亡", self.name)
        for _, player in ipairs(settle_players) do
            if player == self and self:has_skill("断肠") then
                self.skill["断肠"](self, t.causer)
            elseif player ~= self and player:has_skill("行殇") then
                player.skill["行殇"](player, self)
            end
        end
        local cards = {}
        if next(self.hand_cards) then
            helper.insert(cards, self.hand_cards)
            helper.clear(self.hand_cards)
        end
        for _, id in ipairs(self:get_equip_cards()) do
            local type = resmng[id].type
            if self[type] then
                helper.insert(cards, self[type])
                self[type] = nil
            end
        end
        if next(self.judge_cards) then
            helper.insert(cards, self.judge_cards)
            helper.clear(self.judge_cards)
        end
        -- 邓艾的田、周泰的创
        if self["田"] and next(self["田"]) then
            helper.insert(cards, self["田"])
            helper.clear(self["田"])
        end
        if self["创"] and next(self["创"]) then
            helper.insert(cards, self["创"])
            helper.clear(self["创"])
        end
        helper.insert(deck.discard_pile, cards)
        helper.remove(game.players, self)
        for i = self.order, #game.players, 1 do
            game.players[i].order = i
        end
        if #game.players == 1 then
            game.finish = true
        end
    end
end

-- 造成伤害后
Player.skill["造成伤害后"] = function (self, causer, responder, t)

end

-- 受到伤害后
Player.skill["受到伤害后"] = function (self, causer, responder, t)

end

Player.get_targets["杀"] = function (self, t)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if target:has_skill("空城") and #target.hand_cards == 0 then
            goto continue
        end
        if t.is_transfer then
            if t.transfer_type == "神速" then
                helper.insert(targets, target)
            elseif t.transfer_type == "武圣" then
                if helper.element(self:get_players_in_attack_range(), target) then
                    helper.insert(targets, target)   
                end
            elseif t.transfer_type == "龙胆" then
                if helper.element(self:get_players_in_attack_range(), target) then
                    helper.insert(targets, target)
                end
            elseif t.transfer_type == "丈八蛇矛" then
                if helper.element(self:get_players_in_attack_range(), target) then
                    helper.insert(targets, target)
                end
            end
        else
            if self:has_flag("天义-赢") then
                helper.insert(targets, target)
            elseif self:has_skill("烈弓") and resmng[t.id].points >= self:get_distance(target) then
                helper.insert(targets, target)
            elseif helper.element(self:get_players_in_attack_range(), target) then
                helper.insert(targets, target)
            end
        end
        ::continue::
    end
    return targets
end

Player.get_targets["南蛮入侵"] = function (self, id)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if not (target:has_skill("帷幕") and self:get_color(id) == macro.color.black) then
            helper.insert(targets, target)
        end
    end
    return targets
end

Player.get_targets["万箭齐发"] = function (self, id)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if not (target:has_skill("帷幕") and self:get_color(id) == macro.color.black) then
            helper.insert(targets, target)
        end
    end
    return targets
end

Player.get_targets["决斗"] = function (self, id)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if target:has_skill("帷幕") and self:get_color(id) == macro.color.black then
            goto continue
        end
        if target:has_skill("空城") and #target.hand_cards == 0 then
            goto continue
        end
        helper.insert(targets, target)
        ::continue::
    end
    return targets
end

Player.get_targets["过河拆桥"] = function (self, id)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if target:has_skill("帷幕") and self:get_color(id) == macro.color.black then
            goto continue
        end
        if not next(target:get_cards(nil, true, true, true)) then
            goto continue
        end
        helper.insert(targets, target)
        ::continue::
    end
    return targets
end

Player.get_targets["顺手牵羊"] = function (self, id)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if target:has_skill("帷幕") and self:get_color(id) == macro.color.black then
            goto continue
        end
        if not next(target:get_cards(nil, true, true, true)) then
            goto continue
        end
        if target:has_skill("谦逊") then
            goto continue
        end
        if not self:has_skill("奇才") and self:get_distance(target) > 1 then
            goto continue
        end
        helper.insert(targets, target)
        ::continue::
    end
    return targets
end

Player.get_targets["借刀杀人"] = function (self, id)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if target:has_skill("帷幕") and self:get_color(id) == macro.color.black then
            goto continue
        end
        if not target.arm then
            goto continue
        end
        if not next(target:get_players_in_attack_range()) == 0 then
            goto continue

        end
        helper.insert(targets, target)
        ::continue::
    end
    return targets
end

Player.get_targets["乐不思蜀"] = function (self, id)
    local targets = {}
    for _, target in ipairs(game:get_other_players(self)) do
        if target:has_skill("帷幕") and self:get_color(id) == macro.color.black then
            goto continue
        end
        if target:has_skill("谦逊") then
            goto continue
        end
        helper.insert(targets, target)
        ::continue::
    end
    return targets
end

-- 南蛮入侵
Player.use["南蛮入侵"] = function (self, id)
    local settle_players = game:get_settle_players_except_self(self)
    for _, player in ipairs(settle_players) do
        if player:check_alive() then
            if not (player:has_skill("帷幕") and self:get_color(id) == macro.color.black) then
                player.respond["南蛮入侵"](player, self, id)         
            end
        end
    end
end

Player.respond["南蛮入侵"] = function (self, causer, id)
    text("%s结算南蛮入侵：", self.name)
    if self:has_skill("祸首") or self:has_skill("巨象") then
        return
    end
    if self["无懈可击"](self, causer, false) then
        return
    end
    for _, player in ipairs(game.players) do
        if player:has_skill("祸首") then
            causer = player
            break
        end
    end
    local func = function (id1) return resmng[id1].name == "杀" end
    local kills = self:get_cards(func, true)
    local skills = self:get_skills_can_be_card("杀")
    if next(kills) or next(skills) then
        local id1 = query["询问出牌"](kills, skills, "杀")
        if resmng.check_card(id1) then
            helper.remove(self.hand_cards, id1)
            game.skill["失去手牌"](game, self, self, "打出")
            helper.insert(deck.discard_pile, id1)
        elseif resmng.check_skill(id1) then
            self.skill["杀"](self, id1, "南蛮入侵")
        else
            self:sub_life({causer = causer, type = macro.sub_life_type.damage, name = "南蛮入侵", card_id = id, n = 1})
        end
    else
        self:sub_life({causer = causer, type = macro.sub_life_type.damage, name = "南蛮入侵", card_id = id, n = 1})
    end
end

-- 万箭齐发
Player.use["万箭齐发"] = function (self, id)
    local settle_players = game:get_settle_players_except_self(self)
    for _, player in ipairs(settle_players) do
        if player:check_alive() then
            if not (player:has_skill("帷幕") and self:get_color(id) == macro.color.black) then
                player.respond["万箭齐发"](player, self, id)         
            end
        end
    end
end

Player.respond["万箭齐发"] = function (self, causer, id)
    text("%s结算万箭齐发：", self.name)
    if self["无懈可击"](self, causer, false) then
        return
    end
    if self:has_skill("八卦阵") and self.skill["八卦阵"](self) or self:has_skill("八阵") and self.skill["八阵"](self) then
        if self:has_skill("雷击") then
            self.skill["雷击"](self)
        end
        return
    end
    local func = function (id1) return resmng[id1].name == "闪" end
    local dodges = self:get_cards(func, true)
    local skills = self:get_skills_can_be_card("闪")
    if next(dodges) or next(skills) then
        local id1 = query["询问出牌"](dodges, skills, "闪")
        if resmng.check_card(id1) then
            helper.remove(self.hand_cards, id1)
            game.skill["失去手牌"](game, self, self, "打出")
            helper.insert(deck.discard_pile, id1)
            if self:has_skill("雷击") then
                self.skill["雷击"](self)
            end
        elseif resmng.check_skill(id1) then
            self.skill["闪"](self, id1, "万箭齐发")
        else
            self:sub_life({causer = causer, type = macro.sub_life_type.damage, name = "万箭齐发", card_id = id, n = 1})
        end
    else
        self:sub_life({causer = causer, type = macro.sub_life_type.damage, name = "万箭齐发", card_id = id, n = 1})
    end
end

-- 五谷丰登
Player.use["五谷丰登"] = function (self, id)
    local ids = deck:draw(#game.players)
    local settle_players = game:get_settle_players(self)
    for _, player in ipairs(settle_players) do
        player.respond["五谷丰登"](player, self, ids)           
    end
    if next(ids) then
        helper.insert(deck.discard_pile, ids)
    end
end

Player.respond["五谷丰登"] = function (self, causer, ids)
    text("%s结算五谷丰登：", self.name)
    if self["无懈可击"](self, causer, false) then
        return
    end
    local id = query["选择一张牌"](ids, "五谷丰登")
    helper.remove(ids, id)
    helper.insert(self.hand_cards, id)
end

-- 桃园结义
Player.use["桃园结义"] = function (self, id)
    local settle_players = game:get_settle_players(self)
    for _, player in ipairs(settle_players) do
        player.respond["桃园结义"](player, self)           
    end
end

Player.respond["桃园结义"] = function (self, causer)
    text("%s结算桃园结义：", self.name)
    if self["无懈可击"](self, causer, false) then
        return
    end
    self:add_life(1)
end

-- 过河拆桥
Player.use["过河拆桥"] = function (self, id)
    local targets = self.get_targets["过河拆桥"](self, id)
    local target = query["选择一名玩家"](targets, "过河拆桥")
    target.respond["过河拆桥"](target, self)
end

Player.respond["过河拆桥"] = function (self, causer)
    text("%s结算过河拆桥：", self.name)
    if self["无懈可击"](self, causer, false) then
        return
    end
    if not next(self:get_cards(nil, true, true, true)) then
        return
    end
    opt["弃置一张牌"](causer, self, "过河拆桥", true, true, true)
end

-- 顺手牵羊
Player.use["顺手牵羊"] = function (self, id)
    local targets = self.get_targets["顺手牵羊"](self, id)
    local target = query["选择一名玩家"](targets, "顺手牵羊")
    target.respond["顺手牵羊"](target, self)
end

Player.respond["顺手牵羊"] = function (self, causer)
    text("%s结算顺手牵羊：", self.name)
    if self["无懈可击"](self, causer, false) then
        return
    end
    if not next(self:get_cards(nil, true, true, true)) then
        return
    end
    opt["获得一张牌"](causer, self, "顺手牵羊", true, true, true)
end

-- 无中生有
Player.use["无中生有"] = function (self, id)
    text("%s结算无中生有：", self.name)
    if self["无懈可击"](self, self, false) then
        return
    end
    local cards = deck:draw(2)
    helper.insert(self.hand_cards, cards)
end

-- 借刀杀人
Player.use["借刀杀人"] = function (self, id)
    local targets = self.get_targets["借刀杀人"](self, id)
    local target = query["选择一名玩家"](targets, "借刀杀人-选被借刀者")
    local targets1 = target:get_players_in_attack_range()
    local target1 = query["选择一名玩家"](targets1, "借刀杀人-选被杀者")
    target.respond["借刀杀人"](target, self, target1)
end

Player.respond["借刀杀人"] = function (self, causer, target)
    if self["无懈可击"](self, causer, false) then
        return
    end
    local func = function (id) return resmng[id].name == "杀" end
    local kills = self:get_cards(func, true)
    local skills = self:get_skills_can_be_card("杀")
    if next(kills) or next(skills) then
        local id = query["询问出牌"](kills, skills, "杀")
        if resmng.check_card(id) then
            helper.remove(self.hand_cards, id)
            game.skill["失去手牌"](game, self, self, "使用")
            self:before_settle(id)
            self.use["杀"](self, {id = id}, "借刀杀人", target)
            self:after_settle(id)
        elseif resmng.check_skill(id) then
            self.skill["杀"](self, id, "借刀杀人", target)
        else
            local arm_id = self.arm
            self:take_off_equip(arm_id)
            self.skill["失去装备"](self)
            helper.insert(causer.hand_cards, arm_id)
        end
    else
        local arm_id = self.arm
        self:take_off_equip(arm_id)
        self.skill["失去装备"](self)
        helper.insert(causer.hand_cards, arm_id)
    end
end

-- 决斗
Player.use["决斗"] = function (self, id)
    local targets = self.get_targets["决斗"](self, id)
    local target = query["选择一名玩家"](targets, "决斗")
    self.skill["决斗-指定目标后"](self, id)
    target.skill["决斗-成为目标后"](target, self, id)
    if target["无懈可击"](target, self, false) then
        return
    end
    target.respond["决斗"](target, self, id)
end

Player.respond["决斗"] = function (self, causer, id)
    local need_kill = 1
    if causer:has_skill("无双") then
        need_kill = 2
    end
    local kill_success = true
    while need_kill > 0 do
        local func = function (id1) return resmng[id1].name == "杀" end
        local kills = self:get_cards(func, true)
        local skills = self:get_skills_can_be_card("杀")
        if next(kills) or next(skills) then
            local id1 = query["询问出牌"](kills, skills, "杀")
            if resmng.check_card(id1) then
                helper.remove(self.hand_cards, id1)
                game.skill["失去手牌"](game, self, self, "打出")
                helper.insert(deck.discard_pile, id1)
                need_kill = need_kill - 1
                if self:has_skill("克己") and game.whose_turn == self then
                    self.flags["使用或打出过杀"] = true
                end
            elseif resmng.check_skill(id1) then
                self.skill["杀"](self, id1, "决斗")
                need_kill = need_kill - 1
            else
                kill_success = false
                break
            end
        else
            kill_success = false
            break
        end    
    end
    if kill_success then
        causer.respond["决斗"](causer, self, id)
    else
        local n = 1
        if causer:has_flag("裸衣") then
            n = n + 1
        end
        self:sub_life({causer = causer, type = macro.sub_life_type.damage, name = id and "决斗" or "离间", card_id = id, n = n})
    end
end

-- 无懈可击
Player["无懈可击"] = function (self, first_settle_player, is_valid)
    local settle_players = game:get_settle_players(first_settle_player)
    for _, player in ipairs(settle_players) do
        local func = function (id) return resmng[id].name == "无懈可击" end
        local wxkjs = player:get_cards(func, true)
        local skills = player:get_skills_can_be_card("无懈可击")
        if next(wxkjs) or next(skills) then
            local id = query["询问出牌"](wxkjs, skills, "无懈可击")
            if resmng.check_card(id) then
                helper.remove(player.hand_cards, id)
                if player:has_skill("集智") then
                    player.skill["集智"](player)
                else
                    game.skill["失去手牌"](game, player, player, "使用")
                end
                self:before_settle(id)
                self:after_settle(id)
                return first_settle_player["无懈可击"](first_settle_player, player, not is_valid)
            elseif resmng.check_skill(id) then
                player.skill["无懈可击"](player, id)
                return first_settle_player["无懈可击"](first_settle_player, player, not is_valid)
            end  
        end       
    end
    return is_valid
end

Player.use["乐不思蜀"] = function (self, id)
    local targets = self.get_targets["乐不思蜀"](self, id)
    local target = query["选择一名玩家"](targets, "乐不思蜀")
    helper.put(target.judge_cards, id)
end

Player.respond["乐不思蜀"] = function (self, id)
    helper.remove(self.judge_cards, id)
    self:before_settle(id)
    if self["无懈可击"](self, self, false) then
        self:after_settle(id)
        return
    end
    text("%s判定乐不思蜀", self.name)
    local judge_card_id = game:judge(self, "乐不思蜀")
    if not (self:has_skill("天妒") and self.skill["天妒"](self, judge_card_id)) then
        helper.insert(deck.discard_pile, judge_card_id)   
    end
    if self:get_suit(judge_card_id) ~= macro.suit.heart then
        self.flags["跳过出牌"] = true
    end
    self:after_settle(id)
end

Player.use["闪电"] = function (self, id)
    helper.put(self.judge_cards, id)
end

Player.respond["闪电"] = function (self, id)
    helper.remove(self.judge_cards, id)
    self:before_settle(id)
    local check_can_move = function (target)
        if target:has_skill("帷幕") and (resmng[id].suit == macro.suit.club or resmng[id].suit == macro.suit.spade) then
            return false
        end
        for _, id in ipairs(target.judge_cards) do
            if game:get_judge_card_name(id) == "闪电" then
                return false
            end
        end
        return true
    end
    if self["无懈可击"](self, self, false) then
        local next_target = self.order + 1 <= #game.players and game.players[self.order + 1] or game.players[1]
        while not check_can_move(next_target) do
            next_target = self.order + 1 <= #game.players and game.players[self.order + 1] or game.players[1]
        end
        helper.pop(game.settling_card)
        helper.put(next_target.judge_cards, id)
        return
    end
    text("%s判定闪电", self.name)
    local judge_card_id = game:judge(self, "闪电")
    if not (self:has_skill("天妒") and self.skill["天妒"](self, judge_card_id)) then
        helper.insert(deck.discard_pile, judge_card_id)   
    end
    if self:get_suit(judge_card_id) == macro.suit.spade and resmng[judge_card_id].points >= 2 and resmng[judge_card_id].points <= 9 then
        self:sub_life({causer = nil, type = macro.sub_life_type.life_loss, name = "闪电", card_id = id, n = 3})
        self:after_settle(id)
    else
        local next_target = self.order + 1 <= #game.players and game.players[self.order + 1] or game.players[1]
        while not check_can_move(next_target) do
            next_target = self.order + 1 <= #game.players and game.players[self.order + 1] or game.players[1]
        end
        helper.pop(game.settling_card)
        helper.put(next_target.judge_cards, id)
    end
end

return Player