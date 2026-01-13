return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		event = "LspAttach",
		keys = {
			{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "[F]ind [F]iles" },
			{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "[F]ile [G]rep" },
		},
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules" },
				},
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown(),
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
