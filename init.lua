vim.api.nvim_echo({
  {
    "Hello Gu",
    "ErrorMsg",
  },
  {
    "Hello Gu",
    "WarningMsg",
  },
  { "Press any key to exit", "MoreMsg" },
}, true, {})

vim.fn.getchar()
vim.cmd([[quit]])
