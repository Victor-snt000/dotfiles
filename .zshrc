# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git sudo extract command-not-found zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Prompt
eval "$(starship init zsh)"

# Ambiente
export QT_STYLE_OVERRIDE=kvantum
export TERMINAL=kitty
export PATH=/home/victor/.opencode/bin:$PATH

# Aliases
alias bleachbit-root="xhost +SI:localuser:root && sudo env DISPLAY=\$DISPLAY XAUTHORITY=\$HOME/.Xauthority WAYLAND_DISPLAY=\$WAYLAND_DISPLAY bleachbit"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
export PATH=~/.npm-global/bin:$PATH
