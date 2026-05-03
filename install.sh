#!/bin/bash
set -e

DOTFILES_REPO="git@github.com:akame1999/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "==> Cloning dotfiles..."
git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"

function dot { git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" "$@"; }

dot checkout 2>/dev/null || {
  mkdir -p ~/.dotfiles-backup
  dot checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv "$HOME/{}" ~/.dotfiles-backup/{}
  dot checkout
}
dot config --local status.showUntrackedFiles no

echo "==> Installing packages..."
[ -f ~/.dotfiles-pkglist.txt ] && sudo pacman -S --needed - < ~/.dotfiles-pkglist.txt

echo "==> Installing AUR packages..."
[ -f ~/.config/aur-pkglist.txt ] && paru -S --needed - < ~/.config/aur-pkglist.txt

echo "==> Restoring dconf..."
[ -f ~/.config/dconf-settings.ini ] && dconf load / < ~/.config/dconf-settings.ini

echo "==> Done!"
