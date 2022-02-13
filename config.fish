if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme gruvbox
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias clc "clear"
alias firefox="open -a /Applications/Firefox.app"
alias brave="open -a /Applications/Brave\ Browser.app"
# alias python "python3.9"
alias vi "/usr/local/bin/vim"
alias workon "tmux attach -t"
alias nv "neovide"

alias g git
alias gc "g commit -m"
alias ga "g add"
alias gph "g push"
alias gpl "g pull"
alias gj "g checkout"
alias gs "g status"
alias gd "g diff"

alias d "docker"
alias dls "docker container pa -a"
alias ds "docker container stop"
alias dils "docker images"

command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/Desktop/docker/run_hcdn $PATH
set -g JDTLS_HOME ~/.local/share/lsp/jdtls-server
set -x JAVA_HOME (/usr/libexec/java_home -v17)
# set -x PKG_CONFIG_PATH /usr/local/opt/libffi/lib/pkgconfig
set -x PKG_CONFIG_PATH /usr/local/lib/pkgconfig
# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

switch (uname)
  case Darwin
    source (dirname (status --current-filename))/config-osx.fish
  case Linux
    # Do nothing
  case '*'
    source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end

# fish_vi_key_bindings

bind -M insert \cf peco_select_history # Bind for peco select history to Ctrl+R
# bind -M insert \cr peco_change_directory # Bind for peco change directory to Ctrl+F
# bind \cr 'peco_select_history (commandline -b)'

# colorscript random

# STARSHIP
starship init fish | source

function rcd
    set tmpfile "/tmp/pwd-from-ranger"
    ranger --choosedir=$tmpfile $argv
    set rangerpwd (cat $tmpfile)
    if test "$PWD" != $rangerpwd
        cd $rangerpwd
    end
end

function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end
