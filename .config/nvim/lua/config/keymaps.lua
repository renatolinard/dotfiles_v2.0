-- KEYBINDS
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected down" })

-- Diagnostic
vim.keymap.set("n", "dc", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

-- select all
vim.keymap.set("n", "==", "gg<S-v>G")

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP')

-- Get out Q
vim.keymap.set("n", "Q", "<nop>")

-- Replace word under cursor across entire buffer
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- Keep cursor in place while moving up/down page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- sometimes in insert mode, control-c doesn't exactly work like escape
vim.keymap.set("i", "<C-a>", "<Esc><Esc>")

-- Custom Mappings (using <Leader>)

vim.keymap.set("n", "<leader>tc", function()
	if vim.o.colorcolumn == "" then
		vim.o.colorcolumn = "80"
	else
		vim.o.colorcolumn = ""
	end
end, { desc = "Toggle Colorcolumn at 80" })

vim.keymap.set("n", "<Esc>", "<cmd>:nohlsearch<cr>", { desc = "Clear Search Highlight" })
vim.keymap.set("n", "<C-l>", "80l", { desc = "Go to Column 80" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Close oil buffer with <esc>
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>q<cr>", { noremap = true, silent = true })
	end,
})
