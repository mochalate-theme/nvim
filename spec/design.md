# Design: mochalate.nvim

## Purpose

A cozy, dark-only Neovim colorscheme fusing [gruvbox](https://github.com/morhetz/gruvbox)'s
warm earthiness with [catppuccin](https://github.com/catppuccin/nvim)'s soft pastels, rendered
in mochalate tones for long coding sessions.

## Design principles

1. **Gruvbox finishing**: warm brown-black backgrounds, high-but-soft contrast, amber/yellow
   for numbers and constants, earthy red for keywords.
2. **Catppuccin influence**: muted teal for types, soft blue for info, mauve for debug:
   adds variety without breaking the warm theme.
3. **Mochalate tones**: burnt coral, terracotta, amber, sage: every color reads as a
   fallen-leaf palette.
4. **Long sessions**: no pure white text (`#e8d5c4` max), muted comments, blended diagnostic
   backgrounds (12% alpha), no harsh neon.

## Palette

### Backgrounds

| Key          | Value     | Notes                        |
| ------------ | --------- | ---------------------------- |
| `bg`         | `#1c1815` | warm brown-black             |
| `bg_alt`     | `#242019` | slightly lighter             |
| `bg_menu`    | `#2c261e` | floats / menus               |
| `bg_line`    | `#342e25` | line highlight               |
| `bg_widget`  | `#38322a` | widget hover                 |
| `bg_select`  | `#5c4030` | terracotta selection         |
| `bg_match`   | `#4a3428` | dimmed search match          |
| `border`     | `#3e3630` | window separators            |
| `border_alt` | `#4e463e` | float borders                |

### Foregrounds

| Key        | Value     | Notes                       |
| ---------- | --------- | --------------------------- |
| `fg`       | `#e8d5c4` | warm cream (not pure white) |
| `fg_alt`   | `#dfcbb8` | emphasized                  |
| `fg_dim`   | `#a89278` | secondary                   |
| `fg_muted` | `#7a6850` | line numbers, whitespace    |
| `white`    | `#f5ead8` | text on accent backgrounds  |

### Accent

| Key          | Value     | Notes            |
| ------------ | --------- | ---------------- |
| `accent`     | `#e8a050` | mochalate amber     |
| `accent_dim` | `#d08840` | dimmed amber     |
| `accent_alt` | `#f0b870` | lighter amber    |

### Syntax

| Key        | Value     | Notes                          |
| ---------- | --------- | ------------------------------ |
| `comment`  | `#8a7560` | warm muted brown               |
| `string`   | `#a8b878` | sage / olive green             |
| `regex`    | `#d8a050` | amber                          |
| `number`   | `#d8a050` | amber                          |
| `keyword`  | `#d06850` | burnt coral (softer gruvbox red)|
| `func`     | `#e0a060` | warm amber-orange              |
| `type`     | `#78a890` | muted teal-sage                |
| `variable` | `#e8d5c4` | plain fg                       |
| `constant` | `#d8a050` | amber                          |
| `operator` | `#d06850` | burnt coral                    |
| `preproc`  | `#d06850` | burnt coral control flow       |
| `annotation` | `#c88060` | terracotta                   |
| `param`    | `#c88060` | terracotta                     |
| `member`   | `#e0a060` | warm orange                    |
| `tag`      | `#c0a860` | golden                         |
| `attr`     | `#d8a050` | amber                          |
| `module`   | `#78a890` | sage teal                      |
| `macro`    | `#d07850` | burnt sienna                   |

### Diagnostics

| Key     | Value     | Notes                  |
| ------- | --------- | ---------------------- |
| `err`   | `#e06058` | warm red               |
| `warn`  | `#d8a050` | amber                  |
| `info`  | `#88a0c0` | muted blue             |
| `hint`  | `#78a890` | sage teal              |
| `ok`    | `#90b070` | warm green             |
| `debug` | `#b890c0` | muted mauve            |

### Diff

| Key           | Value     | Notes                    |
| ------------- | --------- | ------------------------ |
| `diff_add`    | `#253028` | dark sage background     |
| `diff_add_fg` | `#90b070` | warm green               |
| `diff_del`    | `#352525` | dark red-brown           |
| `diff_del_fg` | `#d88078` | muted coral              |
| `diff_chg`    | `#303025` | dark amber               |
| `diff_chg_fg` | `#d8a050` | amber                    |
| `diff_text`   | `#403828` | changed text background  |

## Token → palette mapping

Every group module references semantic palette keys only; no group hardcodes a hex value.
This keeps the palette swappable (relevant if a light variant is ever added).

## Architecture

Same layered override pipeline as code-2026:

base palette → `palette` → derived colors → `on_colors` → highlight groups
→ `on_highlights` → `highlights`

### Simplifications vs code-2026

- No `background` option (dark only)
- No OS detection (`detect_bg`) or sync (`background = 'auto'` / `'sync'`)
- Single palette table (no `M.dark` / `M.light` split)
- Single `colors/mochalate.lua` entry point

## Groups covered

- editor: ~92 core UI groups
- syntax: ~40 legacy Vim syntax groups
- treesitter: ~101 `@...` captures
- lsp: ~69 semantic token + diagnostic groups
- plugins: 28 keyed blocks (~371 groups): gitsigns, telescope, fzf_lua, snacks, blink, cmp,
  bufferline, which_key, notify, noice, neo_tree, nvim_tree, oil, indent_blankline, mini,
  lazy, mason, trouble, flash, illuminate, treesitter_context, rainbow, dap, navic,
  dashboard, yanky, fidget, markdown

Total: ~666 groups.
