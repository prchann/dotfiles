local M = {}

M.treesitter = {
  ensure_installed = {
    "c",
    "css",
    "go",
    "gomod",
    "gosum",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "tsx",
    "typescript",
    "vim",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- shell
    "bash-language-server",

    -- python
    "pyright",

    -- go
    "gopls",
    "goimports",
    "golangci-lint",

    -- sql
    "sqlls",
    "sql-formatter",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
    ignore = false,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
	update_focused_file = {
		enable = false,
	},
}

return M
