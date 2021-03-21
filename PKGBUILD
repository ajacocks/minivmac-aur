# Maintainer: LIN Ruohshoei <lin dot ruohshoei plus archlinux at gmail dot com>
# Contributor: Eric DeStefano <eric at ericdestefano dot com>
# Contributor: Iñigo Alvarez <alvarezviu@gmail.com>
# Contributor: William Termini <aur@termini.me>
# Contributor: Alexander Jacocks <alexander@redhat.com>
pkgname=minivmac
pkgver=36.04
pkgrel=2
pkgdesc="a miniature early Macintosh emulator"
arch=('x86_64')
url="https://www.gryphel.com/c/minivmac/"
_url_d="https://www.gryphel.com/d/minivmac"
_models="128K 512Ke Plus SE Classic SEFDHD II"
license=('GPL2')
depends=('libx11')
source=(${pkgname}-${pkgver}.tgz::"${_url_d}/${pkgname}-${pkgver}/$pkgname-$pkgver.src.tgz"
        blanks-1.1.zip::"${_url_d}/extras/blanks/blanks-1.1.zip"
        clipin-1.1.0.zip::"${_url_d}/extras/clipin/clipin-1.1.0.zip"
        clipout-1.1.0.zip::"${_url_d}/extras/clipout/clipout-1.1.0.zip"
        dafkey-1.1.0b.zip::"${_url_d}/extras/dafkey/dafkey-1.0.0b.zip"
        exportfl-1.3.1.zip::"${_url_d}/extras/exportfl/exportfl-1.3.1.zip"
        exportps-1.0.0.zip::"${_url_d}/extras/exportps/exportps-1.0.0.zip" 
        minivmac.man::"https://raw.githubusercontent.com/ajacocks/minivmac-aur/main/minivmac.man"
        importfl-1.2.2.zip::"${_url_d}/extras/importfl/importfl-1.2.2.zip")
sha256sums=('9b7343cec87723177a203e69ad3baf20f49b4e8f03619e366c4bf2705167dfa4'
            '3c3040148c0e128a8402ac0fa3494098b0dee7df7bd06b26e9196c5dd1addff3'
            'ef4912e9d10471ddfc1e4976ccf98d0bf76e9ef5ad2f8748c548d44714127223'
            '29c5e3c2604f9e6e9dcaf48cc716c17f8a89333fcf37770878c40382b62c4d92'
            'bb1b62edbb0729d09db49026ca8108c4a610e2b1d219f7c5644b7f66501c98b8'
            'aa263b994e15eea8ccbef05c04d40ad6a968f68a87a6a496d00671e75937a17e'
            '633a531500854af6e899ab6501fdf6b0060f6100bba726421aa6f37a860f6f7b'
            '019693a04d63e0f4a71dae2d91a24e6862245b14e99b7af1f860498ff11eabdd'
            'bd6e70489d9bac12d9012634f4f5ae51f30a2c5d647fe3b2b071ff1b5a649419')
# Models that minivmac supports
#-m 128K { Macintosh 128K }
#-m 512Ke { Macintosh 512Ke }
#-m Plus { (default) Macintosh Plus }
#-m SE { Macintosh SE }
#-m Classic { Macintosh Classic }
#-m SEFDHD { Macintosh SE FDHD }
#-m II { Macintosh II * }
build() {
  # since minivmac requires a separate build option (and executable) for each emulated machine, build them all in separate directories
  for _model in ${_models}; do
    cp -r ${pkgname} ${pkgname}-${_model}
    cd ${pkgname}-${_model}
    gcc setup/tool.c -o setup_t
    ./setup_t -t lx64 -m ${_model} > setup.sh
    . setup.sh
    make
    cd ..
   done
}
package() {
  # install docs
  install -dm755 "$pkgdir"/usr/share/doc/$pkgname
  install -m0644 ${pkgname}/COPYING.txt "$pkgdir"/usr/share/doc/$pkgname/COPYING.txt
  install -m0644 ${pkgname}/README.txt "$pkgdir"/usr/share/doc/$pkgname/README.txt
  # create a launcher script
  install -dm755 "$pkgdir"/usr/bin
  cat <<EOF > "$pkgdir"/usr/bin/$pkgname
#!/bin/sh
if [ -x "\$0-bin" -a -d /usr/share/minivmac/roms ]; then
  "\$0-bin" -d /usr/share/minivmac/roms
else
  echo "Failed to find executable '\$0-bin' or directory '/usr/share/minivmac/roms'."
  exit 1
fi
EOF
  chmod 0755 "$pkgdir"/usr/bin/$pkgname
  # install all model-specific executables
  for _model in ${_models}; do
    cd ${pkgname}-${_model}
    install -Dm755 "${pkgname}" "$pkgdir"/usr/bin/$pkgname-${_model}-bin
    echo ln -s /usr/bin/$pkgname "$pkgdir"/usr/bin/$pkgname-${_model}
    ln -s /usr/bin/$pkgname "$pkgdir"/usr/bin/$pkgname-${_model}
    cd ..
  done
  # set minimac to default to Macintosh Plus emulation
  ln -s "$pkgdir"/usr/bin/$pkgname-Plus-bin "$pkgdir"/usr/bin/$pkgname-bin
  # create a disk storage directory
  install -dm755 "$pkgdir"/usr/share/$pkgname/disks
  # install man page
  install -Dm755 minivmac.man "$pkgdir"/usr/share/man/man1/minivmac.1
  # create a ROM storage directory
  install -dm755 "$pkgdir"/usr/share/$pkgname/roms
  # Extras
  ########
  # install blank disks
  tar cf - blanks-1.1 | ( cd "$pkgdir"/usr/share/$pkgname/disks; tar xvf - )
  mv "$pkgdir"/usr/share/$pkgname/disks/blanks-1.1 "$pkgdir"/usr/share/$pkgname/disks/blanks
  # install clipin
  install -Dm644 clipin-1.1.0/clipin-1.1.0.dsk "$pkgdir"/usr/share/$pkgname/disks/clipin-1.1.0.dsk
  install -Dm644 clipin-1.1.0/clipin-1.1.0.md5.txt "$pkgdir"/usr/share/$pkgname/disks/clipin-1.1.0.md5.txt
  # install clipout
  install -Dm644 clipout-1.1.0/clipout-1.1.0.dsk "$pkgdir"/usr/share/$pkgname/disks/clipout-1.1.0.dsk
  install -Dm644 clipout-1.1.0/clipout-1.1.0.md5.txt "$pkgdir"/usr/share/$pkgname/disks/clipout-1.1.0.md5.txt
  # install dafkey
  install -Dm644 dafkey-1.0.0/dafkey-1.0.0.dsk "$pkgdir"/usr/share/$pkgname/disks/dafkey-1.0.0.dsk
  install -Dm644 dafkey-1.0.0/dafkey-1.0.0.md5.txt "$pkgdir"/usr/share/$pkgname/disks/dafkey-1.0.0.md5.txt
  # install exportfl
  install -Dm644 exportfl-1.3.1/exportfl-1.3.1.dsk "$pkgdir"/usr/share/$pkgname/disks/exportfl-1.3.1.dsk
  install -Dm644 exportfl-1.3.1/exportfl-1.3.1.md5.txt "$pkgdir"/usr/share/$pkgname/disks/exportfl-1.3.1.md5.txt
  # install exportps
  install -Dm644 exportps-1.0.0/exportps-1.0.0.dsk "$pkgdir"/usr/share/$pkgname/disks/exportps-1.0.0.dsk
  install -Dm644 exportps-1.0.0/exportps-1.0.0.md5.txt "$pkgdir"/usr/share/$pkgname/disks/exportps-1.0.0.md5.txt
  # install importfl
  install -Dm644 importfl-1.2.2/importfl-1.2.2.dsk "$pkgdir"/usr/share/$pkgname/disks/importfl-1.2.2.dsk
  install -Dm644 importfl-1.2.2/importfl-1.2.2.md5.txt "$pkgdir"/usr/share/$pkgname/disks/importfl-1.2.2.md5.txt
}
