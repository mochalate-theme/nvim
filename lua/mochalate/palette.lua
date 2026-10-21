local util = require 'mochalate.util'

local M = {}

--- Mochalate palette: a cozy fusion of gruvbox warmth and catppuccin softness,
--- rendered in fallen-leaf tones for long coding sessions.
M.dark = {
  none = 'NONE',

  -- Backgrounds (darkest -> lightest) -- warm brown-black
  bg = '#1c1815', -- editor
  bg_alt = '#242019', -- sidebar / status / panel / inactive tabs
  bg_menu = '#2c261e', -- menu / quick input / floats
  bg_line = '#342e25', -- line highlight, hover
  bg_widget = '#38322a', -- widget hover
  bg_select = '#5c4030', -- selection (warm terracotta)
  bg_match = '#4a3428', -- dimmed selection (search matches)
  border = '#3e3630',
  border_alt = '#4e463e',

  -- Foregrounds -- warm creams
  fg = '#e8d5c4',
  fg_alt = '#dfcbb8',
  fg_dim = '#a89278',
  fg_muted = '#7a6850',
  white = '#f5ead8',

  -- Accent -- mochalate amber
  accent = '#e8a050',
  accent_dim = '#d08840',
  accent_alt = '#f0b870',

  -- Syntax -- gruvbox structure with mochalate coloring
  comment = '#8a7560', -- warm muted brown
  string = '#a8b878', -- sage / olive green
  regex = '#d8a050', -- amber
  number = '#d8a050', -- amber
  keyword = '#d06850', -- burnt coral
  func = '#e0a060', -- warm amber-orange
  type = '#78a890', -- muted teal-sage
  variable = '#e8d5c4', -- default fg (plain ident)
  constant = '#d8a050', -- amber
  operator = '#d06850', -- burnt coral
  preproc = '#d06850', -- burnt coral control flow
  annotation = '#c88060', -- terracotta
  param = '#c88060', -- terracotta
  member = '#e0a060', -- warm orange field/property
  tag = '#c0a860', -- golden
  attr = '#d8a050', -- amber
  module = '#78a890', -- sage teal module/namespace
  macro = '#d07850', -- burnt sienna

  -- Diagnostics / status
  err = '#e06058', -- warm red
  warn = '#d8a050', -- amber
  info = '#88a0c0', -- muted blue
  hint = '#78a890', -- sage teal
  ok = '#90b070', -- warm green
  debug = '#b890c0', -- muted mauve

  -- Diff
  diff_add = '#253028',
  diff_add_fg = '#90b070',
  diff_del = '#352525',
  diff_del_fg = '#d88078',
  diff_chg = '#303025',
  diff_chg_fg = '#d8a050',
  diff_text = '#403828',
}

--- Backward-compatible alias.
M.base = M.dark

--- Resolve the palette for a config: base -> `palette` overrides -> derived
--- colors -> `on_colors`.
---@param opts MochalateConfig
---@return table<string, string>
function M.get(opts)
  opts = opts or require('mochalate.config').defaults

  local c = vim.tbl_extend('force', vim.deepcopy(M.dark), opts.palette or {})

  local floats = opts.styles.floats
  if floats == 'auto' then
    floats = opts.transparent and 'transparent' or 'solid'
  end

  -- Contextual backgrounds. Set them in `palette` to opt out of the derivation.
  c.bg_normal = c.bg_normal or (opts.transparent and c.none or c.bg)
  c.bg_panel = c.bg_panel or (opts.transparent and c.none or c.bg_alt)
  c.bg_float = c.bg_float or (floats == 'transparent' and c.none or c.bg_menu)
  if opts.transparent then
    c.bg_inactive = c.bg_inactive or c.none
  else
    c.bg_inactive = c.bg_inactive or util.darken(c.bg, 0.35)
  end

  -- Blended diagnostic backgrounds for virtual text.
  c.err_bg = c.err_bg or (opts.transparent and c.none or util.blend(c.err, c.bg, 0.12))
  c.warn_bg = c.warn_bg or (opts.transparent and c.none or util.blend(c.warn, c.bg, 0.12))
  c.info_bg = c.info_bg or (opts.transparent and c.none or util.blend(c.info, c.bg, 0.12))
  c.hint_bg = c.hint_bg or (opts.transparent and c.none or util.blend(c.hint, c.bg, 0.12))

  c.terminal = c.terminal
    or {
      [0] = c.bg_menu,
      [1] = c.keyword,
      [2] = c.regex,
      [3] = c.warn,
      [4] = c.number,
      [5] = c.func,
      [6] = c.type,
      [7] = c.fg,
      [8] = c.fg_muted,
      [9] = c.diff_del_fg,
      [10] = util.lighten(c.regex, 0.15),
      [11] = c.annotation,
      [12] = c.string,
      [13] = c.debug,
      [14] = util.lighten(c.type, 0.2),
      [15] = c.white,
    }

  if type(opts.on_colors) == 'function' then
    opts.on_colors(c)
  end

  return c
end

return M
