require("helloguvim.config").init()

return {
  { "folke/lazy.nvim", version = "*" },
  { "HelloGup/HelloGuVim", priority = 10000, lazy = false, config = true, cond = true, version = "*" },
}
