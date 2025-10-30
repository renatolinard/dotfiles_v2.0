-- OPTIONS
local set = vim.opt

require "nvchad.options"
vim.opt.guicursor = ""

set.nu = true
set.relativenumber = true
set.colorcolumn = "80"

-- search settings
set.ignorecase = true
set.smartcase = true

-- keep cursor at least 8 rows from top/bot
set.scrolloff = 8
