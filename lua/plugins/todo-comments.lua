return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "[F]ind [T]odos" },
	},
}

