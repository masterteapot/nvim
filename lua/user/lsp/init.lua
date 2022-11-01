-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=false }
vim.keymap.set('n', '<space>lh', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>lq', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=false, buffer=bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>ld', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>lc', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>lf', vim.lsp.buf.formatting_sync, bufopts) -- TODO This does not seem to work
end
local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['intelephense'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['sumneko_lua'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

local util = require 'lspconfig.util'

local bin_name = 'intelephense'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json', '.git', 'wp-config.php')(pattern)

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://intelephense.com/
`intelephense` can be installed via `npm`:
```sh
npm install -g intelephense
```
]],
    default_config = {
      root_dir = [[root_pattern("composer.json", ".git")]],
      init_options = [[{
        storagePath = Optional absolute path to storage dir. Defaults to os.tmpdir().
        globalStoragePath = Optional absolute path to a global storage dir. Defaults to os.homedir().
        licenceKey = Optional licence key or absolute path to a text file containing the licence key.
        clearCache = Optional flag to clear server state. State can also be cleared by deleting {storagePath}/intelephense
        -- See https://github.com/bmewburn/intelephense-docs/blob/master/installation.md#initialisation-options
      }]],
      settings = [[{
        intelephense = {
          files = {
            maxSize = 1000000;
          };
        };
        -- See https://github.com/bmewburn/intelephense-docs
      }]],
    },
  },
}
