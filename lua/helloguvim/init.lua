local M = {}

---@param opts? HelloGuVimConfig
function M.setup(opts)
  require("helloguvim.config").setup(opts)
end

return M
