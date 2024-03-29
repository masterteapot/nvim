M = {}
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("n", "<C-Space>", "<cmd>WhichKey \\<leader><cr>", opts)
-- keymap("n", "<C-i>", "<C-i>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Netrw Explorer
keymap("n", "<leader>w", ":bd<cr>", opts)

-- Normal --
-- Better window navigation
keymap("n", "<m-h>", "<C-w>h", opts)
keymap("n", "<m-j>", "<C-w>j", opts)
keymap("n", "<m-k>", "<C-w>k", opts)
keymap("n", "<m-l>", "<C-w>l", opts)

-- Tabs --
keymap("n", "<m-t>", ":tabnew %<cr>", opts)
keymap("n", "<m-n>", ":tabnext<cr>", opts)
keymap("n", "<m-p>", ":tabprevious<cr>", opts)
keymap("n", "<m-Q>", ":tabclose<cr>", opts)
keymap("n", "<m-enter>", ":tabonly<cr>", opts)

-- Increment and decrease a number --
keymap("n", "+", "<C-a>", opts)
keymap("n", "-", "<C-x>", opts)

-- Copy and paste --
keymap("n", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+yg_', opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("v", "<leader>Y", '"+yg_', opts)
keymap("x", "<leader>y", '"+y', opts)
keymap("x", "<leader>Y", '"+yg_', opts)
keymap("o", "<leader>y", '"+y', opts)
keymap("o", "<leader>Y", '"+yg_', opts)

-- Paste from clipboard
keymap("n", "<leader>p", '"+p', opts)
keymap("n", "<leader>P", '"+P', opts)
keymap("v", "<leader>p", '"+p', opts)
keymap("v", "<leader>P", '"+P', opts)
keymap("x", "<leader>p", '"+p', opts)
keymap("x", "<leader>P", '"+P', opts)
keymap("o", "<leader>p", '"+p', opts)
keymap("o", "<leader>P", '"+P', opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- I hate typing these
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)
keymap("v", "H", "^", opts)
keymap("v", "L", "$", opts)
keymap("x", "H", "^", opts)
keymap("x", "L", "$", opts)
keymap("o", "H", "^", opts)
keymap("o", "L", "$", opts)


-- Text motions
keymap("n", "E", "ge", opts)


-- Vertical navigation
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Quick Save
keymap("n", "<C-s>", ":w<cr>", opts)
keymap("v", "<C-s>", ":w<cr>", opts)
keymap("x", "<C-s>", ":w<cr>", opts)
keymap("o", "<C-s>", ":w<cr>", opts)

-- Insert new line without insert mode
keymap("n", "oo", "o<Esc>k", opts)
keymap("n", "OO", "O<Esc>j", opts)

-- Insert --

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)


-- Transparency
keymap("n", "<leader>tt", "<cmd>TransparentToggle<cr>", term_opts)

-- Better terminal navigation
keymap("t", "<A-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<A-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<A-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<A-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("t", "<Esc>", "<C-\\><C-n>", term_opts)

-- Quick Sourcing
keymap("n", "<leader>s", ":source %<cr>", opts)
keymap("n", "<leader>S", ":luafile %<cr>", opts)

-- Telescope Keymaps
keymap(
	"n",
	"<leader>fb",
	"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{initial_mode='normal'})<cr>",
	opts
)
-- keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').git_branches<cr>", opts)
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", opts)
keymap("n", "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending<cr>", opts)
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(" ..
	"{hidden=false, no_ignore=false })" ..
	"<cr>", opts)
keymap("n", "<leader>fF", "<cmd>lua require'telescope.builtin'.find_files(" ..
	"{hidden=true, no_ignore=false })" ..
	"<cr>", opts)
keymap("n", "<leader>FF", "<cmd>lua require'telescope.builtin'.find_files(" ..
	"{hidden=true, no_ignore=true })" ..
	"<cr>", opts)
keymap(
	"n",
	"<leader>fg",
	"<cmd>lua require('telescope.builtin').live_grep({prompt_title = 'find string in open buffers...', grep_open_files = true})<cr>",
	opts
)
keymap(
	"n",
	"<leader>FG",
	"<cmd>lua require('telescope.builtin').live_grep({prompt_title = 'find string in all buffers...'})<cr>",
	opts
)

-- LSP Keymaps
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
keymap("n", "GD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
keymap("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
keymap("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

-- Language specifc keymaps: Ocaml
keymap("v", "<leader>oi", "<cmd>:s/\\(.\\)$/\\1 in/<CR><ESC>", opts)
keymap("v", "<leader>o;", "<cmd>:s/\\(.\\)$/\\1;/<CR><ESC>", opts)

-- Clear search highlight
keymap("n", "<leader>/", "<cmd>noh<CR>", opts)

-- Python keymaps
keymap("n", "<leader>yr", "<cmd>exe 'w' | exe '!python %'<CR>", opts)

-- NOTE: the fact that tab and ctrl-i are the same is stupid
keymap("n", "Q", "<cmd>bdelete!<CR>", opts)
keymap("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opts)


-- Explorer
keymap("n", "<leader>e", ":Ex<cr>", opts)
keymap("n", "<leader>E", ":Sex<cr>", opts)

-- alt binds
keymap("n", "<m-v>", "<cmd>vsplit<cr>", opts)

M.show_documentation = function()
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, filetype) then
		vim.cmd("h " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, filetype) then
		vim.cmd("Man " .. vim.fn.expand("<cword>"))
	elseif vim.fn.expand("%:t") == "Cargo.toml" then
		require("crates").show_popup()
	else
		vim.lsp.buf.hover()
	end
end
vim.api.nvim_set_keymap("n", "K", ":lua require('user.keymaps').show_documentation()<CR>", opts)

vim.cmd([[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]])

keymap("n", "<m-q>", ":call QuickFixToggle()<cr>", opts)

return M
