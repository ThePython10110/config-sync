if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Run numlockx
/usr/bin/numlockx on


xrandr --output DP-2 --left-of HDMI-1 --primary
picom &
lxpolkit &
gnome-keyring-daemon --start &
nitrogen --restore

while pgrep -a "Xorg"; do
    /usr/local/bin/dwm > /home/nolan/dwm.log
done
