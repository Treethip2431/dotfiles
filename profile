# ~/.config/profile contains common configuration for bourne compatible shells.
# vim: ft=sh

# User Information
: ${EMAIL:="will@willnorris.com"}

source "${HOME}/.config/shell/_base.sh"

if [ -d "${XDG_CONFIG_HOME}/shell" ]; then
  for i in ${XDG_CONFIG_HOME}/shell/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

# include ~/.local/bin in PATH late to give precedence
if [ -d "$HOME/.local/bin" ]; then
    pathadd "$HOME/.local/bin"
fi
