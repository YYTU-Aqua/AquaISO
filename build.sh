#!/bin/bash
mkdir work
ScD=$(cd $(dirname $0); pwd)
while getopts 's:r:d:n' arg; do
        case "${arg}" in
            s) cd work
			wget https://mirror.init7.net/gentoo//releases/amd64/autobuilds/20200823T214503Z/stage3-amd64-systemd-20200823T214503Z.tar.xz
			cd $ScD ;;
            r) sudo rm -r work ;;
            d) sudo tar -Jxvf $ScD/work/stage3-amd64-systemd-20200823T214503Z.tar.xz ;;
            n) echo_opts="-n -e"     ;;
        esac
    done
    shift $((OPTIND - 1))
#selectmirror
sudo mirrorselect -i -o >> work/etc/portage/make.conf
sudo mkdir --parents work/etc/portage/repos.conf
sudo cp -r work/usr/share/portage/config/repos.conf work/etc/portage/repos.conf/gentoo.conf
sudo cp --dereference /etc/resolv.conf work/etc/
#pacman source copy & build script
sudo cp system/build.sh work/build.sh
sudo cp -r source/* work/usr/src/
#copy pacman config
sudo cp -r system/pacman.d work/etc/
sudo cp system/pacman.conf work/etc/
#mount
sudo mount --types proc /proc work/proc
sudo mount --rbind /sys work/sys
sudo mount --make-rslave work/sys
sudo mount --rbind /dev work/dev
sudo mount --make-rslave work/dev
#chroot
echo "./build.sh" | sudo chroot $ScD/work
