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
    }
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

  -- {
  --   "APZelos/blamer.nvim",
		-- event = "VeryLazy",
  --   keys = {
  --     { "yob", "<cmd>BlamerToggle<CR>", desc = "Toggle Git blamer"},
  --   },
  --   init = function()
  --     vim.g.blamer_delay=700
  --     vim.g.blamer_show_in_visual_modes=0
  --     vim.g.blamer_show_in_insert_modes=0
  --     vim.g.blamer_relative_time=1
  --   end
  -- },

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

  -- {
  --   "simrat39/symbols-outline.nvim",
  --   lazy = false,
  --   config = function()
  --     require("symbols-outline").setup()
  --   end,
  -- },

	{
		"majutsushi/tagbar",
		-- lazy = false;
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
			    "f:functions"
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

	{
    "yamatsum/nvim-cursorline",
    lazy = false,
		config = function()
			require("nvim-cursorline").setup({
				cursorline = {
					enable = false,
					timeout = 1000,
					number = false,
				},
        cursorword = {
          enable = true,
          min_length = 3,
          hl = {
            underline = true
          },
        }
      })
		end,
	},

  {
    "crispgm/nvim-go",
    lazy = false,
    config = function()
      require("go").setup({
        -- notify: use nvim-notify
        notify = false,
        -- auto commands
        auto_format = true,
        auto_lint = true,
        -- linters: revive, errcheck, staticcheck, golangci-lint
        linter = 'revive',
        -- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
        linter_flags = {},
        -- lint_prompt_style: qf (quickfix), vt (virtual text)
        lint_prompt_style = 'qf',
        -- formatter: goimports, gofmt, gofumpt, lsp
        formatter = 'goimports',
        -- maintain cursor position after formatting loaded buffer
        maintain_cursor_pos = false,
        -- test flags: -count=1 will disable cache
        test_flags = {'-v'},
        test_timeout = '30s',
        test_env = {},
        -- show test result with popup window
        test_popup = true,
        test_popup_auto_leave = false,
        test_popup_width = 80,
        test_popup_height = 10,
        -- test open
        test_open_cmd = 'edit',
        -- struct tags
        tags_name = 'json',
        tags_options = {'json=omitempty'},
        tags_transform = 'snakecase',
        tags_flags = {'-skip-unexported'},
        -- quick type
        quick_type_flags = {'--just-types'},
      })
    end,
  },

}

return plugins
