# Pari

Pari (Paru + info) is a simple wrapper script for the Paru package manager that enhances the default output of `paru -Si [pkgname]` to provide additional useful info about the package.
> *The package's source URL is the only extra info Pari provides at the moment, but a couple other very handy features are currently in development and will be added in future releases.*
  
### What it does:

1. Retrieves the detailed package information using `paru -Si`
2. Builds the corresponding Arch, AUR, Chaotic-AUR, or BlackArch (more repos to be supported soon) URL based on the package's source repository.
3. Outputs the full set of package details with the new URL appended to the bottom.

### Prerequisites:

- [Paru](https://github.com/Morganamilo/paru) - Paru is an AUR helper for Arch Linux and Arch-based distributions. Make sure Paru is installed and configured properly before using Pari.

### Usage:

To use Pari, simply execute the script with the desired package name as an argument:

`$ ./pari [pkgname]`

Replace `[pkgname]` with the name of the package you want to query. Pari will retrieve the package information using `paru -Si`, extract the appropriate URL based on the repository, and append it to the output.

### Example:

```
$ ./pari gimp

Repository      : extra
Name            : gimp
Version         : 2.10.34-2
Description     : GNU Image Manipulation Program
Architecture    : x86_64
URL             : https://www.gimp.org/
Licenses        : GPL  LGPL
Groups          : None
Provides        : None
Depends On      : babl  cairo  fontconfig  freetype2  gcc-libs  gdk-pixbuf2  gegl  glib2  glibc  gtk2  harfbuzz  hicolor-icon-theme  iso-codes  json-glib  lcms2  libgexiv2  libmypaint  libunwind  mypaint-brushes1  pango  zlib  bzip2  libgudev  libheif  libjpeg-turbo  libjxl  libmng  libpng  librsvg  libtiff  libwebp  libwmf  libx11  libxcursor  libxext  libxfixes  libxmu  libxpm  openexr  openjpeg2  poppler-data  poppler-glib  xz
Optional Deps   : alsa-lib: for MIDI event controller module
                  ghostscript: for PostScript support
                  gutenprint: for sophisticated printing only as gimp has built-in cups print support
                  gvfs: for HTTP/S support (and many other schemes)
Conflicts With  : gimp-plugin-wavelet-decompose
Replaces        : gimp-plugin-wavelet-decompose
Download Size   : 20.01 MiB
Installed Size  : 112.64 MiB
Packager        : Balló György <bgyorgy@archlinux.org>
Build Date      : Sat 27 May 2023 07:58:02 AM
Validated By    : MD5 Sum  SHA-256 Sum  Signature

####################################################################

🔗 https://www.archlinux.org/packages/extra/x86_64/gimp/
```
