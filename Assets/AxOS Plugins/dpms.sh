#!/bin/bash

# Check if external monitor (DP-1) is connected
external_monitor_connected=$(hyprctl monitors -j | jq -r '.[] | select(.name == "DP-1") | .name')

if [ "$external_monitor_connected" = "DP-1" ]; then
    # External monitor is connected - toggle eDP-1 display
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
else
    # No external monitor detected - toggle DPMS instead
    dpms_status=$(hyprctl monitors -j | jq -r '.[] | select(.name == "eDP-1") | .dpmsStatus')

    if [ "$dpms_status" = "true" ]; then
        # If DPMS is on, turn it off (wake display)
        hyprctl dispatch dpms off eDP-1
        brightnessctl -sd asus::kbd_backlight set 0
    else
        # If DPMS is off, turn it on (sleep display)
        hyprctl dispatch dpms on eDP-1
        brightnessctl -rd asus::kbd_backlight
    fi
fi
