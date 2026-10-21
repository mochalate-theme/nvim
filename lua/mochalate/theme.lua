local util = require 'mochalate.util'

local M = {}

local core_modules = { 'editor', 'syntax', 'treesitter', 'lsp' }

--- Build the full highlight table for a config.
---@param opts MochalateConfig
---@return table<string, table> highlights, table<string, string> colors
function M.build(opts)
  local colors = require('mochalate.palette').get(opts)
  local highlights = {}

  for _, name in ipairs(core_modules) do
    util.merge_highlights(highlights, require('mochalate.groups.' .. name).get(colors, opts))
  end

  local plugins = require('mochalate.groups.plugins').get(colors, opts)
  for name, groups in pairs(plugins) do
    if opts.plugins[name] ~= false then
      util.merge_highlights(highlights, groups)
    end
  end

  if type(opts.on_highlights) == 'function' then
    opts.on_highlights(highlights, colors)
  end

  util.merge_highlights(highlights, opts.highlights)

  return highlights, colors
end

return M
