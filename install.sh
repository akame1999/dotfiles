#!/bin/bash
set -e

DOTFILES_REPO="git@github.com:akame1999/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "==> Cloning dotfiles..."
if [ -d "$DOTFILES_DIR" ]; then
  echo "    Dotfiles already exist, skipping clone..."
else
  git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

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

echo "==> Installing themes..."
mkdir -p ~/Graphite ~/.local/share/icons ~/.themes

# Graphite GTK theme
if [ ! -d ~/Graphite/Graphite-gtk-theme ]; then
  git clone https://github.com/vinceliuice/Graphite-gtk-theme.git ~/Graphite/Graphite-gtk-theme
fi
cd ~/Graphite/Graphite-gtk-theme && bash install.sh --dest ~/.themes

# MacTahoe icon theme
if [ ! -d ~/Graphite/MacTahoe-icon-theme ]; then
  git clone https://github.com/vinceliuice/MacTahoe-icon-theme.git ~/Graphite/MacTahoe-icon-theme
fi
cd ~/Graphite/MacTahoe-icon-theme && bash install.sh --dest ~/.local/share/icons

cd ~

echo "==> Restoring dconf..."
[ -f ~/.config/dconf-settings.ini ] && dconf load / < ~/.config/dconf-settings.ini

echo "==> Done!"
