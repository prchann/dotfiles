---@type MappingsTable
local M = {}

M.general = {
	n = {
		["]g"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "go to next diagnostic" },
		["[g"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "go to previous diagnostic" },

		-- [";"] = { ":", "enter command mode", opts = { nowait = true } },
		-- ["<leader>gg"] = { ":G", "" },
		-- ["<Leader>gd"] = { ":G difftool" },
		-- ["<Leader>\\"] = { ":GoDecls" },
		-- ["<Leader>/"] = { ":BLines" },
		-- ["<Leader><Leader>/"] = { ":Ag" },
		-- ["<Leader>bb"] = { ":Buffers" },
		-- ["<Leader>bd"] = { ":bd" },
	},
}

M.gitsigns = {
	n = {
		["<leader>gb"] = {
			function()
				package.loaded.gitsigns.toggle_current_line_blame()
			end,
			"Blame line",
		},
		["<leader>sh"] = {
			function()
				package.loaded.gitsigns.stage_hunk()
			end,
			"Blame line",
		},
	},
}

return M
