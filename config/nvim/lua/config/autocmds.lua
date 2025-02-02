-- clear marks a-z on buffer enter
-- See: https://github.com/chentoast/marks.nvim/issues/13
--      https://github.com/neovim/neovim/issues/4295
local delm_augroup = vim.api.nvim_create_augroup("clear_marks", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = delm_augroup,
  command = "delm a-z",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if vim.bo.buftype == "nofile" then
      vim.b.miniindentscope_disable = true
      vim.wo.list = false
      vim.bo.expandtab = false
    end
  end
})
