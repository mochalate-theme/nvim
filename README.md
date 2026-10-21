# mochalate.nvim

A cozy dark Neovim colorscheme, a fusion of [gruvbox](https://github.com/morhetz/gruvbox)'s warm
earthiness and [catppuccin](https://github.com/catppuccin/nvim)'s soft pastels, rendered in mochalate
tones for long coding sessions.

Warm brown-black backgrounds, burnt coral keywords, amber numbers, sage-green strings, muted
teal types: every color reads as a fallen-leaf palette.

## Features

- **638 highlight groups**: editor UI, legacy syntax, tree-sitter, LSP semantic tokens,
  diagnostics, diffs, and 28 plugins.
- **Transparency** for the editor, with floating windows controlled separately.
- **Per-token styling**: bold/italic/underline for 20 semantic token families.
- **Palette overrides**, static (`palette`) or programmatic (`on_colors`).
- **Highlight overrides**, static (`highlights`) or programmatic (`on_highlights`).
- **Per-plugin opt-out** for every plugin integration.
- Terminal colors (`vim.g.terminal_color_*`) and a **lualine** theme.
- No dependencies. Config errors warn instead of breaking your session.
- Dark-only, designed for evening light and long sessions, no light mode.

## Requirements

- Neovim 0.9+
- A true-color terminal (`'termguicolors'` is set by the theme)

## Installation

<details open>
<summary><b>vim.pack (Neovim 0.12+)</b></summary>

In `init.lua`:

```lua
vim.pack.add {
  { src = 'https://github.com/mochalate-theme/nvim', name = 'mochalate' },
}

require('mochalate').setup {}
vim.cmd.colorscheme 'mochalate'
```

`name` matters here: the repository is `mochalate-theme/nvim`, and `vim.pack` names the
plugin directory after the repository, so without it the theme would be installed as
`nvim`.

No `priority` or `lazy` equivalent is needed: `vim.pack.add()` installs (on first run) and
adds to `'runtimepath'` synchronously, so the plugin is usable on the next line.

</details>

<details>
<summary><b>lazy.nvim</b></summary>

```lua
{
  'mochalate-theme/nvim',
  name = 'mochalate',
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require('mochalate').setup(opts)
    vim.cmd.colorscheme 'mochalate'
  end,
}
```

</details>

<details>
<summary><b>packer.nvim</b></summary>

```lua
use {
  'mochalate-theme/nvim',
  as = 'mochalate',
  config = function()
    require('mochalate').setup {}
    vim.cmd.colorscheme 'mochalate'
  end,
}
```

</details>

`setup()` is optional: `:colorscheme mochalate` alone gives you the defaults. Call `setup()`
only when you want to change something, and always **before** the `colorscheme` command
(calling it afterwards reapplies the theme, which also works).

## Configuration

The complete set of options, with defaults:

```lua
require('mochalate').setup {
  transparent = false,      -- clear the editor background
  terminal_colors = true,   -- set vim.g.terminal_color_0..15
  dim_inactive = false,     -- darken unfocused windows (NormalNC)

  styles = {
    comments = { italic = true },
    keywords = {},
    conditionals = {},
    functions = {},
    methods = {},
    variables = {},
    builtins = { italic = true },
    parameters = {},
    properties = {},
    types = {},
    strings = {},
    numbers = {},
    booleans = {},
    constants = {},
    operators = {},
    namespaces = {},
    macros = {},
    attributes = {},
    tags = {},
    headings = { bold = true },

    floats = 'solid',       -- 'solid' | 'transparent' | 'auto'
  },

  palette = {},                                        -- static color overrides
  on_colors = function(colors) end,                    -- programmatic color overrides
  highlights = {},                                     -- static highlight overrides
  on_highlights = function(highlights, colors) end,    -- programmatic highlight overrides
  plugins = {},                                        -- e.g. { telescope = false }
}
```

Unknown option names and invalid `styles.floats` values produce a warning and are ignored:
a typo will never leave you without a colorscheme.

---

### `transparent`

Clears the background of `Normal`, `NormalNC`, the sign column, line numbers, fold column,
statusline, tabline, winbar and diagnostic virtual text, letting your terminal background
through.

```lua
require('mochalate').setup { transparent = true }
```

Floating windows are **not** affected; see [`styles.floats`](#stylesfloats).

### `styles.floats`

| Value                 | Effect                                                            |
| --------------------- | ----------------------------------------------------------------- |
| `'solid'` _(default)_ | Floats, popups and completion menus always painted (`#2c261e`)    |
| `'transparent'`       | Floats never painted                                              |
| `'auto'`              | Follows `transparent`                                             |

Keeping this at `'solid'` with `transparent = true` gives you a see-through editor with
readable popups, which is usually what you want:

```lua
require('mochalate').setup {
  transparent = true,
  styles = { floats = 'solid' },
}
```

Affects `NormalFloat`, `FloatBorder`, `FloatTitle`, `Pmenu*`, and the float-based groups of
every plugin integration (telescope, blink.cmp, noice, lazy, mason, …).

### `terminal_colors`

Sets `vim.g.terminal_color_0` … `vim.g.terminal_color_15` so `:terminal` buffers use the
theme's ANSI palette. Set to `false` to leave them alone. See
[Matching your terminal](#matching-your-terminal) for the same values in Ghostty/kitty form.

### `dim_inactive`

Paints unfocused windows (`NormalNC`) with `bg_inactive`, a darkened `bg`. Ignored when
`transparent = true`.

### `styles.<token>`

Every entry is an [`nvim_set_hl()`](<https://neovim.io/doc/user/api.html#nvim_set_hl()>) attribute
table merged into the highlight specs of that token family. Add an attribute with `true`,
remove one the theme sets with `false`:

```lua
require('mochalate').setup {
  styles = {
    comments = { italic = false },   -- drop the default italic
    keywords = { italic = true },
    functions = { bold = true },
    types = { italic = true },
    parameters = { italic = true },
    headings = { bold = true, underline = true },
  },
}
```

Usable attributes: `bold`, `italic`, `underline`, `undercurl`, `underdouble`, `underdotted`,
`underdashed`, `strikethrough`, `reverse`, `nocombine`.

| Key            | Default             | Applies to (plus every group linked to these)                                                             |
| -------------- | ------------------- | --------------------------------------------------------------------------------------------------------- |
| `comments`     | `{ italic = true }` | `Comment`, `SpecialComment`, `@comment*`, `@markup.quote`                                                 |
| `keywords`     | -                   | `Keyword`, `Statement`, `Label`, `StorageClass`, `PreProc`, `Include`, `Define`, `PreCondit`, `@keyword*` |
| `conditionals` | -                   | `Conditional`, `Repeat`, `Exception`, `@keyword.return`, `@keyword.conditional`, `@keyword.repeat`        |
| `functions`    | -                   | `Function`, `@function`, `@function.call`, `@function.builtin`                                            |
| `methods`      | -                   | `@function.method`, `@function.method.call`, `@lsp.type.method`                                           |
| `variables`    | -                   | `Identifier`, `@variable`, `@variable.builtin`                                                            |
| `builtins`     | `{ italic = true }` | `@variable.builtin`, `@function.builtin`, `@type.builtin`, `@module.builtin`, `@attribute.builtin`        |
| `parameters`   | -                   | `@variable.parameter`, `@lsp.type.parameter`                                                              |
| `properties`   | -                   | `@property`, `@field`, `@variable.member`, `@lsp.type.property`                                           |
| `types`        | -                   | `Type`, `Structure`, `Typedef`, `@type*`, `@constructor`, `@lsp.type.class/enum/interface/struct`         |
| `strings`      | -                   | `String`, `Character`, `@string*`, `@string.escape`, `@string.regexp`                                     |
| `numbers`      | -                   | `Number`, `Float`, `@number`, `@number.float`                                                             |
| `booleans`     | -                   | `Boolean`, `@boolean`                                                                                     |
| `constants`    | -                   | `Constant`, `@constant*`, `@lsp.type.enumMember`, `@lsp.type.const`, readonly variables                   |
| `operators`    | -                   | `Operator`, `@operator`, `@lsp.type.operator`                                                             |
| `namespaces`   | -                   | `@module`, `@namespace`, `@lsp.type.namespace`                                                            |
| `macros`       | -                   | `Macro`, `@function.macro`, `@constant.macro`, `@lsp.type.macro`                                          |
| `attributes`   | -                   | `@attribute`, `@tag.attribute`, `@lsp.type.decorator`                                                     |
| `tags`         | -                   | `Tag`, `@tag`, `@tag.builtin`                                                                             |
| `headings`     | `{ bold = true }`   | `@markup.heading` and `@markup.heading.1` … `.6`                                                          |

### `palette`

Static color overrides, applied on top of the base palette before anything is derived:

```lua
require('mochalate').setup {
  palette = {
    bg = '#151210',
    keyword = '#d4785c',
    func = '#e8b070',
    comment = '#907860',
  },
}
```

<details>
<summary><b>All palette keys</b></summary>

**Backgrounds**

| Key          | Value     | Used for                       |
| ------------ | --------- | ------------------------------ |
| `bg`         | `#1c1815` | editor background              |
| `bg_alt`     | `#242019` | statusline, tabline, panels    |
| `bg_menu`    | `#2c261e` | floats, popups, completion     |
| `bg_line`    | `#342e25` | cursorline, folds, inlay hints |
| `bg_widget`  | `#38322a` | LSP references, illuminate     |
| `bg_select`  | `#5c4030` | visual selection               |
| `bg_match`   | `#4a3428` | search matches                 |
| `border`     | `#3e3630` | window separators              |
| `border_alt` | `#4e463e` | float borders                  |

**Foregrounds**

| Key        | Value     | Used for                   |
| ---------- | --------- | -------------------------- |
| `fg`       | `#e8d5c4` | default text               |
| `fg_alt`   | `#dfcbb8` | emphasized text            |
| `fg_dim`   | `#a89278` | secondary text             |
| `fg_muted` | `#7a6850` | line numbers, whitespace   |
| `white`    | `#f5ead8` | text on accent backgrounds |

**Accent**

| Key          | Value     |
| ------------ | --------- |
| `accent`     | `#e8a050` |
| `accent_dim` | `#d08840` |
| `accent_alt` | `#f0b870` |

**Syntax**

| Key        | Value     | Key          | Value     |
| ---------- | --------- | ------------ | --------- |
| `comment`  | `#8a7560` | `annotation` | `#c88060` |
| `string`   | `#a8b878` | `param`      | `#c88060` |
| `regex`    | `#d8a050` | `member`     | `#e0a060` |
| `number`   | `#d8a050` | `tag`        | `#c0a860` |
| `keyword`  | `#d06850` | `attr`       | `#d8a050` |
| `func`     | `#e0a060` | `module`     | `#78a890` |
| `type`     | `#78a890` | `macro`      | `#d07850` |
| `variable` | `#e8d5c4` | `operator`   | `#d06850` |
| `constant` | `#d8a050` | `preproc`    | `#d06850` |

**Diagnostics & diff**

| Key     | Value     | Key           | Value     |
| ------- | --------- | ------------- | --------- |
| `err`   | `#e06058` | `diff_add`    | `#253028` |
| `warn`  | `#d8a050` | `diff_add_fg` | `#90b070` |
| `info`  | `#88a0c0` | `diff_del`    | `#352525` |
| `hint`  | `#78a890` | `diff_del_fg` | `#d88078` |
| `ok`    | `#90b070` | `diff_chg`    | `#303025` |
| `debug` | `#b890c0` | `diff_chg_fg` | `#d8a050` |
|         |           | `diff_text`   | `#403828` |

**Derived**: computed from the above after `palette` is applied, so they follow your
overrides. Set them explicitly in `palette` to opt out of the derivation.

| Key                                    | Derivation                                         |
| -------------------------------------- | -------------------------------------------------- |
| `bg_normal`                            | `NONE` when `transparent`, else `bg`               |
| `bg_panel`                             | `NONE` when `transparent`, else `bg_alt`           |
| `bg_float`                             | `NONE` when floats are transparent, else `bg_menu` |
| `bg_inactive`                          | `bg` darkened 35% (used by `dim_inactive`)         |
| `err_bg` `warn_bg` `info_bg` `hint_bg` | diagnostic color blended 12% onto `bg`             |
| `terminal`                             | table of the 16 ANSI colors                        |

</details>

### `on_colors(colors)`

Runs after `palette`, with the whole resolved palette (including the derived keys). Mutate
it in place:

```lua
local util = require 'mochalate.util'

require('mochalate').setup {
  on_colors = function(colors)
    colors.comment = util.lighten(colors.comment, 0.15)  -- brighter comments
    colors.bg_float = colors.bg                          -- floats share the editor bg
    colors.terminal[1] = '#ff5555'                       -- custom ANSI red
  end,
}
```

`util` exposes `blend(fg, bg, alpha)`, `darken(hex, amount)`, `lighten(hex, amount)`,
`hex_to_rgb` and `rgb_to_hex`.

### `highlights`

Static highlight-group overrides, merged **last**, after the theme and after
`on_highlights`:

```lua
require('mochalate').setup {
  highlights = {
    Comment = { fg = '#907860' },       -- merged: the theme's italic is kept
    CursorLine = { bg = '#302820' },
    ['@variable.parameter'] = { fg = '#c88060', italic = true },
    Visual = { link = 'CursorLine' },   -- a spec with `link` replaces the group outright
  },
}
```

Merge rules: table entries merge key-by-key, so you can change only `fg` and keep the rest.
Pass `italic = false` to clear an attribute. A spec containing `link` replaces the group
completely.

### `on_highlights(highlights, colors)`

Same thing, programmatically, with the palette in hand. Receives the fully built highlight
table before `highlights` is merged on top:

```lua
require('mochalate').setup {
  on_highlights = function(hl, colors)
    hl.LineNr = { fg = colors.fg_dim }
    hl.WinSeparator = { fg = colors.accent_dim }
    hl.CursorLineNr = { fg = colors.accent, bold = true }
    hl.MyPluginTitle = { fg = colors.accent, bold = true }  -- new groups are fine too
  end,
}
```

### `plugins`

All plugin integrations are on by default. Disable any of them by key: the theme then
leaves those groups untouched, so the plugin's own defaults (or your config) apply:

```lua
require('mochalate').setup {
  plugins = { bufferline = false, dap = false },
}
```

| Key          | Plugin                                            | Key                  | Plugin                                                          |
| ------------ | ------------------------------------------------- | -------------------- | --------------------------------------------------------------- |
| `gitsigns`   | gitsigns.nvim                                     | `neo_tree`           | neo-tree.nvim                                                   |
| `telescope`  | telescope.nvim                                    | `nvim_tree`          | nvim-tree.lua                                                   |
| `fzf_lua`    | fzf-lua                                           | `oil`                | oil.nvim                                                        |
| `snacks`     | snacks.nvim (picker, notifier, dashboard, indent) | `indent_blankline`   | indent-blankline.nvim                                           |
| `blink`      | blink.cmp                                         | `mini`               | mini.nvim (statusline, tabline, pick, files, diff, indentscope) |
| `cmp`        | nvim-cmp                                          | `lazy`               | lazy.nvim                                                       |
| `bufferline` | bufferline.nvim                                   | `mason`              | mason.nvim                                                      |
| `which_key`  | which-key.nvim                                    | `trouble`            | trouble.nvim                                                    |
| `notify`     | nvim-notify                                       | `flash`              | flash.nvim                                                      |
| `noice`      | noice.nvim                                        | `illuminate`         | vim-illuminate                                                  |
| `dashboard`  | dashboard-nvim, alpha-nvim                        | `treesitter_context` | nvim-treesitter-context                                         |
| `yanky`      | yanky.nvim                                        | `rainbow`            | rainbow-delimiters.nvim                                         |
| `fidget`     | fidget.nvim                                       | `dap`                | nvim-dap, nvim-dap-ui                                           |
| `markdown`   | render-markdown.nvim                              | `navic`              | nvim-navic                                                      |

## lualine

```lua
require('lualine').setup { options = { theme = 'mochalate' } }
```

The theme reads the resolved palette, so it follows your `palette` / `on_colors` overrides.

## API

```lua
local mochalate = require 'mochalate'

mochalate.setup(opts)        -- store config; reapplies the theme if it is already active
mochalate.load(opts)         -- apply the colorscheme; opts override the stored config for this call
mochalate.colors(opts)       -- resolved palette table
mochalate.highlights(opts)   -- resolved highlight table + palette, without applying them
```

`mochalate.colors()` is handy for statuslines and other plugins that need to match:

```lua
local c = require('mochalate').colors()
vim.api.nvim_set_hl(0, 'MyGroup', { fg = c.accent, bg = c.bg_alt })
```

## Matching your terminal

The ANSI palette used for `:terminal` and exported via `vim.g.terminal_color_*`:

|         | Normal    |                | Bright    |
| ------- | --------- | -------------- | --------- |
| black   | `#2c261e` | bright black   | `#7a6850` |
| red     | `#d06850` | bright red     | `#d88078` |
| green   | `#d8a050` | bright green   | `#e8b868` |
| yellow  | `#d8a050` | bright yellow  | `#c88060` |
| blue    | `#d8a050` | bright blue    | `#a8b878` |
| magenta | `#e0a060` | bright magenta | `#b890c0` |
| cyan    | `#78a890` | bright cyan    | `#90b8a0` |
| white   | `#e8d5c4` | bright white   | `#f5ead8` |

With `background #1c1815`, `foreground #e8d5c4`, cursor `#e8d5c4`, selection `#5c4030` on
`#f5ead8`. Ready-made theme files:
[Ghostty](https://github.com/code-2026-theme/ghostty) ·
[kitty](https://github.com/code-2026-theme/kitty), note these are the code-2026 values;
adjust to the mochalate palette above for a matching terminal.

<details>
<summary><b>Ghostty</b></summary>

```conf
background = #1c1815
foreground = #e8d5c4
cursor-color = #e8d5c4
cursor-text = #1c1815
selection-background = #5c4030
selection-foreground = #f5ead8

palette = 0=#2c261e
palette = 1=#d06850
palette = 2=#a8b878
palette = 3=#d8a050
palette = 4=#88a0c0
palette = 5=#e0a060
palette = 6=#78a890
palette = 7=#e8d5c4
palette = 8=#7a6850
palette = 9=#d88078
palette = 10=#b0c888
palette = 11=#e8b870
palette = 12=#a0b8d0
palette = 13=#c8a0d0
palette = 14=#90c0a8
palette = 15=#f5ead8
```

</details>

<details>
<summary><b>kitty</b></summary>

```conf
background            #1c1815
foreground            #e8d5c4
cursor                #e8d5c4
cursor_text_color     #1c1815
selection_background  #5c4030
selection_foreground  #f5ead8
url_color             #f0b870

color0  #2c261e
color8  #7a6850
color1  #d06850
color9  #d88078
color2  #a8b878
color10 #b0c888
color3  #d8a050
color11 #e8b870
color4  #88a0c0
color12 #a0b8d0
color5  #e0a060
color13 #c8a0d0
color6  #78a890
color14 #90c0a8
color7  #e8d5c4
color15 #f5ead8
```

</details>

## Recipes

<details open>
<summary><b>Transparent editor, solid popups, italic keywords</b></summary>

```lua
require('mochalate').setup {
  transparent = true,
  styles = {
    floats = 'solid',
    keywords = { italic = true },
    comments = { italic = true },
  },
}
```

</details>

<details>
<summary><b>No italics anywhere</b></summary>

```lua
require('mochalate').setup {
  styles = {
    comments = { italic = false },
    builtins = { italic = false },
  },
}
```

</details>

<details>
<summary><b>Darker background, flatter UI</b></summary>

```lua
require('mochalate').setup {
  palette = { bg = '#141110', bg_alt = '#141110', bg_menu = '#1c1815' },
  on_highlights = function(hl, c)
    hl.WinSeparator = { fg = c.bg_line }
    hl.SignColumn = { bg = c.bg_normal }
  end,
}
```

</details>

<details>
<summary><b>Reuse the palette in your own config</b></summary>

```lua
local c = require('mochalate').colors()

require('lualine').setup {
  options = { theme = 'mochalate' },
  sections = { lualine_c = { { 'filename', color = { fg = c.accent_alt } } } },
}
```

</details>

## Structure

```
colors/mochalate.lua               :colorscheme entry point
lua/mochalate/init.lua             setup / load / colors / highlights
lua/mochalate/config.lua           defaults and validation
lua/mochalate/palette.lua          mochalate palette and derived colors
lua/mochalate/theme.lua            group assembly and override pipeline
lua/mochalate/util.lua             color math and merge helpers
lua/mochalate/groups/              editor, syntax, treesitter, lsp, plugins
lua/lualine/themes/mochalate.lua   lualine theme
doc/mochalate.txt                  :help mochalate
```

Override precedence, in order: base palette → `palette` → derived colors → `on_colors` →
highlight groups → `on_highlights` → `highlights`.

## Credits

- [morhetz/gruvbox](https://github.com/morhetz/gruvbox): the warm, earthy foundation this
  theme draws from.
- [catppuccin/nvim](https://github.com/catppuccin/nvim): the soft pastel accent palette that
  informed the muted teal, blue and mauve tones.

## License

[MIT](LICENSE)
