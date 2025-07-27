return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = function()
					-- pcall and fallback theme is to handle the case of theme switching/previewing
					local ok, t = pcall(
						require,
						"lualine.themes."
							.. (vim.o.background == "light" and "kanagawa-paper-canvas" or "kanagawa-paper-ink")
					)
					if ok then
						theme = t
					else
						theme = require("some other fallback theme")
					end
					return theme
				end,
				-- ... your lualine config
			},
		})
	end,
}
