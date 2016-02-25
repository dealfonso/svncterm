PACKAGE=svncterm
# Note: also change version in debian/control and debian/changelog
VERSION=1.2
PACKAGERELEASE=1
ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH)
CDATE:=$(shell date +%F)

DEB=${PACKAGE}_${VERSION}-${PACKAGERELEASE}_${ARCH}.deb

all: svncterm

glyphs.h: genfont
	./genfont > glyphs.h

genfont: genfont.c
	gcc -g -O2 -o $@ genfont.c -Wall -D_GNU_SOURCE -lz

svncterm: svncterm.c glyphs.h
	gcc -O2 -g -o $@ svncterm.c -Wall -Wno-deprecated-declarations -D_GNU_SOURCE -lvncserver -lnsl -lpthread -lz -ljpeg -lutil -lgnutls

.PHONY: install
install: svncterm svncterm.1
	mkdir -p ${DESTDIR}/usr/share/doc/${PACKAGE}
	mkdir -p ${DESTDIR}/usr/share/man/man1
	mkdir -p ${DESTDIR}/usr/bin
	install -s -m 0755 svncterm ${DESTDIR}/usr/bin

.PHONY: dinstall
dinstall: ${DEB}
	dpkg -i ${DEB}

svncterm.1: svncterm.pod
	rm -f $@
	pod2man -n $< -s 1 -r ${VERSION} <$< >$@

.PHONY: deb
${DEB} deb:
	make clean
	rm -rf dest
	mkdir dest
	make DESTDIR=`pwd`/dest install
	install -d -m 0755 dest/DEBIAN
	install -m 0644 debian/control dest/DEBIAN
	echo "Architecture: ${ARCH}" >>dest/DEBIAN/control
	install -m 0644 debian/conffiles dest/DEBIAN
	install -m 0644 copyright dest/usr/share/doc/${PACKAGE}
	install -m 0644 svncterm.1 dest/usr/share/man/man1
	install -m 0644 debian/changelog.Debian dest/usr/share/doc/${PACKAGE}
	gzip --best dest/usr/share/man/*/*
	gzip --best dest/usr/share/doc/${PACKAGE}/changelog.Debian
	dpkg-deb --build dest
	mv dest.deb ${DEB}
	rm -rf dest
	lintian ${DEB}	

.PHONY: clean
clean:
	rm -rf svncterm svncterm.1 svncterm_*.deb

.PHONY: distclean
distclean: clean
	rm -f genfont