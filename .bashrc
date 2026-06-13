#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \w]\$ '
PS1='[\[\033[01;93m\]\u@\h\[\033[00m\]]:\[\033[01;35m\]\w\[\033[00m\]\$ '

export PATH="$HOME/.local/bin:$PATH"

# dark
alias dark='gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark \
&& gsettings set org.gnome.desktop.interface color-scheme prefer-dark'

# light
alias light='gsettings set org.gnome.desktop.interface gtk-theme Adwaita \
&& gsettings set org.gnome.desktop.interface color-scheme prefer-light'

# ranger
# alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
export EDITOR="nvim"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

eval "$(fzf --bash)"
# source /usr/share/fzf/key-bindings.bash
# source /usr/share/fzf/completion.bash
alias inv='nvim $(fzf --preview="bat --color=always {}")'
. "$HOME/.cargo/env"

alias ftb='flatpak run --env=ELECTRON_OZONE_PLATFORM_HINT=x11 dev.ftb.ftb-app'

alias cpc='wl-copy <'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/antoine/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/antoine/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/antoine/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/antoine/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# NixOS config remote editing
alias mount-nixos='sshfs -o reconnect,IdentityFile=~/.ssh/homelab-002 antoine@192.168.1.15:/home/antoine/.config/nixos/ ~/code/homelab-nixos'
alias unmount-nixos='fusermount -u ~/code/homelab-nixos'
