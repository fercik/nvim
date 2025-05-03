return {
	"nvim-telescope/telescope-file-browser.nvim",
	lazy = false,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
			},
			extensions = {
				file_browser = {
					grouped = true,
					hidden = true,
				},
			},
		})
		telescope.load_extension("file_browser")

		vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
	end,
}
