-- KEYBINDS
vim.g.mapleader = " "

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Remap joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor in place while moving up/down page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center screen when looping search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- sometimes in insert mode, control-c doesn't exactly work like escape
vim.keymap.set("i", "<C-a>", "<Esc>")

-- Custom Mappings (using <Leader>)
vim.keymap.set("n", "<leader>o", vim.cmd.Oil, { desc = "Open Oil File Explorer" }) -- Open Oil
vim.keymap.set("n", "<leader>tc", function()
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = "80"
  else
    vim.o.colorcolumn = ""
  end
end, { desc = "Toggle Colorcolumn at 80" })

vim.keymap.set("n", "<leader>e", "<cmd>:nohlsearch<cr>", { desc = "Clear Search Highlight" })
vim.keymap.set("n", "<leader>80", "80l", { desc = "Go to Column 80" })
