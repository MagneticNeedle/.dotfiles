return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"mason-org/mason.nvim",
	},

	config = function()
		local lspconfig = require("lspconfig")
		local mason = require("mason")

		mason.setup({
			ensure_installed = { "basedpyright", "lua_ls" },
		})

		lspconfig.basedpyright.setup({})
		lspconfig.lua_ls.setup({})
	end,
}
