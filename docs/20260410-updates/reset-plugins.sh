#!/usr/bin/env bash
# Hard reset lazy-managed plugins that have local changes blocking update.
# Run this when :Lazy update fails with "local changes" or submodule errors.
set -e

BASE=~/.local/share/nvim/lazy

echo "==> lsp_signature.nvim (untracked doc/tags)"
(cd "$BASE/lsp_signature.nvim" && git clean -fd)

echo "==> LuaSnip (submodule out of date)"
(cd "$BASE/LuaSnip" && git reset --hard && git submodule update --init --recursive)

echo "==> Resetting plugins with local changes..."
for plugin in \
  neo-tree.nvim \
  noice.nvim \
  none-ls.nvim \
  nvim-treesitter \
  nvim-web-devicons \
  one-small-step-for-vimkind \
  overseer.nvim \
  telescope.nvim \
  vim-matchup \
  zen-mode.nvim
do
  echo "    $plugin"
  (cd "$BASE/$plugin" && git reset --hard)
done

echo ""
echo "Done. Go back to nvim and press U to retry the update."
