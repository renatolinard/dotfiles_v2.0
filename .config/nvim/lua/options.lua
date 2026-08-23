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

-- indentation and tabs
set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true

-- wrap column 80
set.textwidth = 80
set.wrap = true

