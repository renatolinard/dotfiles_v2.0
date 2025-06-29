-- OPTIONS
local set = vim.opt

-- Always show relative line numbers
set.number = true
set.relativenumber = true

-- keep cursor at least 8 rows from top/bot
set.scrolloff = 8

-- Hide the command line area
set.cmdheight = 0

-- clipboard
set.clipboard:append("unnamedplus")

set.expandtab = true -- Convert tabs to spaces
set.shiftwidth = 4 -- Amount to indent with << and >>
set.tabstop = 4 -- How many spaces are shown per Tab
set.softtabstop = 4 -- How many spaces are applied when pressing Tab

set.smarttab = true
set.smartindent = true
set.autoindent = true -- Keep identation from previous line

-- Enable break indent
set.breakindent = true

-- Store undos between sessions
set.undofile = true

-- Don't show the mode, since it's already in the status line
set.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
set.ignorecase = true
set.smartcase = true

-- Keep signcolumn on by default
set.signcolumn = "yes"

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
set.list = true
set.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- 80th column
set.colorcolumn = "80"
--
-- block cursor
set.guicursor = ""
