local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
		keys = {
			{ "<Leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Find current file in NvimTree" },
		},
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"tpope/vim-unimpaired",
		lazy = false,
	},

	{
		"tpope/vim-surround",
		lazy = false,
	},

	{
		"tpope/vim-repeat",
		lazy = false,
	},

	{
		"majutsushi/tagbar",
		event = "VeryLazy",
		keys = {
			{ "<C-t>", "<cmd>TagbarToggle<CR>", desc = "Toggle tag bar" },
		},
		init = function()
			vim.g.startuptime_tries = 10
			vim.g.tagbar_autofocus = 0
			vim.g.tagbar_autoclose = 0
			-- vim.g.tagbar_indent=2
			-- vim.g.tagbar_show_linenumbers=-1
			vim.g.tagbar_show_tag_linenumbers = 1
			vim.g.tagbar_show_data_type = 1
			vim.g.tagbar_type_go = {
				ctagstype = "go",
				kinds = {
					"p:package",
					"i:imports:1",
					"c:constants",
					"v:variables",
					"t:types",
					"n:interfaces",
					"w:fields",
					"e:embedded",
					"m:methods",
					"r:constructor",
					"f:functions",
				},
				sro = ".",
				kind2scope = {
					t = "ctype",
					n = "ntype",
				},
				scope2kind = {
					ctype = "t",
					ntype = "n",
				},
				ctagsbin = "gotags",
				ctagsargs = "-sort -silent",
			}
		end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			require("todo-comments").setup()
		end,
	},
}

return plugins
