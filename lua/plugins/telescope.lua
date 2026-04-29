local file_browser_entry_maker_patched = false

local function patch_file_browser_entry_maker()
	local module_name = "telescope._extensions.file_browser.make_entry"
	local strings = require("plenary.strings")
	local original_make_entry = package.loaded[module_name] or require(module_name)

	if file_browser_entry_maker_patched then
		return
	end

	local patched_make_entry = function(opts)
		local upstream_entry_maker = original_make_entry(opts)

		return function(...)
			local entry = upstream_entry_maker(...)
			local current_display = rawget(entry, "display") or entry.display
			local wrapped_display = rawget(entry, "__oc_wrapped_display")

			if current_display ~= wrapped_display then
				local original_display = current_display

				wrapped_display = function(self, ...)
					local original_truncate = strings.truncate

					strings.truncate = function(str, len, dots, direction)
						if direction == -1 then
							return original_truncate(str, len, dots, 1)
						end

						return original_truncate(str, len, dots, direction)
					end

					local ok, display, highlights = pcall(original_display, self, ...)
					strings.truncate = original_truncate

					if not ok then
						error(display)
					end

					return display, highlights
				end

				-- telescope-file-browser truncates from the left by default.
				entry.__oc_wrapped_display = wrapped_display
				entry.display = wrapped_display
			end

			return entry
		end
	end

	package.loaded[module_name] = patched_make_entry
	file_browser_entry_maker_patched = true
end

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		event = "LspAttach",
		keys = {
			{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "[F]ind [F]iles" },
			{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "[F]ile [G]rep" },
			{
				"<leader>fb",
				function()
					local bufname = vim.api.nvim_buf_get_name(0)
					local path = bufname ~= "" and vim.fs.dirname(vim.fs.normalize(bufname)) or vim.fn.getcwd()
					require("telescope").extensions.file_browser.file_browser({
						path = path,
						select_buffer = true,
					})
				end,
				desc = "[F]ile [B]rowser",
			},
		},
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			patch_file_browser_entry_maker()

			local fb_actions = require("telescope._extensions.file_browser.actions")
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					file_ignore_patterns = { "node_modules" },
					sorting_strategy = "ascending",
				},
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown(),
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
			telescope.load_extension("ui-select")
			telescope.load_extension("file_browser")
		end,
	},
}
