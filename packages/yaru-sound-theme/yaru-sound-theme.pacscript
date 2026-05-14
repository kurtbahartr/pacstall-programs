pkgname="yaru-sound-theme"
pkgver=26.04.5.1ubuntu
pkgdesc="Yaru default ubuntu sound theme"
arch=(any)
url="https://github.com/ubuntu/yaru"
license=('GPL-3.0')

makedepends=('meson' 'sassc' 'git')

source=("https://github.com/ubuntu/yaru/archive/${pkgver}.tar.gz")
sha256sums=('4e35b71d37aedb44302c811f63d325f4abd7699961f76f130323b361d4c6a7d7')

build() {
  # Flags ported from arch-meson.
  meson setup \
    --prefix /usr \
    --libexecdir libexec/"$(dpkg-architecture -qDEB_HOST_MULTIARCH)" \
    --sbindir sbin \
    --buildtype plain \
    --auto-features enabled \
    --wrap-mode nodownload \
    yaru-"${pkgver}" build
  meson configure build -Dubuntu-unity=true -Dxfwm4=true
  ninja -C build
}

_delete_all_from_pkgdir_except() {
  if [[ $1 != "sound-theme" ]]; then
    rm -r "${pkgdir}"/usr/share/sounds
  fi
  if [[ $1 != "gtk-theme" ]]; then
    rm -r "${pkgdir}"/usr/share/themes/Yaru{,-*}/{gtk-*,index.theme}
  fi
  if [[ $1 != "gtksourceview-theme" ]]; then
    rm -r "${pkgdir}"/usr/share/gtksourceview-*
    rm -r "${pkgdir}"/usr/share/*-gtksourceview-*
  fi
  if [[ $1 != "gnome-shell-theme" ]]; then
    rm "${pkgdir}"/usr/share/themes/Yaru{,-*}/gnome-shell
    rm -r "${pkgdir}"/usr/share/gnome-shell/theme/Yaru{,-*}
  fi
  if [[ $1 != "xfwm4-theme" ]]; then
    rm -r "${pkgdir}"/usr/share/themes/Yaru{,-*}/xfwm4
  fi
  if [[ $1 != "unity-theme" ]]; then
    rm -r "${pkgdir}"/usr/share/themes/Yaru{,-*}/unity
  fi
  if [[ $1 != "metacity-theme" ]]; then
    rm -r "${pkgdir}"/usr/share/themes/Yaru{,-*}/metacity-1
  fi
  if [[ $1 != "icon-theme" ]]; then
    rm -r "${pkgdir}"/usr/share/icons
  fi
  if [[ $1 != "session" ]]; then
    rm -r "${pkgdir}"/usr/share/{glib-2.0,xsessions,wayland-sessions}
    rm -r "${pkgdir}"/usr/share/gnome-shell/{extensions,modes}
  fi
  # Delete remaining empty directories:
  find "${pkgdir}" -type d -empty -not -path "*/DEBIAN" -delete
}

package() {
  DESTDIR="${pkgdir}" ninja -C build install >> install.log 2>&1
  _delete_all_from_pkgdir_except "sound-theme"
}
