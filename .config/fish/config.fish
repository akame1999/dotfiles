source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function dsave
    dconf dump / > ~/.config/dconf-settings.ini
    dot add -u
    dot commit -m "update dotfiles"
    dot push
end
