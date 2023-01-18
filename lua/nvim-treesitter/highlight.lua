local configs = require "nvim-treesitter.configs"

local M = {}

---@param config TSModule
---@param lang string
---@return boolean
local function should_enable_vim_regex(config, lang)
  local additional_hl = config.additional_vim_regex_highlighting
  local is_table = type(additional_hl) == "table"

  ---@diagnostic disable-next-line: param-type-mismatch
  return additional_hl and (not is_table or vim.tbl_contains(additional_hl, lang))
end

---@param bufnr integer
---@param lang string
function M.attach(bufnr, lang)
  local config = configs.get_module "highlight"
  vim.treesitter.start(bufnr, lang)
  if config and should_enable_vim_regex(config, lang) then
    -- PR #4092 broke VimWiki's markdown syntax. Hack to add support here for
    -- now.
    -- https://github.com/nvim-treesitter/nvim-treesitter/pull/4092
    -- vim.bo[bufnr].syntax = "ON"
    vim.api.nvim_buf_set_option(bufnr, "syntax", "ON")
  end
end

---@param bufnr integer
function M.detach(bufnr)
  vim.treesitter.stop(bufnr)
  -- PR #4092 broke VimWiki's markdown syntax. Hack to add support here for
  -- now.
  -- https://github.com/nvim-treesitter/nvim-treesitter/pull/4092
  vim.api.nvim_buf_set_option(bufnr, "syntax", "ON")
end

---@deprecated
function M.start(...)
  vim.notify(
    "`nvim-treesitter.highlight.start` is deprecated: use `nvim-treesitter.highlight.attach` or `vim.treesitter.start`",
    vim.log.levels.WARN
  )
  M.attach(...)
end

---@deprecated
function M.stop(...)
  vim.notify(
    "`nvim-treesitter.highlight.stop` is deprecated: use `nvim-treesitter.highlight.detach` or `vim.treesitter.stop`",
    vim.log.levels.WARN
  )
  M.detach(...)
end

return M
