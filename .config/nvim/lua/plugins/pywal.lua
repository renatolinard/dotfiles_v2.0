return {
	"uZer/pywal16.nvim",
	-- for local dev replace with:
	-- dir = '~/your/path/pywal16.nvim',
	config = function()
		vim.cmd.colorscheme("pywal16")
		local pywal16 = require("pywal16")

		pywal16.setup()
	end,
}
