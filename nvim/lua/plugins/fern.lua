function get_git_root_dir_or_cwd()
	-- git リポジトリで nvim が開かれたならリポジトリの root ディレクトリを、そうでないならカレントディレクトリを返す
	command = "git rev-parse --show-toplevel"
	is_git_repo, git_root_dir = pcall(vim.fn.system, command)
	if is_git_repo then
		return string.gsub(git_root_dir, "\n", "")
	end
	return vim.fn.getcwd()
end

function open_fern()
	wd = get_git_root_dir_or_cwd()
	current_file = vim.api.nvim_buf_get_name(0)
	command = string.format("Fern %s -drawer -reveal=%s", wd, current_file) 
	vim.api.nvim_command(command)
end

return {
	"lambdalisue/fern.vim",
	config = function()
		vim.api.nvim_create_augroup("open-folder", { clear = true })
		vim.api.nvim_create_autocmd("VimEnter", {
			group = "open-folder",
			nested = true,
			callback = open_fern,
		})
	end,
	dependencies = {
		{ "lambdalisue/nerdfont.vim" },
		{
			"lambdalisue/glyph-palette.vim",
			config = function()
				vim.api.nvim_create_augroup("glyph_palette", { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = "glyph_palette",
					pattern = "fern",
					command = "call glyph_palette#apply()",
				})
			end,
		},
		{ "lambdalisue/fern-hijack.vim" },
		{ "lambdalisue/fern-git-status.vim" },
		{
			"lambdalisue/fern-renderer-nerdfont.vim",
			config = function()
				vim.g["fern#renderer"] = "nerdfont"
			end,
		},
	},
}

