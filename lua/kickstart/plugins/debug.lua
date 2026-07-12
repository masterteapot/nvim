return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    keys = {
      -- Basic debugging keymaps, feel free to change to your liking!
      {
        '<F5>',
        function()
          local dap = require 'dap'
          -- If a session is active, just continue immediately
          if dap.session() ~= nil then
            dap.continue()
            return
          end
          -- Otherwise, compile before starting the initial session
          if vim.bo.filetype == 'odin' then
            vim.notify('Compiling Odin project with -debug...', vim.log.levels.INFO)
            local build_cmd = 'odin build . -debug -out:cats_of_olympus'
            local output = vim.fn.system(build_cmd)

            if vim.v.shell_error ~= 0 then
              vim.notify('Odin compilation failed:\n' .. output, vim.log.levels.ERROR)
              return -- Halt execution and do not start the debugger
            end
            vim.notify('Odin build succeeded! Launching debugger...', vim.log.levels.INFO)
          end

          dap.continue()
        end,
        desc = 'Debug: Build & Start/Continue',
      },
      {
        '<F1>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<F2>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<F3>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<leader>b',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>B',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: See last session result.',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'delve',
          'codelldb',
        },
      }

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- ==========================================
      -- Odin CodeLLDB & DAP Configuration
      -- ==========================================
      dap.adapters.codelldb = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        name = 'codelldb',
      }

      -- Define standard configurations for Odin projects
      dap.configurations.odin = {
        {
          name = 'Odin: Launch Game',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.getcwd() .. '/cats_of_olympus'
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = 'Odin: Launch Executable (No Build)',
          type = 'codelldb',
          request = 'launch',
          program = function()
            local default_path = vim.fn.getcwd() .. '/cats_of_olympus'
            return vim.fn.input('Path to executable: ', default_path, 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = 'Odin: Attach to Process',
          type = 'codelldb',
          request = 'attach',
          pid = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }
    end,
  },

  -- ==========================================
  -- 2. Virtual Text Plugin (Explicitly Sequenced)
  -- ==========================================
  {
    'theHamsta/nvim-dap-virtual-text',
    event = 'VeryLazy',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = false, -- Display values on lines where they are referenced too!
      all_references = true, -- Show virtual text for every reference of the variable
      virt_text_pos = 'inline', -- Position variable values at the end of lines to avoid overlap
    },
  },
}
