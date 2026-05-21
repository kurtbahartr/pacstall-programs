pkgname="steamos-gamescope-theme"
_gitdir="postcopy"
pkgver=0.0
pkgrel=1
pkgdesc="SteamOS theme for Steam Big Picture session (from HoloISO)"
arch=('any')
url="https://github.com/HoloISO/postcopy"
license=('MIT')
groups=()
pacdeps=('plymouth-theme-steamos')
source=("${_gitdir}::git+https://github.com/HoloISO/${_gitdir}#branch=rel")
md5sums=('SKIP')

pkgver() {
  cd "${srcdir}/${_gitdir}"

  # Git, no tags available
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "${srcdir}/${_gitdir}"
  mkdir -p "${pkgdir}/usr/share/icons"
  cp -rv "${srcdir}/${_gitdir}/usr/share/steamos" "${pkgdir}/usr/share/steamos"
  cp -rv "${srcdir}/${_gitdir}/usr/share/icons/steam" "${pkgdir}/usr/share/icons/steam"
}
