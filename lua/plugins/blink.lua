return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"xzbdmw/colorful-menu.nvim",
			opts = {
				ls = {
					lua_ls = {
						arguments_hl = "@comment",
					},
					ts_ls = {
						extra_info_hl = "@comment",
					},
					fallback = true,
					fallback_extra_info_hl = "@comment",
				},
				fallback_highlight = "@variable",
				max_width = 60,
			},
			config = function(_, opts)
				require("colorful-menu").setup(opts)
			end,
		},
	},

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<C-k>"] = false,
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
			},
			menu = {
				draw = {
					columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
					components = {
						label = {
							width = { fill = true, max = 60 },
							text = function(ctx)
								local highlights = require("colorful-menu").blink_highlights(ctx)
								if highlights then
									return highlights.label
								end

								return ctx.label .. ctx.label_detail
							end,
							highlight = function(ctx)
								local highlights = {}
								local highlights_info = require("colorful-menu").blink_highlights(ctx)
								if highlights_info then
									highlights = vim.deepcopy(highlights_info.highlights)
								end

								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end

								return highlights
							end,
						},
						source_name = {
							width = { max = 6 },
							text = function(ctx)
								return ctx.source_name or ctx.source_id
							end,
							highlight = "BlinkCmpSource",
						},
					},
				},
			},
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "snippets", "path", "buffer" },
			providers = {
				path = {
					name = "Path",
				},
				snippets = {
					name = "Snip",
				},
				buffer = {
					name = "Buf",
					min_keyword_length = 3,
				},
			},
		},

		signature = {
			enabled = true,
			trigger = {
				show_on_accept = true,
			},
			window = {
				show_documentation = false,
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
