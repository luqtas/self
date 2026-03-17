not installed: workrave openscad rpi-imager

# music plugins
sudo pacman -S dexed yoshimi-lv2 cardinal-lv2 padthv1-lv2 samplv1-lv2 synthv1-lv2 amsynth-lv2 
odin2-synthesizer-lv2 stochas-vst3 surge-xt-vst3 calf dragonfly-reverb-lv2 lsp-plugins-lv2 
distrho-ports-lv2 carla x42-plugins-lv2 zam-plugins-lv2 swh-plugins xjadeo harvid

# adding temporary midi-through ports
sudo modprobe -r snd-seq-dummy
sudo modprobe snd-seq-dummy ports=16

# running Ryan's Cosmos locally!
curl -fsSL https://bun.com/install | bash
cd Cosmos-Keyboards
make quickstart

# using GPG
# i think this is for unpacking... gotta discover the one to compress IF i can't do it with Thunar
# apparently not BUT we have other options! gotta figure out which is the best
tar -xvzf '/home/luqtas/Desktop/g54.tar.gz.gpg'
# importing key from Android
gpg --import key.pgp
# i don't know what this one made
gpg --decrypt '/home/luqtas/Desktop/g54.tar.gz.gpg'
# unencrypting
gpg -d '/home/luqtas/Desktop/g54.tar.gz.gpg' > /home/luqtas/Desktop/g52.tar.gz

# finding the IP
ip addr

# commiting to Github
git add .; git commit -m ""; git push origin main

# backup
'/home/luqtas/.scripts/rsync/backup.sh'
'/home/luqtas/.scripts/rsync/backup-shutdown.sh';history -c

sudo pacman -Rns # uninstalling an app
yay -R # uninstalling an yay app
pacman -Ss <package> # searching for packages
sudo pacman -S <package> # for installing packages
sudo pacman -Syu --disable-download-timeout # upgrading packages
yay -Syu --devel # upgrading yay packages (will watch for git changes too)
