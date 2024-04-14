require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "cssls", "marksman", "gopls", "html", "intelephense", "pyright", "jsonls", "eslint" },
}
local status, lsp = pcall(require, "lspconfig")
if (not status) then return end

local util = require("lspconfig.util")
local path = util.path
local opts = { noremap = true, silent = false }
local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
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

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { noremap = true, silent = false, buffer = bufnr }

	-- code lens
	if client.resolved_capabilities.code_lens then
		local codelens = vim.api.nvim_create_augroup(
			'LSPCodeLens',
			{ clear = true }
		)
		vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'CursorHold' }, {
			group = codelens,
			callback = function()
				vim.lsp.codelens.refresh()
			end,
			buffer = bufnr,
		})
	end
end



vim.keymap.set("n", "<space>K", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>lq", vim.diagnostic.setloclist, opts)

require("lspconfig")["intelephense"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

-- Lua
require("lspconfig")["lua_ls"].setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = "Disable",
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

require("lspconfig")["eslint"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

require("lspconfig")["cssls"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

require 'lspconfig'.tsserver.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" }
})


require('lspconfig')['ocamllsp'].setup({
	cmd = { "ocamllsp" },
	filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
	root_dir = lsp.util.root_pattern("*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace"),
	on_attach = on_attach,
	capabilities = capabilities
})

require("lspconfig")["gopls"].setup({
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.mod", "go.work", ".git"),
	on_attach = on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

-- Python Setup
local function get_python_path(workspace)
	-- Use activated virtualenv.
	if vim.env.VIRTUAL_ENV then
		return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
	end

	-- Find and use virtualenv in workspace directory.
	local match = vim.fn.glob(path.join("/home/jared/.pyenv", "jareds-venv", 'pyvenv.cfg'))
	if match ~= '' then
		return path.join(path.dirname(match), 'bin', 'python')
	end

	-- Fallback to system Python.
	return exepath('python3') or exepath('python') or 'python'
end

require("lspconfig")["pyright"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				typeCheckingMode = 'off',
				useLibraryCodeForTypes = true,
			}
		}
	},
	before_init = function(_, config)
		config.settings.python.pythonPath = get_python_path(config.root_dir)
	end,
})

--
-- -- PHP Setup
-- local bin_name = "intelephense"
-- local cmd = { bin_name, "--stdio" }
--
-- return {
-- 	default_config = {
-- 		cmd = cmd,
-- 		filetypes = { "php" },
-- 		root_dir = function(pattern)
-- 			local cwd = vim.loop.cwd()
-- 			local root = util.root_pattern("composer.json", ".git", "wp-config.php")(pattern)
--
-- 			-- prefer cwd if root is a descendant
-- 			return util.path.is_descendant(cwd, root) and cwd or root
-- 		end,
-- 	},
-- 	docs = {
-- 		default_config = {
-- 			root_dir = [[root_pattern("composer.json", ".git")]],
-- 			init_options = [[{
--         storagePath = Optional absolute path to storage dir. Defaults to os.tmpdir().
--         globalStoragePath = Optional absolute path to a global storage dir. Defaults to os.homedir().
--         licenceKey = Optional licence key or absolute path to a text file containing the licence key.
--         clearCache = Optional flag to clear server state. State can also be cleared by deleting {storagePath}/intelephense
--         -- See https://github.com/bmewburn/intelephense-docs/blob/master/installation.md#initialisation-options
--       }]],
-- 			settings = [[{
--         intelephense = {
--           files = {
--             maxSize = 1000000;
--           };
--         };
--         -- See https://github.com/bmewburn/intelephense-docs
--       }]],
-- 		},
-- 	},
-- }
--
--
