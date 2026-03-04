return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>hl",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "[H]arpoon [L]ist",
			},
			{
				"<leader>ha",
				function()
					require("harpoon"):list():add()
				end,
				desc = "[H]arpoon [A]dd",
			},
			{
				"<leader>hn",
				function()
					require("harpoon"):list():next()
				end,
				desc = "[H]arpoon [N]ext",
			},
			{
				"<leader>hb",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "[H]arpoon [B]ack",
			},
			{
				"<leader>hg",
				function()
					local char = vim.fn.getchar()
					local str = vim.fn.nr2char(char)
					local num = tonumber(str)

					if num and num > 0 then
						require("harpoon"):list():select(num)
					else
						vim.notify("Incorrect index")
					end
				end,
				desc = "[H]arpoon: [G]et file",
			},
		},
		config = function()
			require("harpoon").setup({})
		end,
	},
}
