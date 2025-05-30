vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false

--  See `:help 'clipboard'`
-- vim.schedule(function()
--   vim.o.clipboard = 'unnamedplus'
-- end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- adjusting default tabwidth for certain file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'javascript', 'typescript', 'html', 'css', 'json' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank {
      timeout = 50,
    }
  end,
})

-- I don't like the default colors
vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, {
  pattern = '*',
  desc = 'Changing statusline highlighting',
  callback = function()
    local function to_hex(color)
      if not color then
        return '#333333'
      end
      return string.format('#%06x', color)
    end
    -- local visual = vim.api.nvim_get_hl(0, { name = 'Visual' })
    local cl = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
    -- local var = vim.api.nvim_get_hl(0, { name = '@variable' })
    local func = vim.api.nvim_get_hl(0, { name = '@function' })
    -- local tp = vim.api.nvim_get_hl(0, { name = '@type' })
    local kw = vim.api.nvim_get_hl(0, { name = '@keyword' })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', {
      bg = to_hex(func.fg),
      fg = '#ffffff',
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', {
      bg = to_hex(func.fg),
      fg = '#ffffff',
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', {
      bg = to_hex(func.fg),
      fg = '#ffffff',
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', {
      bg = to_hex(func.fg),
      fg = '#ffffff',
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', {
      bg = to_hex(func.fg),
      fg = '#ffffff',
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', {
      bg = to_hex(func.bg),
      fg = '#ffffff',
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', {
      bg = to_hex(cl.bg),
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', {
      bg = to_hex(kw.fg),
      fg = '#111111',
    })
    vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', {
      bg = to_hex(cl.bg),
    })
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  -- 'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      preset = 'modern',
      delay = 0,

      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        keys = {},
      },
    },

    -- Document existing key chains
    spec = {
      { '<leader>f', group = '[F]ind' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[F]ind [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[F]ind [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>flr', require('telescope.builtin').lsp_references, '[F]ind [L]sp [R]eferences')
          map('<leader>fli', require('telescope.builtin').lsp_implementations, '[F]ind [L]sp [I]mplementation')
          map('<leader>fld', require('telescope.builtin').lsp_definitions, '[F]ind [L]sp [D]efinition')
          map('<leader>flD', vim.lsp.buf.declaration, '[F]ind [L]sp [D]eclaration')
          map('<leader>fds', require('telescope.builtin').lsp_document_symbols, '[F]ind [D]ocument [S]ymbols')
          map('<leader>fws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[F]ind [W]orkspace [S]ymbols')
          map('<leader>ftd', require('telescope.builtin').lsp_type_definitions, '[F]ind [T]ype [D]efinition')
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
          -- The following code creates a keymap to toggle inlay hints in your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        gopls = {},
        pyright = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }
      local ensure_installed = {
        'gopls',
        'pyright',
        'lua_ls',
      }

      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        automatic_enable = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      vim.lsp.config('ocamllsp', {
        cmd = { 'ocamllsp' },
        settings = {
          codelens = { enable = true },
          inlayHints = { enable = true },
          syntaxDocumentation = { enable = true },
        },
        server_capabilities = { semanticTokensProvider = false },
        filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason', 'dune', '.ocamlformat' },
        capabilities = capabilities,
      })
      vim.lsp.enable 'ocamllsp'
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[L]SP [F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        ocaml = { 'ocamlformat' },
      },
      formatters = {
        ocamlformat = {
          prepend_args = {
            '--if-then-else',
            'vertical',
            '--break-cases',
            'fit-or-vertical',
            '--type-decl',
            'sparse',
          },
        },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = { border = 'single', draw = { columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', gap = 1, 'kind' } } } },
        documentation = { window = { border = 'single' }, auto_show = true, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning', sorts = {'score', 'kind'} },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true, window = { border = 'single' } },
    },
  },
  'folke/tokyonight.nvim',
  'savq/melange-nvim',
  'bluz71/vim-moonfly-colors',
  'jacoborus/tender.vim',
  'datsfilipe/vesper.nvim',
  'lunarvim/onedarker.nvim',
  'pauchiner/pastelnight.nvim',
  'thebigcicca/gruverboxer-material.nvim',
  {
    'vague2k/vague.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }
      vim.cmd.colorscheme 'vague'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, filename, fileinfo = MiniStatusline.section_mode {}, MiniStatusline.section_filename {}, MiniStatusline.section_fileinfo {}
            return MiniStatusline.combine_groups {
              { hl = 'MiniStatuslineModeNormal', strings = { mode } },
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              -- devinfo section intentionally omitted
            }
          end,
        },
      }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'ocaml', 'python' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(lang, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 10000
        end,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby', 'ocaml' } },
      incremental_selection = {
        enable = true,
        disable = function(lang, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 10000
        end,
        keymaps = {
          init_selection = 'gh',
          node_decremental = 'gj',
          node_incremental = 'gk',
          scope_incremental = 'gl',
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  { -- quick jumping like a fisherman
    'https://github.com/ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      columns = {
        -- 'icon',
        -- 'permissions',
        -- 'size',
        -- "mtime",
      },
      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },
      cleanup_delay_ms = 2000,
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        natural_order = 'fast',
        case_insensitive = false,
        sort = {
          { 'type', 'asc' },
          { 'name', 'asc' },
        },
      },
      float = {
        -- Padding around the floating window
        padding = 2,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0,
        max_height = 0,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = 'auto',
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
      -- Configuration for the file preview window
      preview_win = {
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
        -- How to open the preview window "load"|"scratch"|"fast_scratch"
        preview_method = 'fast_scratch',
        -- A function that returns true to disable preview on a file e.g. to avoid lag
        disable_preview = function(filename)
          return false
        end,
        -- Window-local options to use for preview window buffers
        win_options = {},
      },
      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        minimized_border = 'none',
        win_options = {
          winblend = 0,
        },
      },
    },
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    lazy = false,
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.lsp',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

local keymap = vim.api.nvim_set_keymap
local funmap = function(mode, l, r, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set(mode, l, r, opts)
end

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local add_opts = function(opts)
  opts.noremap = true
  opts.silent = true
  return opts
end

-- Oil
keymap('n', '<leader>e', '<cmd>Oil<cr>', opts)

-- Which key
keymap('n', '<C-Space>', '<cmd>WhichKey \\<leader><cr>', opts)

-- Increment and decrease a number
keymap('n', '+', '<C-a>', opts)
keymap('n', '-', '<C-x>', opts)

-- remove highlights on escape
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Copy and paste --
keymap('n', '<leader>y', '"+y', add_opts { desc = '[Y]ank into global register' })
keymap('n', '<leader>Y', '"+yg_', add_opts { desc = '[Y]ank into global register' })
keymap('v', '<leader>y', '"+y', add_opts { desc = '[Y]ank into global register' })
keymap('v', '<leader>Y', '"+yg_', add_opts { desc = '[Y]ank into global register' })
keymap('x', '<leader>y', '"+y', add_opts { desc = '[Y]ank into global register' })
keymap('x', '<leader>Y', '"+yg_', add_opts { desc = '[Y]ank into global register' })
keymap('o', '<leader>y', '"+y', add_opts { desc = '[Y]ank into global register' })
keymap('o', '<leader>Y', '"+yg_', add_opts { desc = '[Y]ank into global register' })

-- Paste from clipboard
keymap('n', '<leader>p', '"+p', add_opts { desc = '[P]aste into global register' })
keymap('n', '<leader>P', '"+P', add_opts { desc = '[P]aste into global register' })
keymap('v', '<leader>p', '"+p', add_opts { desc = '[P]aste into global register' })
keymap('v', '<leader>P', '"+P', add_opts { desc = '[P]aste into global register' })
keymap('x', '<leader>p', '"+p', add_opts { desc = '[P]aste into global register' })
keymap('x', '<leader>P', '"+P', add_opts { desc = '[P]aste into global register' })
keymap('o', '<leader>p', '"+p', add_opts { desc = '[P]aste into global register' })
keymap('o', '<leader>P', '"+P', add_opts { desc = '[P]aste into global register' })

-- Resize with arrows
keymap('n', '<C-Up>', ':resize -2<CR>', opts)
keymap('n', '<C-Down>', ':resize +2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- I hate typing these
keymap('n', 'H', '^', opts)
keymap('n', 'L', '$', opts)
keymap('v', 'H', '^', opts)
keymap('v', 'L', '$', opts)
keymap('x', 'H', '^', opts)
keymap('x', 'L', '$', opts)
keymap('o', 'H', '^', opts)
keymap('o', 'L', '$', opts)

-- Text motions
keymap('n', 'E', 'ge', opts)

-- Vertical navigation
keymap('n', '<C-d>', '<C-d>zz', opts)
keymap('n', '<C-u>', '<C-u>zz', opts)

-- Visual --
-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', 'p', '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap('x', 'J', ":move '>+1<CR>gv-gv", opts)
keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)
keymap('x', '<A-j>', ":move '>+1<CR>gv-gv", opts)
keymap('x', '<A-k>', ":move '<-2<CR>gv-gv", opts)

-- Transparency
keymap('n', '<leader>tt', '<cmd>TransparentToggle<cr>', term_opts)

-- Better terminal navigation
keymap('t', '<A-h>', '<C-\\><C-N><C-w>h', term_opts)
keymap('t', '<A-j>', '<C-\\><C-N><C-w>j', term_opts)
keymap('t', '<A-k>', '<C-\\><C-N><C-w>k', term_opts)
keymap('t', '<A-l>', '<C-\\><C-N><C-w>l', term_opts)
keymap('t', '<Esc>', '<C-\\><C-n>', term_opts)

-- LSP Keymaps
funmap('n', 'gd', vim.lsp.buf.definition, add_opts { desc = '[G]o to [D]efinition' })
funmap('n', 'gi', vim.lsp.buf.implementation, add_opts { desc = '[G]o to [I]mplementation' })
funmap('n', '<leader>lbi', vim.lsp.buf.implementation, add_opts { desc = '[L]sp [B]uffer [I]mplementation' })
funmap('n', '<leader>lbr', vim.lsp.buf.references, add_opts { desc = '[L]sp [B]uffer [R]eferences' })
funmap('n', '<leader>lbd', vim.lsp.buf.definition, add_opts { desc = '[L]sp [B]uffer [D]efinition' })
funmap('n', '<leader>lbt', vim.lsp.buf.type_definition, add_opts { desc = '[L]sp [B]uffer [T]ype definition' })
funmap('n', '<leader>lbs', function()
  vim.lsp.buf.signature_help { border = 'rounded' }
end, add_opts { desc = '[L]sp [B]uffer [S]ignature help' })
funmap('n', '<leader>ld', function()
  vim.diagnostic.open_float { border = 'rounded' }
end, add_opts { desc = '[L]sp [D]iagnostics' })
funmap('n', '<leader>lr', vim.lsp.buf.rename, add_opts { desc = '[L]sp [R]ename' })
funmap('n', '<leader>lc', vim.lsp.buf.code_action, add_opts { desc = '[L]sp [C]ode action' })
funmap('n', '<leader>lf', vim.lsp.buf.format, add_opts { desc = '[L]sp [F]ormat' })
funmap('n', 'K', function()
  vim.lsp.buf.hover { border = 'single' }
end, add_opts { desc = '[K] for hover' })
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Language specifc keymaps: Ocaml
keymap('', '<leader>oi', '<cmd>:s/\\(.\\)$/\\1 in/<CR><ESC>', add_opts { desc = '[O]caml [I]nsert in' })
keymap('v', '<leader>o;', '<cmd>:s/\\(.\\)$/\\1;/<CR><ESC>', add_opts { desc = '[O]caml [;]nsert ;' })

keymap('n', 'Q', '<cmd>bdelete!<CR>', opts)
keymap('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opts)

-- alt binds
keymap('n', '<m-v>', '<cmd>vsplit<cr>', opts)

-- Harpoon Keymaps
require('telescope').load_extension 'harpoon'
local harpoon = require 'harpoon'
funmap('n', '<leader>ha', function()
  harpoon:list():add()
end, add_opts { desc = '[H]arpoon [A]dd' })
funmap('n', '<leader>ht', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, add_opts { desc = '[H]arpoon [T]oggle' })
funmap('n', '<leader>hn', function()
  harpoon:list():next()
end, add_opts { desc = '[H]arpoon [N]ext' })
funmap('n', '<leader>hb', function()
  harpoon:list():prev()
end, add_opts { desc = '[H]arpoon [P]revious' })
funmap('n', '<leader>1', function()
  harpoon:list():select(1)
end, add_opts { desc = '[H]arpoon select [1]' })
funmap('n', '<leader>2', function()
  harpoon:list():select(2)
end, add_opts { desc = '[H]arpoon select [2]' })
funmap('n', '<leader>3', function()
  harpoon:list():select(3)
end, add_opts { desc = '[H]arpoon select [3]' })
funmap('n', '<leader>4', function()
  harpoon:list():select(4)
end, add_opts { desc = '[H]arpoon select [4]' })
funmap('n', '<leader>5', function()
  harpoon:list():select(5)
end, add_opts { desc = '[H]arpoon select [5]' })
funmap('n', '<leader>6', function()
  harpoon:list():select(6)
end, add_opts { desc = '[H]arpoon select [6]' })
funmap('n', '<leader>7', function()
  harpoon:list():select(7)
end, add_opts { desc = '[H]arpoon select [7]' })
funmap('n', '<leader>8', function()
  harpoon:list():select(8)
end, add_opts { desc = '[H]arpoon select [8]' })
funmap('n', '<leader>9', function()
  harpoon:list():select(9)
end, add_opts { desc = '[H]arpoon select [9]' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
