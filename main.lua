require("class")
require("helper")
require("deck")
require("game")
require("macro")
require("opt")
require("player")
require("query")
require("resmng")

deck = Deck:new()
game = Game:new()

deck:init()
game:init()

game:main()