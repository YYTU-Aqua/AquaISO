#!/bin/bash
#remove link pacman
rm /usr/share/bash-completion/completions/makepkg
rm /usr/share/bash-completion/completions/pacman-key
#sync gentoo server
emerge --sync
emerge asciidoc
#serect profile
emerge-webrsync
eselect profile set 2
eselect profile set default/linux/amd64/13.0/systemd
#build pacman
cd /usr/src/pacman-5.2.2
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
make
make install
#sync pacman
pacman -Sy
#time zone
echo "Asia/Japan" > /etc/timezone
echo "ja_JP.UTF-8 UTF-8" >/etc/locale.gen
locale-gen
