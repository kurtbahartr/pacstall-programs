pkgname="plymouth-theme-steamos"
_gitdir="postcopy"
pkgver="0.0"
pkgdesc="Simple device-branded SteamOS splash screen (from HoloISO)"
arch=('any')
url="https://github.com/HoloISO/postcopy"
license=('MIT')
groups=()
depends=('plymouth')
source=("${_gitdir}::git+https://github.com/HoloISO/${_gitdir}#branch=rel")
md5sums=('SKIP')

pkgver() {
  cd "${srcdir}/${_gitdir}"

  # Git, no tags available
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "${srcdir}/${_gitdir}"
  mkdir -p "${pkgdir}/usr/share"
  cp -rv "${srcdir}/${_gitdir}/usr/share/plymouth" "${pkgdir}/usr/share/plymouth"

  # Workaround for blank splash
  ln -s /usr/share/plymouth/themes/steamos/steamos-jupiter.png "${pkgdir}/usr/share/plymouth/themes/steamos/steamos.png"
}
