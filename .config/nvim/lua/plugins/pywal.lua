local function enable_transparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end

return {
	{
		"uZer/pywal16.nvim",
		name = "pywal16",
		config = function()
			vim.cmd.colorscheme("pywal16")
			vim.cmd("hi Directory guibg=NONE")
			vim.cmd("hi SignColumn guibg=NONE")
			enable_transparency()
		end,
	},
}
