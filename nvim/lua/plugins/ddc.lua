return {
	"Shougo/ddc.vim",
	config = function() 
		vim.fn["ddc#custom#patch_global"]("ui", "native")

		vim.fn["ddc#custom#patch_global"]("sources", { "around" })
		vim.fn["ddc#custom#patch_global"]("sourceOptions", {
			around = { mark = "A" }
		})
		vim.fn["ddc#custom#patch_global"]("sourceParams", {
			around = { maxSize = 500 },
			_ = {
				matcher = "mather_head"
			}
		})

		vim.fn["ddc#enable"]()
	end,
	dependencies = {
		{ "vim-denops/denops.vim" },
		{ "Shougo/ddc-source-around" },
		{ "Shougo/ddc-ui-native" },
		{ "Shougo/ddc-filter-matcher_head" }
	}
}
