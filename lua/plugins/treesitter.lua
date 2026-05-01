local languages = {
	"angular",
	"css",
	"dockerfile",
	"html",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"query",
	"scss",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

local function enable_treesitter(args)
	if vim.bo[args.buf].buftype ~= "" then
		return
	end

	local filetype = vim.bo[args.buf].filetype
	if filetype == "" then
		return
	end

	local lang = vim.treesitter.language.get_lang(filetype)
	if not lang then
		return
	end

	local ok, loaded = pcall(vim.treesitter.language.add, lang)
	if not ok or not loaded then
		return
	end

	pcall(vim.treesitter.start, args.buf, lang)
end

local function setup_compat()
	local parsers = require("nvim-treesitter.parsers")
	parsers.ft_to_lang = parsers.ft_to_lang or function(filetype)
		return vim.treesitter.language.get_lang(filetype) or filetype
	end
	parsers.get_parser = parsers.get_parser or function(bufnr, lang)
		return vim.treesitter.get_parser(bufnr, lang)
	end

	local configs = package.loaded["nvim-treesitter.configs"] or {}
	configs.is_enabled = configs.is_enabled or function(module, lang)
		if module ~= "highlight" then
			return false
		end

		local ok, loaded = pcall(vim.treesitter.language.add, lang)
		return ok and loaded == true
	end
	configs.get_module = configs.get_module or function(module)
		if module == "highlight" then
			return { additional_vim_regex_highlighting = false }
		end

		return {}
	end
	package.loaded["nvim-treesitter.configs"] = configs
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = function()
		if vim.fn.executable("tree-sitter") == 0 then
			vim.notify("nvim-treesitter: skipping parser install/update because `tree-sitter` is not installed", vim.log.levels.WARN)
			return
		end

		local treesitter = require("nvim-treesitter")
		local installed = treesitter.get_installed()
		local installed_set = {}
		for _, lang in ipairs(installed) do
			installed_set[lang] = true
		end

		local missing = vim.tbl_filter(function(lang)
			return not installed_set[lang]
		end, languages)
		if #missing > 0 then
			treesitter.install(missing, { summary = true }):wait(300000)
		end

		treesitter.update(languages, { summary = true }):wait(300000)
	end,
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		setup_compat()

		local group = vim.api.nvim_create_augroup("nvim_treesitter_start", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "*",
			callback = enable_treesitter,
		})

		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				enable_treesitter({ buf = buf })
			end
		end
	end,
}
