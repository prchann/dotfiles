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
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }

  {
    "APZelos/blamer.nvim",
		event = "VeryLazy",
    keys = {
      { "yob", "<cmd>BlamerToggle<cr>", desc = "Toggle Git Blamer"},
    },
    init = function()
      vim.g.blamer_delay=700
      vim.g.blamer_show_in_visual_modes=0
      vim.g.blamer_show_in_insert_modes=0
      vim.g.blamer_relative_time=1
    end
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
		-- lazy = false;
		event = "VeryLazy",
		keys = {
			{ "<C-t>", "<cmd>TagbarToggle<cr>", desc = "Toggle Tag Bar" },
		},
		init = function()
			vim.g.startuptime_tries = 10
			vim.g.tagbar_autofocus = 0
			vim.g.tagbar_autoclose = 0
			-- vim.g.tagbar_indent=2
			-- vim.g.tagbar_show_linenumbers=-1
			vim.g.tagbar_show_tag_linenumbers = 1
			vim.g.tagbar_show_data_type = 1
			-- vim.g.tagbar_type_go = {
			--   ctagstype = "go",
			--   kinds = {
			--     "p:package",
			--     "i:imports:1",
			--     "c:constants",
			--     "v:variables",
			--     "t:types",
			--     "n:interfaces",
			--     "w:fields",
			--     "e:embedded",
			--     "m:methods",
			--     "r:constructor",
			--     "f:functions"
			--   },
			--   sro = ".",
			--   kind2scope = {
			--     t = "ctype",
			--     n = "ntype"
			--   },
			--   scope2kind = {
			--     ctype = "t",
			--     ntype = "n"
			--   },
			--   ctagsbin = "gotags",
			--   ctagsargs = "-sort -silent"
			-- }
		end,
	},
}

return plugins
