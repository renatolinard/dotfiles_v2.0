local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Ao digitar '!' e apertar Tab, ele expande para a estrutura
  s("!", {
    t("extends "), i(1, "Node"), t({"", "", "func _ready():", "\t"}),
    i(2, "pass"), t({"", "", "func _process(delta):", "\t"}),
    i(3, "pass"),
  }),
}
