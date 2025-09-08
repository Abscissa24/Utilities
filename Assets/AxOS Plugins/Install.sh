#Inject Custom Weather
sudo mv /usr/share/sleex/services/Weather.qml /usr/share/sleex/services/Weather.qml.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/Weather.qml" -o /usr/share/sleex/services/Weather.qml
sudo sh -c 'echo "Port-Shepstone" > /usr/share/sleex/services/Weather.txt'

#Inject GitHub Username
sudo mv /usr/share/sleex/modules/dashboard/HomeWidgetGroup.qml /usr/share/sleex/modules/dashboard/HomeWidgetGroup.qml.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/HomeWidgetGroup.qml" -o /usr/share/sleex/modules/dashboard/HomeWidgetGroup.qml

#Inject Apps
sudo mv ~/.config/hypr/apps.conf ~/.config/hypr/apps.conf.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/apps.conf" -o ~/.config/hypr/apps.conf

#Inject Execs
sudo mv ~/.config/hypr/hyprland/execs.conf ~/.config/hypr/hyprland/execs.conf.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/execs.conf" -o ~/.config/hypr/hyprland/execs.conf

#Inject Hypridle
sudo mv ~/.config/hypr/hypridle.conf ~/.config/hypr/hypridle.conf.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/hypridle.conf" -o ~/.config/hypr/hypridle.conf

#Inject Keybinds
sudo mv ~/.config/hypr/hyprland/keybinds.conf ~/.config/hypr/hyprland/keybinds.conf.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/keybinds.conf" -o ~/.config/hypr/hyprland/keybinds.conf

#Inject Switchwall
sudo mv /usr/share/sleex/scripts/colors/switchwall.sh /usr/share/sleex/scripts/colors/switchwall.sh.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/switchwall.sh" -o /usr/share/sleex/scripts/colors/switchwall.sh

#Inject Wallpapers
sudo rm -rf /usr/share/sleex/wallpaper
sudo mkdir -p /usr/share/sleex/wallpaper
sudo chmod 755 /usr/share/sleex/wallpaper
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/wallpapers.zip.001" -o /usr/share/sleex/wallpaper/wallpapers.zip.001
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/AxOS%20Plugins/wallpapers.zip.002" -o /usr/share/sleex/wallpaper/wallpapers.zip.002
cd /usr/share/sleex/wallpaper
sudo 7z x /usr/share/sleex/wallpaper/wallpapers.zip.001
sudo rm /usr/share/sleex/wallpaper/wallpapers.zip.001 /usr/share/sleex/wallpaper/wallpapers.zip.002
sudo rm -rf ~/.sleex/wallpapers
sudo mkdir -p ~/.sleex/wallpapers
sudo chmod 755 ~/.sleex/wallpapers
sudo cp -ra /usr/share/sleex/wallpaper/ ~/.sleex/wallpapers
