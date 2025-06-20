-- KEYBINDS
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Alt Up/Down in vscode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")       -- Remap joining lines
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Keep cursor in place while moving up/down page
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")       -- center screen when looping search results
vim.keymap.set("n", "N", "Nzzzv")

-- sometimes in insert mode, control-c doesn't exactly work like escape
vim.keymap.set("i", "<C-a>", "<Esc>")

-- enter insert mode
vim.keymap.set("n", "|", "i")

-- desativar highlight
vim.keymap.set("n", "<return>", "<cmd>:nohlsearch<cr>")

-- ir coluna 80
vim.keymap.set ("n", "<C-l>", "80l")



