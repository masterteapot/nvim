local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer close and reopen Neovim..."
	vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
	},
}

-- Install your plugins here
return packer.startup(function(use)
	use "wbthomason/packer.nvim" -- Have packer manage itself
	use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
	use "nvim-lua/popup.nvim"
	use "akinsho/toggleterm.nvim"

	-- Treesitter
	use "nvim-treesitter/nvim-treesitter" -- Also telescope live preview
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})


	-- Text Movements
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	})


	-- UI
	use "folke/which-key.nvim"
	use "folke/todo-comments.nvim"
	use "norcalli/nvim-colorizer.lua"

	-- Colorschemes
	use "xiyaowong/transparent.nvim"
	use({
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({ transparent = vim.g.transparent_enabled })
		end
	})
	use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	use "lunarvim/darkplus.nvim"
	use "lunarvim/onedarker.nvim"
	use "tanvirtin/monokai.nvim"
	use "sainnhe/sonokai"

	-- LSP
	use "williamboman/mason.nvim"        -- simple to use language server installer
	use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
	use "neovim/nvim-lspconfig"          -- enable LSP
	use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
	use "windwp/nvim-ts-autotag"         -- for HTML and PHP tag functionality


	-- cmp plugins
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-buffer" -- buffer completions
	use "hrsh7th/cmp-path" -- path completions
	use "hrsh7th/cmp-cmdline" -- cmdline completions
	use "hrsh7th/cmp-emoji"
	use "hrsh7th/cmp-nvim-lua"
	use "hrsh7th/nvim-cmp"
	use "windwp/nvim-autopairs" -- Autopairs, integrates with cmp / config with cmp file


	-- Debugging
	-- use "mfussenegger/nvim-dap"
	-- use "rcarriga/nvim-dap-ui"
	-- use "theHamsta/nvim-dap-virtual-text"
	-- use 'mfussenegger/nvim-dap-python'
	-- use 'nvim-telescope/telescope-dap.nvim'


	-- snippets
	use "L3MON4D3/LuaSnip"          --snippet engine
	use "saadparwaiz1/cmp_luasnip"  -- snippet completions
	use "rafamadriz/friendly-snippets" -- Preset completions

	-- Comments
	use "terrortylor/nvim-comment"

	-- Lua
	use "folke/lua-dev.nvim"


	-- Telescope
	use "nvim-telescope/telescope.nvim"
	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } } }
	use "masterteapot/harpoon-jdsl" -- make harpoon better
	use "sharkdp/fd"             -- finder for Telescope
	use "BurntSushi/ripgrep"     -- For live_grep
	use { 'nvim-telescope/telescope-fzf-native.nvim',
		run =
		'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
