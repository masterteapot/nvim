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
keymap("n", "<C-i>", "<C-i>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<m-h>", "<C-w>h", opts)
keymap("n", "<m-j>", "<C-w>j", opts)
keymap("n", "<m-k>", "<C-w>k", opts)
keymap("n", "<m-l>", "<C-w>l", opts)

-- Tabs --
keymap("n", "<m-t>", ":tabnew %<cr>", opts)
keymap("n", "<S-enter>", ":tabclose<cr>", opts)
keymap("n", "<m-\\>", ":tabonly<cr>", opts)

-- Copy and paste --
keymap("n", "<leader>y", "\"+y", opts)
keymap("n", "<leader>Y", "\"+yg_", opts)
keymap("n", "<leader>y", "\"+y", opts)

-- Paste from clipboard
keymap("n", "<leader>p" ,"\"+p", opts)
keymap("n", "<leader>P", "\"+P", opts)
keymap("n", "<leader>p", "\"+p", opts)
keymap("n", "<leader>P", "\"+P", opts)

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

-- Quick Save
keymap("n", "<C-s>", ":w<cr>", opts)
keymap("v", "<C-s>", ":w<cr>", opts)
keymap("x", "<C-s>", ":w<cr>", opts)
keymap("o", "<C-s>", ":w<cr>", opts)

-- Insert new line without insert mode
keymap("n", "oo", "o<Esc>k", opts)
keymap("n", "OO", "O<Esc>j", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

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

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- NOTE: the fact that tab and ctrl-i are the same is stupid
keymap("n", "Q", "<cmd>Bdelete!<CR>", opts)
keymap("n", "<F1>", ":e ~/.config/nvim/<cr>", opts)
keymap("n", "<F2>", "<cmd>MarkdownPreviewToggle<cr>", opts)
keymap("n", "<F4>", "<cmd>Telescope keymaps<cr>", opts)
keymap("n", "<F5>", "<cmd>Telescope commands<CR>", opts)
-- keymap("n", "<F7>", "<cmd>TSHighlightCapturesUnderCursor<cr>", opts)
-- keymap("n", "<F8>", "<cmd>TSPlaygroundToggle<cr>", opts)
keymap("n", "<F11>", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opts)
keymap("n", "<C-p>", "<cmd>Telescope projects<cr>", opts)

-- Plugin specific keymaps 
keymap("n", "<C-M>", "<cmd>MarkdownPreviewToggle<cr>", opts)

-- Nvim Tree
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

-- alt binds
keymap("n", "<m-v>", "<cmd>vsplit<cr>", opts)

M.show_documentation = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand "<cword>")
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand "<cword>")
  elseif vim.fn.expand "%:t" == "Cargo.toml" then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end
vim.api.nvim_set_keymap("n", "K", ":lua require('user.keymaps').show_documentation()<CR>", opts)

vim.api.nvim_set_keymap(
  "n",
  "<m-f>",
  "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
  opts
)
-- Comment
keymap("n", "<m-/>", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
keymap("x", "<m-/>", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', opts)

vim.api.nvim_set_keymap(
  "n",
  "<tab>",
  "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
  opts
)

vim.api.nvim_set_keymap("n", "<tab>", "<cmd>lua require('telescope.builtin').extensions.harpoon.marks(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal'})<cr>", opts)


vim.api.nvim_set_keymap("n", "<tab>", "<cmd>lua require('telescope').extensions.harpoon.marks(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal', prompt_title='Harpoon'})<cr>", opts)
vim.api.nvim_set_keymap("n", "<s-tab>", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal'})<cr>", opts)
-- vim.api.nvim_set_keymap("n", "<tab>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
vim.api.nvim_set_keymap("n", "<m-g>", "<cmd>Telescope git_branches<cr>", opts)
-- l = { "<cmd>lua require('user.bfs').open()<cr>", "Buffers" },

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]]

keymap("n", "<m-q>", ":call QuickFixToggle()<cr>", opts)

return M
