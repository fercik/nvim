return {
	"marko-cerovac/material.nvim",
	enabled = false,
	config = function()
		require("material").setup({
			config = {
				contrast = {
					sidebars = true,
					floating_windows = true,
					line_numbers = true,
					cursor_line = false,
					non_current_windows = true,
					popup_menu = true,
				},
			},
			plugins = {
				"gitsigns",
				"nvim-cmp",
				"telescope",
				"nvim-tree",
				"which-key",
			},
			lualine_style = "stealth",
		})
		-- vim.g.material_style = "deep ocean"
		-- vim.cmd.colorscheme("material")
	end,
}
