#!BuildTag: units
#
# docker pull registry.opensuse.org/home/pgajdos/containers/units:latest
#                                   ^projectname        ^repos     ^ build tag
FROM opensuse/tumbleweed:latest

ARG UNITS_VERSION=2.21

RUN zypper --non-interactive in bison ncurses-devel tack wget tar gzip gcc make && \
    zypper clean && \
    wget http://ftp.gnu.org/gnu/units/units-${UNITS_VERSION}.tar.gz && \
    tar -xf units-${UNITS_VERSION}.tar.gz && \
    cd units-${UNITS_VERSION} && \
    export LDFLAGS="-pie" && \
    export 'CFLAGS=-O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector-strong -funwind-tables -fasynchronous-unwind-tables -fstack-clash-protection -Werror=return-type -flto=auto -g -fPIE' && \
    ls . && \
    /bin/bash ./configure --host=x86_64-suse-linux-gnu --build=x86_64-suse-linux-gnu --program-prefix= --disable-dependency-tracking --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man --infodir=/usr/share/info --disable-dependency-tracking && \
    /usr/bin/make -O -j8 V=1 VERBOSE=1 && \
    make install DESTDIR=/ && \
    /usr/bin/make -O -j8 V=1 VERBOSE=1 check

ENTRYPOINT ["units"]
