return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		'L3MON4D3/LuaSnip',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-buffer',
		'saadparwaiz1/cmp_luasnip',
	},
	config = function()
		local cmp = require'cmp'
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			})
		})
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		require('lspconfig')['lua_ls'].setup {
			capabilities = capabilities
		}
		require('lspconfig')['gopls'].setup {
			capabilities = capabilities
		}
	end,
}

