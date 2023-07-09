-- Global Options
require "user.options"
require "user.keymaps"
require "user.globals"
require "user.autocommands"
require "user.colorscheme"
require "user.colorizer"

-- Plugins
require "user.plugins"
require "user.plugins.nvim-surround"
require "user.plugins.nvim-tree"
require "user.plugins.telescope"
require "user.plugins.harpoon"
require "user.plugins.comment"

-- LSP type things
require "user.lsp"
require "user.lsp.cmp"
require "user.lsp.dap"
require "user.lsp.null-ls"
require "user.lsp.treesitter"
