#!/bin/bash

# Disable eDP-1 display completely

# Check if eDP-1 is currently enabled
is_enabled=$(hyprctl monitors -j | jq -r '.[] | select(.name == "eDP-1") | .disabled')

if [ "$is_enabled" = "false" ]; then
    # If display is enabled, disable it
    hyprctl keyword monitor "eDP-1,disable"
    brightnessctl -sd asus::kbd_backlight set 0
else
    # If display is disabled, enable it
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
    brightnessctl -rd asus::kbd_backlight
fi
