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

-- more keybinds!

return M
