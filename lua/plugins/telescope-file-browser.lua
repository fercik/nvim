return {
	"nvim-telescope/telescope-file-browser.nvim",
	keys = {
		{ "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "[F]ile [B]rowser" },
	},
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local fb_actions = telescope.extensions.file_browser.actions

		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
			},
			extensions = {
				file_browser = {
					grouped = true,
					hidden = true,
					mappings = {
						["i"] = {
							["<C-c>"] = fb_actions.create,
							["<C-r>"] = fb_actions.rename,
							["<C-d>"] = fb_actions.remove,
							["<C-y>"] = fb_actions.copy,
						},
					},
				},
			},
		})
		telescope.load_extension("file_browser")
	end,
}
