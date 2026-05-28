pkgname=gdm-settings
pkgdesc="A settings app for Gnome's Login Manager, GDM"
url="https://gdm-settings.github.io"
pkgver=5.0
pkgrel=1
arch=(any)
license=("AGPL-3.0")
depends=(gdm3 python3-gi gettext libpolkit-gobject-1-0)
makedepends=(libadwaita-1-dev libglib2.0-dev python-gi-dev libpolkit-gobject-1-dev meson blueprint-compiler python3-gi gobject-introspection)
checkdepends=(appstream)
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/gdm-settings/gdm-settings/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=(adfc33250589217531e9fa679cad03cbe7c845b39fb99fcc226329453ce0ac40)

build() {
  meson setup \
    --prefix /usr \
    --libexecdir libexec/"$(dpkg-architecture -qDEB_HOST_MULTIARCH)" \
    --sbindir sbin \
    --buildtype plain \
    --auto-features enabled \
    --wrap-mode nodownload \
    -D b_pie=true \
    -D python.bytecompile=1 \
    --buildtype=release "${srcdir}/${pkgname}-${pkgver}" build
  meson compile -C build
}

check() {
  meson test -C build --print-errorlogs
}

package() {
  meson install -C build --destdir="${pkgdir}"
}
