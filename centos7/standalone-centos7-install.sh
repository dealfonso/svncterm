#!/bin/bash
yum install git wget zlib-devel libvncserver-devel gnutls-devel libjpeg-devel -y
git clone https://github.com/dealfonso/svncterm.git
cd svncterm
wget https://raw.githubusercontent.com/proxmox/vncterm/master/glyphs.h
gcc -O2 -g -o svncterm svncterm.c -Wall -Wno-deprecated-declarations -D_GNU_SOURCE -lvncserver -lnsl -lpthread -lz -ljpeg -lutil -lgnutls
install -s -m 0755 svncterm /usr/bin/
