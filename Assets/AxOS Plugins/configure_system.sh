#!/bin/bash

# Exit on error and enable pipefail
set -e
set -o pipefail

# Configuration
REPO_BASE="https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins"
TEMP_DIR=$(mktemp -d)
WALLPAPER_DIR="/usr/share/sleex/wallpaper"
USER_WALLPAPER_DIR="$HOME/.sleex/wallpapers"

# Function for safe file operations with backup
safe_replace() {
    local source_url="$1"
    local dest_path="$2"
    local backup_ext=".bak.$(date +%Y%m%d_%H%M%S)"

    # Create directory if it doesn't exist
    sudo mkdir -p "$(dirname "$dest_path")"

    # Backup original file if it exists
    if [ -f "$dest_path" ]; then
        sudo mv "$dest_path" "${dest_path}${backup_ext}"
        echo "Backed up $dest_path to ${dest_path}${backup_ext}"
    fi

    # Download and replace
    echo "Downloading $dest_path..."
    sudo curl -f -L "$source_url" -o "$dest_path" || {
        echo "Error downloading $source_url"
        # Restore backup if download fails
        if [ -f "${dest_path}${backup_ext}" ]; then
            sudo mv "${dest_path}${backup_ext}" "$dest_path"
        fi
        return 1
    }
}

# Function to check command availability
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is required but not installed"
        exit 1
    fi
}

# Check required commands
check_command curl
check_command 7z

# Inject Custom Weather
echo "=== Configuring Weather ==="
safe_replace "${REPO_BASE}/Weather.qml" "/usr/share/sleex/services/Weather.qml"
sudo sh -c 'echo "Port-Shepstone" > /usr/share/sleex/services/Weather.txt'

# Inject GitHub Username
echo "=== Configuring Dashboard ==="
safe_replace "${REPO_BASE}/HomeWidgetGroup.qml" "/usr/share/sleex/modules/dashboard/HomeWidgetGroup.qml"

# Inject Hypr Configurations
echo "=== Configuring Hypr ==="
safe_replace "${REPO_BASE}/apps.conf" "$HOME/.config/hypr/apps.conf"
safe_replace "${REPO_BASE}/execs.conf" "$HOME/.config/hypr/hyprland/execs.conf"
safe_replace "${REPO_BASE}/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
safe_replace "${REPO_BASE}/keybinds.conf" "$HOME/.config/hypr/hyprland/keybinds.conf"

# Inject Switchwall
echo "=== Configuring Switchwall ==="
safe_replace "${REPO_BASE}/switchwall.sh" "/usr/share/sleex/scripts/colors/switchwall.sh"

# Inject Wallpapers
echo "=== Configuring Wallpapers ==="
# Create wallpaper directories
sudo mkdir -p "$WALLPAPER_DIR" "$USER_WALLPAPER_DIR"
sudo chmod 755 "$WALLPAPER_DIR" "$USER_WALLPAPER_DIR"

# Download wallpapers to temp directory first
cd "$TEMP_DIR"
echo "Downloading wallpapers..."
curl -f -L "${REPO_BASE}/wallpapers.zip.001" -o "wallpapers.zip.001"
curl -f -L "${REPO_BASE}/wallpapers.zip.002" -o "wallpapers.zip.002"

# Extract and move to final location
echo "Extracting wallpapers..."
7z x "wallpapers.zip.001" -oextracted_wallpapers

# Clean existing wallpapers and copy new ones
sudo rm -rf "$WALLPAPER_DIR"/*
sudo cp -ra extracted_wallpapers/* "$WALLPAPER_DIR/"
sudo rm -rf "$USER_WALLPAPER_DIR"/*
sudo cp -ra extracted_wallpapers/* "$USER_WALLPAPER_DIR/"

# Cleanup
cd -
rm -rf "$TEMP_DIR"

echo "=== Configuration complete ==="
echo "Note: Original files were backed up with .bak.timestamp extension"
