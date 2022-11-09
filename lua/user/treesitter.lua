require 'nvim-treesitter.configs'.setup {
	autotag = {
		enable = true,
		filetypes = { "html", "xml", "php" },
	},
	  highlight = {
		-- `false` will disable the whole extension
		enable = true,
	}
}
