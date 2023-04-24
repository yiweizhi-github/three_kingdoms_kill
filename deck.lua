Deck = class()

function Deck:ctor()
    self.card_pile = {}
    self.discard_pile = {}
end

local function shuffle(card_pile)
    local len = #card_pile
    while len > 0 do
        local i = math.random(len)
        local id = card_pile[i]
        card_pile[i] = card_pile[len]
        card_pile[len] = id
        len = len - 1
    end
end

function Deck:init()
    for i = 1, resmng.card_finish_id - resmng.card_start_id + 1, 1 do
        helper.insert(self.card_pile, i)
    end
    shuffle(self.card_pile)
end

function Deck:draw(n)
    if #self.card_pile < n then
        shuffle(self.discard_pile)
        helper.insert(self.card_pile, self.discard_pile)     
        helper.clear(self.discard_pile)
    end
    local cards = {}
    for _ = 1, n, 1 do
        helper.insert(cards, self.card_pile[1])
        table.remove(self.card_pile, 1)
    end
    return n == 1 and cards[1] or cards
end

return Deck