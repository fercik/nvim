return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {},
	},
	config = function(_, opts)
		local function palette()
			if vim.o.background == "light" then
				return {
					surface = "#f1f0f0",
					text = "#656363",
					text_strong = "#211e1e",
					normal = "#8e8b8b",
					insert = "#d68c27",
					visual = "#ed6dc8",
					terminal = "#da3319",
				}
			end

			return {
				surface = "#1c1717",
				text = "#b7b1b1",
				text_strong = "#131010",
				normal = "#7f7979",
				insert = "#fab283",
				visual = "#ff9ae2",
				terminal = "#ff917b",
			}
		end

		local function build_theme()
			local c = palette()

			return {
				normal = {
					a = { bg = c.normal, fg = c.text_strong, gui = "bold" },
					b = { bg = c.surface, fg = c.normal },
					c = { bg = c.surface, fg = c.text },
				},
				insert = {
					a = { bg = c.insert, fg = c.text_strong, gui = "bold" },
					b = { bg = c.surface, fg = c.insert },
					c = { bg = c.surface, fg = c.text },
				},
				visual = {
					a = { bg = c.visual, fg = c.text_strong, gui = "bold" },
					b = { bg = c.surface, fg = c.visual },
					c = { bg = c.surface, fg = c.text },
				},
				replace = {
					a = { bg = c.terminal, fg = c.text_strong, gui = "bold" },
					b = { bg = c.surface, fg = c.terminal },
					c = { bg = c.surface, fg = c.text },
				},
				command = {
					a = { bg = c.terminal, fg = c.text_strong, gui = "bold" },
					b = { bg = c.surface, fg = c.terminal },
					c = { bg = c.surface, fg = c.text },
				},
				terminal = {
					a = { bg = c.terminal, fg = c.text_strong, gui = "bold" },
					b = { bg = c.surface, fg = c.terminal },
					c = { bg = c.surface, fg = c.text },
				},
				inactive = {
					a = { bg = c.surface, fg = c.text },
					b = { bg = c.surface, fg = c.text },
					c = { bg = c.surface, fg = c.text },
				},
			}
		end

		local function setup()
			local config = vim.deepcopy(opts)
			config.options = vim.tbl_extend("force", config.options or {}, {
				theme = build_theme(),
			})
			require("lualine").setup(config)
		end

		setup()

		local group = vim.api.nvim_create_augroup("lualine_theme_refresh", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = group,
			callback = setup,
		})
		vim.api.nvim_create_autocmd("OptionSet", {
			group = group,
			pattern = "background",
			callback = function()
				vim.schedule(setup)
			end,
		})
	end,
}
