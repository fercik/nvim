return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{ "<leader>re", ":Refactor extract ", mode = "x", desc = "[R]efactor [E]xtract" },
		{ "<leader>rf", ":Refactor extract_to_file ", mode = "x", desc = "[R]efactor extract to [F]ile" },
		{ "<leader>rv", ":Refactor extract_var ", mode = "x", desc = "[R]efactor extract [V]ar" },
		{ "<leader>ri", ":Refactor inline_var", mode = { "n", "x" }, desc = "[R]efactor [I]nline var" },
		{ "<leader>rI", ":Refactor inline_func", desc = "[R]efactor [I]nline Func" },
		{ "<leader>rb", ":Refactor extract_block", desc = "[R]efactor extract [B]lock" },
		{ "<leader>rbf", ":Refactor extract_block_to_file", desc = "[R]efactor extract [B]lock to [F]ile" },
	},
	config = function()
		require("refactoring").setup()
	end,
}
