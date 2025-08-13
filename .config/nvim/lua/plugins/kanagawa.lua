local function enable_transparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end
return {
	"thesimonho/kanagawa-paper.nvim",
	lazy = false,
	priority = 1000,
	init = function()
		vim.cmd.colorscheme("kanagawa-paper-ink")
		vim.cmd("hi Directory guibg=NONE")
		vim.cmd("hi SignColumn guibg=NONE")
		enable_transparency()
	end,
	opts = {},
}
