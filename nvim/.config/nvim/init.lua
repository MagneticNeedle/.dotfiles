require("config.lazy")

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.diagnostic.config({ virtual_text = true })
vim.cmd.colorscheme("gruber-darker")
vim.lsp.enable("basedpyright")
vim.lsp.enable("lua_ls")
