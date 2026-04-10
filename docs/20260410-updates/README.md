# 2026-04-10 Update Notes

First upstream rebase since fork. Summary of what happened and what was fixed.

## Issues encountered

### 1. `base.default_colorscheme` → `vim.g.default_colorscheme`

Upstream refactored the colorscheme global from `base.default_colorscheme` to
`vim.g.default_colorscheme`. The fork still used the old form in `1-options.lua`,
causing it to crash on line 7 before `vim.g.big_file` was set — which then caused
a cascade failure in `plugins/4-dev.lua`.

**Fix:** `lua/base/1-options.lua` line 7 updated to use `vim.g.default_colorscheme`.

### 2. Lazy plugin update failures (12 plugins)

Several plugins had local modifications (generated doc files, lockfiles, submodule
drift) that blocked `git checkout` during `:Lazy update`.

**Fix:** Run `reset-plugins.sh` to hard reset all affected plugins, then retry `:Lazy update`.

**LuaSnip specifically** had a deeper submodule corruption (`fatal: not a git repository: ../../.git/modules/deps/jsregexp`). `git reset --hard` had no effect. Resolution:
1. `cd ~/.local/share/nvim/lazy/LuaSnip && git reset --hard`
2. Open `:Lazy update` — it will error about untracked files/submodule
3. Press `x` to remove LuaSnip, then `I` to reinstall it fresh

## Scripts

### `reset-plugins.sh`

Hard resets the 12 plugins that failed during the 2026-04-10 `:Lazy update`:

```
lsp_signature.nvim  LuaSnip  neo-tree.nvim  noice.nvim  none-ls.nvim
nvim-treesitter  nvim-web-devicons  one-small-step-for-vimkind
overseer.nvim  telescope.nvim  vim-matchup  zen-mode.nvim
```

```sh
./docs/20260410-updates/reset-plugins.sh
```

Each plugin gets `git reset --hard`. `lsp_signature.nvim` gets `git clean -fd`
(untracked file). `LuaSnip` also gets `git submodule update --init --recursive`
(submodule drift).

## Clean (unused plugins removed)

These plugins appeared in the `:Lazy` Clean section and were removed upstream:
`bufferline.nvim`, `image.nvim`, `lua-async-await`, `nvim-java-*`,
`SchemaStore.nvim`, `ts-comments.nvim`. Press `X` in the lazy UI to clean them.
