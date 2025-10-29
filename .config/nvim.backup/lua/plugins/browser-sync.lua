return {
	"ray-x/web-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	init = function()
		require("web-tools").setup({})
	end,
}
