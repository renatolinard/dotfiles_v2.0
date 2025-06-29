require("config.keymaps")
require("config.options")
require("config.lazy")

-- Habilita o "bracketed paste mode" automaticamente ao entrar no tmux
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "tmux://*",
  callback = function()
    vim.cmd("set paste")
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  pattern = "tmux://*",
  callback = function()
    vim.cmd("set nopaste")
  end,
})
