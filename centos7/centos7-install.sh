#!/bin/bash
yum install git wget zlib-devel libvncserver-devel gnutls-devel libjpeg-devel -y
yum groupinstall -y "Development tools"
wget https://raw.githubusercontent.com/proxmox/vncterm/master/glyphs.h
cp ../svncterm.c .
cp ../svncterm.h .
gcc -O2 -g -o svncterm svncterm.c -Wall -Wno-deprecated-declarations -D_GNU_SOURCE -lvncserver -lnsl -lpthread -lz -ljpeg -lutil -lgnutls
install -s -m 0755 svncterm /usr/bin/
