
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Connexions caméras
alias inpixal='sudo nmcli connection up "InPixal"'
alias cambur='sudo nmcli connection up "CamBur"'

alias rmpyc='find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf'
alias slt="ttysolitaire --no-background-color"

# Timer command
alias timr="timr-tui --work '25:00' --pause '05:00' \
    --vim on \
    --reset \
    --notification on \
    --auto-switch \
"
