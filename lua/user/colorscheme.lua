-- local colorscheme = "sonokai"
-- local colorscheme = "aurora"
-- local colorscheme = "lunar"
-- local colorscheme = "system76"
-- local colorscheme = "slate"
-- local colorscheme = "desert"
-- local colorscheme = "ferrum"
-- local colorscheme = "evenings"
local colorscheme = "habamax"
-- local colorscheme = "koehler"
-- local colorscheme = "monokai"
-- local colorscheme = "onenord"
-- local colorscheme = "monokai_pro"
-- local colorscheme = "monokai_soda"
-- local colorscheme = "monokai_ristretto"
-- local colorscheme = "darkblue"
-- local colorscheme = "darkplus"
-- local colorscheme = "tomorrow"
-- local colorscheme = "onedarker"
-- local colorscheme = "onedarkest"
-- local colorscheme = "codemonkey"
-- local colorscheme = "tokyonight"
-- local colorscheme = "tokyonight-moon"
-- local colorscheme = "tokyonight-night"
-- local colorscheme = "tokyonight-storm"
-- local colorscheme = "tokyonight"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  -- vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

require("transparent").setup({
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLineNr', 'EndOfBuffer',
  },
  extra_groups =   {
    -- "NvimTreeNormal", -- NvimTree
	-- "DiagnosticError", -- Diagnostics
	-- "DiagnosticWarn",
	-- "DiagnosticInfo",
	-- "DiagnosticHint",
	-- "DiagnosticOk",
	"DiagnosticVirtualTextWarn",
	"DiagnosticVirtualTextWarn",
	"DiagnosticVirtualTextInfo",
	"DiagnosticVirtualTextHint",
	"DiagnosticVirtualTextOk",
	}, -- Error hovers }, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})

-- -- Usefule commands
-- :TransparentEnable
-- :TransparentDisable
-- :TransparentToggle
