#!/usr/bin/bash
sudo cp ./mainmenu.cfg /boot/grub
sudo cp ./themes /boot/grub
sudo cp ./05_twomenus /etc/grub.d
sudo cp ./minegrub-update.service /etc/systemd/system
sudo systemctl enable minegrub-update.service
sudo chmod +x /etc/grub.d/05_twomenus
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo grub-editenv - set config_file=mainmenu.cfg
