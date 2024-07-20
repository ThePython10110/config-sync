xrandr --output DP-2 --left-of HDMI-1 --primary
picom &
lxpolkit &
gnome-keyring-daemon --start &
nitrogen --restore

while pgrep -a "Xorg"; do
    /usr/local/bin/dwm > /home/nolan/dwm.log
done
