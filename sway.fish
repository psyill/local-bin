#!/usr/bin/fish

set --export XDG_CURRENT_DESKTOP sway
exec dbus-run-session sway --unsupported-gpu $argv
