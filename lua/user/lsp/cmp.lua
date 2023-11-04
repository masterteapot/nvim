require("luasnip.loaders.from_vscode").lazy_load()

local status, cmp = pcall(require, "cmp")
if (not status) then return end

local luasnip = require("luasnip")
local lsp = require("lspconfig")

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local c = vim.lsp.protocol.make_client_capabilities()
c.textDocument.completion.completionItem.snippetSupport = true
c.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    },
}
local capabilities = require("cmp_nvim_lsp").default_capabilities(c)


cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        },
        documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
	sources = cmp.config.sources(
	{
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }, -- For luasnip users.
		{ name = 'path' },
		{ name = 'buffer' },
		{ name = 'nvim_lua' },
	},
	{
		{ name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt" , "vim" },
	disable_in_macro = false,  -- disable when recording or executing a macro
	disable_in_visualblock = false,  -- disable when insert after visual block mode
	disable_in_replace_mode = true,
	ignored_next_char = [=[[%w%%%'%[%"%.]]=],
	enable_moveright = true,
	enable_afterquote = true,  -- add bracket pairs after quote
	enable_check_bracket_line = true,  --- check bracket in same line
	enable_bracket_in_quote = true,  --
	enable_abbr = false,  -- trigger abbreviation
	break_undo = true,  -- switch for basic rule break undo sequence
	check_ts = false,
	map_cr = true,
	map_bs = true,  -- map the <BS> key
	map_c_h = false,  -- Map the <C-h> key to delete a pair
	map_c_w = false,  -- map <c-w> to delete a pair if possible
})

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
lsp['pyright'].setup {
  capabilities = capabilities
}
lsp['intelephense'].setup {
  capabilities = capabilities
}
lsp['eslint'].setup {
  capabilities = capabilities
}
lsp['gopls'].setup {
  capabilities = capabilities
}
