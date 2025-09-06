#!/usr/bin/fish

#set --export WLR_NO_HARDWARE_CURSORS 1
set --export XDG_SESSION_DESKTOP "sway;wlroots"

# https://github.com/swaywm/sway/issues/595
set --export _JAVA_AWT_WM_NONREPARENTING 1

set --export QT_QPA_PLATFORM wayland-egl
set --export QT_QPA_PLATFORMTHEME qt5ct
set --export QT_WAYLAND_DISABLE_WINDOWDECORATION 1
set --erase QT_STYLE_OVERRIDE

set --export SDL_VIDEODRIVER wayland

exec dbus-run-session -- sway --unsupported-gpu $argv
