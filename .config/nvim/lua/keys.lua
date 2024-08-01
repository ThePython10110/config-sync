local wk = require("which-key")
local telescope = require("telescope.builtin")
local transparent = false

wk.add({
	{ "<Leader>f", group = "[f]ile" },
	{ "<Leader>g", group = "[g]oto" },

	{
		mode = "nv",
		-- Telescope
		{ "<Leader>ff", telescope.find_files, desc = "Find [f]ile" },
		{ "<Leader>fg", telescope.live_grep, desc = "Find ([g]rep)" },
		{ "<Leader>gr", telescope.lsp_references, desc = "Goto [r]eferences" },
		{ "<Leader>gI", telescope.lsp_implementations, desc = "Goto [I]mplementations" },
		{ "<Leader>gd", telescope.lsp_definitions, desc = "Goto [d]efinition" },
		{ "<Leader>gD", telescope.lsp_declarations, desc = "Goto [D]eclaration" },

		-- Neotree
		{ "<C-n>", "<CMD>Neotree reveal toggle<CR>", desc = "Toggle [n]eotree" },
		{ "<Leader>n", "<CMD>Neotree<CR>", desc = "Focus [n]eotree" },

		-- LSP
		{ "<Leader>ca", vim.lsp.buf.code_action, desc = "Code [a]ction" },
		{ "<Leader>fr", vim.lsp.buf.format, desc = "Fo[r]mat buffer" },
		{ "<F2>", vim.lsp.buf.rename, desc = "Rename variable" },

		-- Relative line numbers
		{ "<Leader>rl", "<CMD>set rnu!<CR>", desc = "Toggle [r]elative [l]ine numbers" },
    { "<Leader>tb", function()
      transparent = not transparent
      require("onedark").setup{ style = "darker", transparent = transparent, lualine = { transparent = transparent }}
      require("onedark").load()
    end, desc = "Toggle transparent background"},

		-- System clipboard copy/paste (note: not + in Windows I think)
		{ "<Leader>y", '"+y', desc = "System clipboard [y]ank" },
		{ "<Leader>p", '"+p', desc = "System clipboard [p]aste/[p]ut" },

    -- Barbar tabs
    { "<Tab>", "<CMD>BufferNext<CR>", desc = "Next [Tab]"},
    { "<S-Tab>", "<CMD>BufferPrevious<CR>", desc = "Previous [Tab]"},
    { "<leader>x", "<CMD>BufferClose<CR>", desc = "Close buffer"},
	},

	-- Undotree
	{ "<Leader>u", vim.cmd.Undotree, desc = "[u]ndotree" },

  {
    mode = "nvi",
    -- ToggleTerm
    { [[<C-\>]], "<CMD>ToggleTerm<CR>", desc = "ToggleTerm" },

    -- Move to next quickfix
    { "<C-J>", "<CMD>cnext<CR>", desc = "Next quickfix"},
    { "<C-K>", "<CMD>cprev<CR>", desc = "Previous quickfix"},
  },

	{
		mode = "nvit",
		-- Tmux
		{ "<C-h>", "<CMD>TmuxNavigateLeft<CR>" },
		{ "<C-l>", "<CMD>TmuxNavigateRight<CR>" },
		{ "<C-j>", "<CMD>TmuxNavigateDown<CR>" },
		{ "<C-k>", "<CMD>TmuxNavigateUp<CR>" },
	},

	-- Remove highlighting on <escape>
	{ "<Esc>", "<CMD>nohlsearch<CR>", mode = "n", desc = "Hide highlighting" },
})
