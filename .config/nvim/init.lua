-- Load Vim options
require("options")

-- Install Lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "https://github.com/folke/lazy.nvim.git",
    "--filter=blob:none", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up Lazy.nvim
require("lazy").setup("plugins", {})

-- Set up keybindings
require("keys")

-- Set up autocmds
require("autocmd")
