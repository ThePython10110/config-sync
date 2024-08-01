local autocmds = {
  TextYankPost = {
    desc = "Highlight when yanking",
    group = vim.api.nvim_create_augroup("highlight-yank", {clear = true}),
    callback = function() vim.highlight.on_yank() end,
  }
}

for name, def in pairs(autocmds) do
  vim.api.nvim_create_autocmd(name, def)
end
