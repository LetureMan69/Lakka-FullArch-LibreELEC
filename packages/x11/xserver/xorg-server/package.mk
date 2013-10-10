################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="xorg-server"
PKG_VERSION="1.14.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/xserver/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS="libpciaccess libX11 libXfont libdrm openssl freetype pixman systemd xorg-launch-helper"
PKG_BUILD_DEPENDS_TARGET="toolchain util-macros font-util fontsproto randrproto recordproto renderproto dri2proto fixesproto damageproto scrnsaverproto videoproto inputproto xf86dgaproto xf86vidmodeproto xf86driproto xf86miscproto glproto libpciaccess libX11 libXfont libxkbfile libdrm openssl freetype pixman fontsproto systemd"
PKG_PRIORITY="optional"
PKG_SECTION="x11/xserver"
PKG_SHORTDESC="xorg-server: The Xorg X server"
PKG_LONGDESC="Xorg is a full featured X server that was originally designed for UNIX and UNIX-like operating systems running on Intel x86 hardware."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

# Additional packages we need for using xorg-server:
# Fonts
  PKG_DEPENDS="$PKG_DEPENDS encodings font-xfree86-type1 font-bitstream-type1 font-misc-misc"

# Server
  PKG_DEPENDS="$PKG_DEPENDS xkeyboard-config xkbcomp"

# Tools
  PKG_DEPENDS="$PKG_DEPENDS pciutils xrandr setxkbmap"

if [ -n "$WINDOWMANAGER" -a "$WINDOWMANAGER" != "none" ]; then
  PKG_DEPENDS="$PKG_DEPENDS $WINDOWMANAGER"
fi

get_graphicdrivers
# Drivers
  PKG_DEPENDS="$PKG_DEPENDS xf86-input-evdev"
  for drv in $XORG_DRIVERS; do
    PKG_DEPENDS="$PKG_DEPENDS xf86-video-$drv"
  done

# Drivers
  PKG_DEPENDS="$PKG_DEPENDS xf86-input-evdev"
  for drv in $XORG_DRIVERS; do
    PKG_DEPENDS="$PKG_DEPENDS xf86-video-$drv"
  done

if [ "$COMPOSITE_SUPPORT" = "yes" ]; then
  PKG_DEPENDS="$PKG_DEPENDS libXcomposite"
  PKG_BUILD_DEPENDS_TARGET="$PKG_BUILD_DEPENDS_TARGET libXcomposite"
  XORG_COMPOSITE="--enable-composite"
else
  XORG_COMPOSITE="--disable-composite"
fi

if [ "$XINERAMA_SUPPORT" = "yes" ]; then
  PKG_DEPENDS="$PKG_DEPENDS libXinerama"
  PKG_BUILD_DEPENDS_TARGET="$PKG_BUILD_DEPENDS_TARGET libXinerama"
  XORG_XINERAMA="--enable-xinerama"
else
  XORG_XINERAMA="--disable-xinerama"
fi

if [ "$OPENGL" = "Mesa" ]; then
  PKG_DEPENDS="$PKG_DEPENDS Mesa glu"
  PKG_BUILD_DEPENDS_TARGET="$PKG_BUILD_DEPENDS_TARGET Mesa glu"
  XORG_MESA="--enable-glx --enable-dri"
else
  XORG_MESA="--disable-glx --disable-dri"
fi

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
                           --disable-silent-rules \
                           --disable-strict-compilation \
                           --enable-largefile \
                           --enable-visibility \
                           --disable-unit-tests \
                           --disable-sparkle \
                           --disable-install-libxf86config \
                           --disable-xselinux \
                           --enable-aiglx \
                           --enable-glx-tls \
                           --enable-registry \
                           $XORG_COMPOSITE \
                           $XORG_XINERAMA \
                           --enable-mitshm \
                           --disable-xres \
                           --enable-record \
                           --enable-xv \
                           --disable-xvmc \
                           --enable-dga \
                           --disable-screensaver \
                           --disable-xdmcp \
                           --disable-xdm-auth-1 \
                           $XORG_MESA \
                           --enable-dri2 \
                           --enable-xf86vidmode \
                           --disable-xace \
                           --disable-xcsecurity \
                           --disable-tslib \
                           --enable-dbe \
                           --disable-xf86bigfont \
                           --enable-dpms \
                           --enable-config-udev \
                           --disable-config-dbus \
                           --disable-config-hal \
                           --enable-xfree86-utils \
                           --enable-vgahw \
                           --enable-vbe \
                           --enable-int10-module \
                           --disable-windowswm \
                           --enable-libdrm \
                           --enable-xorg \
                           --disable-dmx \
                           --disable-xvfb \
                           --disable-xnest \
                           --disable-xquartz \
                           --disable-standalone-xpbproxy \
                           --disable-xwin \
                           --disable-kdrive \
                           --disable-xephyr \
                           --disable-xfake \
                           --disable-xfbdev \
                           --enable-unix-transport \
                           --disable-tcp-transport \
                           --disable-local-transport \
                           --disable-install-setuid \
                           --disable-secure-rpc \
                           --disable-docs \
                           --disable-devel-docs \
                           --with-int10=x86emu \
                           --disable-ipv6 \
                           --with-gnu-ld \
                           --with-sha1=libcrypto \
                           --with-os-vendor=OpenELEC.tv \
                           --with-module-dir=$XORG_PATH_MODULES \
                           --with-xkb-path=$XORG_PATH_XKB \
                           --with-xkb-output=/var/cache/xkb \
                           --with-log-dir=/var/log \
                           --with-fontrootdir=/usr/share/fonts \
                           --with-default-font-path=/usr/share/fonts/misc,built-ins \
                           --with-serverconfig-path=/usr/lib/xserver \
                           --without-xmlto \
                           --without-fop"

pre_configure_target() {
# hack to prevent a build error
  CFLAGS=`echo $CFLAGS | sed -e "s|-O3|-O2|" -e "s|-Ofast|-O2|"`
  LDFLAGS=`echo $LDFLAGS | sed -e "s|-O3|-O2|" -e "s|-Ofast|-O2|"`
}

post_makeinstall_target() {
  rm -rf $INSTALL/var/cache/xkb

  mkdir -p $INSTALL/usr/lib/xorg
    cp -P $PKG_DIR/scripts/xorg-configure $INSTALL/usr/lib/xorg

  if [ -f $INSTALL/usr/lib/xorg/modules/extensions/libglx.so ]; then
    mv $INSTALL/usr/lib/xorg/modules/extensions/libglx.so \
       $INSTALL/usr/lib/xorg/modules/extensions/libglx_mesa.so # rename for cooperate with nvidia drivers
    ln -sf /var/lib/libglx.so $INSTALL/usr/lib/xorg/modules/extensions/libglx.so
  fi

  mkdir -p $INSTALL/etc/X11
    if [ -f $PROJECT_DIR/$PROJECT/xorg/xorg.conf ]; then
      cp $PROJECT_DIR/$PROJECT/xorg/xorg.conf $INSTALL/etc/X11
    elif [ -f $PKG_DIR/config/xorg.conf ]; then
      cp $PKG_DIR/config/xorg.conf $INSTALL/etc/X11
    fi

  if [ ! "$DEVTOOLS" = yes ]; then
    rm -rf $INSTALL/usr/bin/cvt
    rm -rf $INSTALL/usr/bin/gtf
  fi
}

post_install() {
  enable_service xorg.service
}
