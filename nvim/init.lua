-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- settings
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 0
vim.opt.number = true
vim.opt.title = true
vim.opt.cursorline = true

-- Any lua file in ~/.config/nvim/lua/plugins/*.lua will be automatically merged in the main plugin spec
require("lazy").setup("plugins")

vim.cmd.colorscheme("kanagawa-dragon")

local function open_nvim_tree(data)

  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  if not real_file and not no_name then
    return
  end

  -- open the tree, find the file but don't focus it
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local set = vim.keymap.set
    set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
    set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
    set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
    set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
    set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
    set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
    set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = true })
    set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
    set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
    set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
    set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { buffer = true })
    set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = true })
    set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = true })
    set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
    set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = true })
  end,
})

