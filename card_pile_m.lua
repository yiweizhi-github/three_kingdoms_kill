card_pile_m = {}

function card_pile_m.init()
    local card_pile = {}
    for i = 1, #card_m, 1 do
        table.insert(card_pile, i)
    end
    return shuffle(card_pile)
end

function card_pile_m.draw(card_pile, discard_pile, n)
    if #card_pile < n then
        local discard_pile1 = shuffle(discard_pile)
        for i = 1, #card_pile, 1 do
            table.insert(discard_pile1, i, card_pile[i])
        end       
        card_pile = discard_pile1
        discard_pile = {}
    end
    local cards = {}
    local i = 1
    while i <= n do
        table.insert(cards, card_pile[1])
        table.remove(card_pile, 1)
        i = i + 1
    end
    return cards
end

function shuffle(card_pile)
    local card_pile1 = {}
    local len = #card_pile
    math.randomseed(os.time())
    while len > 0 do
        local p = math.random(len)
        table.insert(card_pile1, card_pile[p])
        table.remove(card_pile, p)
        len = len - 1
    end
    return card_pile1
end

return card_pile_m