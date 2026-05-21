pkgname=gamescope-session-steam-git
_gitdir=gamescope-session-steam
pkgver=10.1a3fdb7
pkgrel=1
pkgdesc="Steam Big Picture session based on gamescope"
arch=('any')
url="https://github.com/OpenGamingCollective/gamescope-session-steam"
license=('MIT')
groups=()
pacdeps=('gamescope-session-git' 'steamos-gamescope-theme')
makedepends=('git')
source=("${_gitdir}::git+https://github.com/OpenGamingCollective/${_gitdir}.git"
  "jupiter-biosupdate"
  "steamos-select-branch"
  "steamos-session-select"
  "steamos-update")
md5sums=('SKIP'
  'bde4f75812d1b7d2525ac48db92a37b1'
  '447a60f602a68f47d6c11edc462bbdd0'
  '74f3870f9b69cdceaadeddf41270d74d'
  '29a816f2e54d554ab0f7e3e20912719c')

pkgver() {
  cd "${srcdir}/${_gitdir}"

  # Git, no tags available
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "${srcdir}/${_gitdir}"
  cp -rv "${srcdir}/${_gitdir}/usr" "${pkgdir}/usr"

  # Various script replacements for non-SteamOS machines
  for i in jupiter-biosupdate steamos-select-branch steamos-session-select steamos-update; do
    install -vDm755 "${srcdir}/${i}" "${pkgdir}/usr/bin/${i}"
  done

  # Use our global cursor theme instead of user-defined one in their
  # home directory
  sed -i 's/\$.HOME.\/\.local\/share\/Steam\/tenfoot\/resource\/images\/cursors\/arrow\.png/\/usr\/share\/steamos\/steamos-cursor.png/' "${pkgdir}/usr/share/gamescope-session-plus/sessions.d/steam"

  # font workaround for initial big picture mode startup
  mkdir -p "${pkgdir}/usr/share/fonts/truetype/ttf-dejavu"
  ln -s "/usr/share/fonts/TTF/DejaVuSans.ttf" "${pkgdir}/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf"
}
