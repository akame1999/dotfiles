# lyoko's dotfiles

CachyOS dotfiles managed with a bare git repo. Restores my entire system in one command.

## Fresh install

```bash
bash <(curl -s https://raw.githubusercontent.com/akame1999/dotfiles/master/install.sh)
```

## What gets restored

- 220+ pacman packages + AUR packages
- Graphite Dark GTK theme
- MacTahoe Dark icon theme
- All GNOME settings, extensions, keybindings via dconf
- Fish, Ghostty, Micro, and all app configs

## Daily usage

```bash
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot add ~/.config/something
dot commit -m "what changed"
dot push
```

## Update GNOME settings

```bash
dconf dump / > ~/.config/dconf-settings.ini
dot add ~/.config/dconf-settings.ini
dot commit -m "update gnome settings"
dot push
```
