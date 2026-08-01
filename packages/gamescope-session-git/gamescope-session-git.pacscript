pkgname=gamescope-session-git
_gitdir=gamescope-session
pkgver=339.b5c2d0d
pkgrel=2
pkgdesc="Common gamescope session files"
arch=('any')
url="https://github.com/OpenGamingCollective/${_gitdir}"
license=('MIT')
groups=()
depends=('gamescope')
makedepends=('git')
optdepends=('mangohud: for performance overlay')
install=gamescope-session.install
source=("${_gitdir}::git+${url}.git"
  "gamescope-session-plus")
md5sums=('SKIP'
  '4d4173d5c64c074795f9c6c0907e116f')

pkgver() {
  cd "${srcdir}/${_gitdir}"

  # Git, no tags available
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
  # Debian uses Dash as its default shell instead of Bash.
  # Because of this, the "declare" function used within the session
  # script returns not found and causes the session to crash.
  sed -i '/\#\!\/bin\/sh/ s/sh/bash/' "${srcdir}/${_gitdir}/usr/bin/gamescope-session-plus"
}
package() {
  cd "${srcdir}/${_gitdir}"
  cp -rv "${srcdir}/${_gitdir}/usr" "${pkgdir}/usr"

  # Debian installs `gamescope` into /usr/games.
  # Because of this, the executable cannot be found in default locations
  # which causes the session to crash.
  cp -v "${srcdir}/gamescope-session-plus" "${pkgdir}/usr/share/gamescope-session-plus/gamescope-session-plus"
  install -Dm644 "${srcdir}/${_gitdir}/LICENSE" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
