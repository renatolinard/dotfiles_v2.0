require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- comand : ;
--map("n", ";", ":", { desc = "CMD enter command mode" })
-- exit more faster
map("i", "<ESC>", "<ESC><ESC>")
-- move with highlight
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlight text wtih J" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlight text wtih K" })
-- keep cursor center
map("n", "<C-d>", "<C-d>zz", { desc = "lets you move down half a page by scrolling the page" })
map("n", "<C-u>", "<C-u>zz", { desc = "lets you move up half a page by scrolling the page" })
-- Oil float
map("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory with Oil" })
-- select all
map("n", "==", "gg<S-v>G", { desc = "select all"})
-- replace word under cursor across entire buffer 
map("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc = "Replace word under cursor"})
-- go to column 80
map("n", "<C-l>", "80l", { desc = "Go to Column 80" })
--browser preview
map("n", "<leader>bp", "<cmd>:BrowserPreview<cr>", { desc = "Start markdownpreview" })
-- Close Oil buffer with "esc"
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>q<cr>", { noremap = true, silent = true })
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
