require("telescope").load_extension('harpoon')

-- -- Useful commands
-- :lua require("harpoon.mark").add_file()
-- :lua require("harpoon.ui").toggle_quick_menu()
-- :lua require("harpoon.ui").nav_file(3)                  -- navigates to file 3
-- :lua require("harpoon.ui").nav_next()                   -- navigates to next mark
-- :lua require("harpoon.ui").nav_prev()                   -- navigates to previous mark
-- lua require("harpoon.term").gotoTerminal(1)             -- navigates to term 1
-- lua require("harpoon.term").sendCommand(1, "ls -La")    -- sends ls -La to tmux window 1
-- lua require('harpoon.cmd-ui').toggle_quick_menu()       -- shows the commands menu
-- lua require("harpoon.term").sendCommand(1, 1)           -- sends command 1 to term 1

require("harpoon").setup({
  global_settings = {
    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    save_on_toggle = false,

    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,

    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = false,

    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,

    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },

    -- set marks specific to each git branch inside git repository
    mark_branch = false,
  }
})
