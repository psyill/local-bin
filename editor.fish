#!/usr/bin/fish

switch $XDG_SESSION_TYPE
  case wayland x11
    nvim-qt --nofork $argv
  case tty '*'
    nvim $argv
end
