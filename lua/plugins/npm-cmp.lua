return {
	"David-Kunz/cmp-npm",
	dependencies = { "nvim-lua/plenary.nvim" },
	ft = "json",
	config = function()
		local cmp = require("cmp-npm")

		cmp.setup({
			sources = {
				{ name = "npm", keyword_length = 4 },
			},
		})
	end,
}
