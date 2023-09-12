local function get_git_root_dir()
	local command = "git rev-parse --show-toplevel"
	local is_git_repo, git_root_dir = pcall(vim.fn.system, command)
	if is_git_repo then
		git_root_dir = string.gsub(git_root_dir, "\n", "")
		if vim.fn.isdirectory(git_root_dir) ~= 1 then
			return nil
		end
		vim.cmd.cd(git_root_dir)
		return git_root_dir
	end
	return nil
end

local function cd_and_get_dir_info(file_or_dir)
	-- if opened file, get parent dir of the file and cd to the dir.
	-- if opened dir, cd to the dir.
	-- returns absolute path to working dir and reveal target of file tree.
	local wd = file_or_dir
	local reveal_target = file_or_dir
	local is_directory = vim.fn.isdirectory(file_or_dir) == 1
	if not is_directory then
		wd = vim.fn.fnamemodify(file_or_dir, ":h")
	end
	vim.cmd.cd(wd)
	return wd, reveal_target, is_directory
end

local function calc_relative_path(base_path, target_path)
	-- calculate relative path to target_path from base_path
	-- base_path and target_path are both given in absolute path
	return vim.fn.fnamemodify(target_path, string.format(":s?%s/??", base_path))
end

local function open_fern(data)
	local wd, reveal_target, is_target_directory = cd_and_get_dir_info(data.file)
	local git_root_dir = get_git_root_dir()
	if git_root_dir then
		wd = git_root_dir
	end
	local relative_reveal_target = calc_relative_path(wd, reveal_target)
	local command = string.format("Fern %s -drawer -reveal=%s", wd, relative_reveal_target) 
	if is_target_directory then
		command = string.format("Fern %s -reveal=%s", wd, relative_reveal_target)
	end
	vim.api.nvim_command(command)
end

return {
	"lambdalisue/fern.vim",
	config = function()
		vim.g.loaded_netrwPlugin = 0
		vim.g["fern#default_hidden"] = 1
		vim.api.nvim_create_augroup("open-folder", { clear = true })
		vim.api.nvim_create_autocmd({ "VimEnter" }, {
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
		{ "lambdalisue/fern-git-status.vim" },
		{
			"lambdalisue/fern-renderer-nerdfont.vim",
			config = function()
				vim.g["fern#renderer"] = "nerdfont"
			end,
		},
	},
}

