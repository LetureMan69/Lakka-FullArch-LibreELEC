PKG_NAME="numero"
PKG_VERSION="19354c9bfe06a3e4fd936961ee8414b040a3d1c6"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/nbarkhina/numero"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TI-83 Emulator for Libretro"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v numero_libretro.so ${INSTALL}/usr/lib/libretro/
}
