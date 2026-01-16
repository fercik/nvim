return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			theme = "auto",
		},
	},
	config = function(_, opts)
		require("lualine").setup(opts)

		-- Refresh lualine when colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				-- Refresh with same opts to pick up new colorscheme colors
				require("lualine").setup(opts)
			end,
		})
	end,
}
