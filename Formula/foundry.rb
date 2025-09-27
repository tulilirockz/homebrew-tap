class Foundry < Formula
  desc "This tool aims to extract much of what makes GNOME Builder an IDE into a library and companion command-line tool."
  homepage "https://gitlab.gnome.org/GNOME/foundry"
  url "https://gitlab.gnome.org/GNOME/foundry/-/archive/main/foundry-main.tar.gz?ref_type=heads"
  sha256 "1fdc014595a522212d5459de8e3bb78daa5b693ae2972519c2587f46cfb57666"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "ab7a77bfe9bacd8f8fd89a3e06462552486ccec31a14483654f7cb718c1c71df"
    sha256 arm64_sequoia: "d9708f3c4d341496455119f0cbf14e9feb94bcfa3a6742f1ba1ac2b8a330d2d1"
    sha256 arm64_sonoma:  "8a46f67637a9c9126948caa7b93048ee24aa314f9cc6a8f0b1ac664bf2bc0771"
    sha256 arm64_ventura: "95f5d01e5cc470b223e26df75f92d968554e07856150f8b61e66c1a369d5f7a7"
    sha256 sonoma:        "977966489988c8819b3b5b53bdbb5e584edc9618a7c6a6d256dae5a1cdd1ef8e"
    sha256 ventura:       "6594e4cb62781155b467d0db3928f2288586774537f3ce1a9c003740003564f6"
    sha256 arm64_linux:   "af619618e6370ecd8f3cb6f431dd753a0b2e4444f3f8a2871aa186e9d578f5ca"
    sha256 x86_64_linux:  "719b56150089db56278c1493c45dcfdfc75d25f0cc921a59e6e557e601ea6ea0"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "rust" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "exempi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "libspelling"
  depends_on "libtiff"
  depends_on "pango"
  depends_on "poppler"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    ENV["DESTDIR"] = "/"

    # if OS.mac?
    #   # https://github.com/gettext-rs/gettext-rs/tree/master/gettext-sys#environment-variables
    #   ENV["GETTEXT_DIR"] = Formula["gettext"].prefix.to_s

    #   ENV.append_to_rustflags "--codegen link-args=-Wl,-rpath,#{rpath}"
    # end

    # Export pps_job_run for testing. Remove this workaround in 49.x.
    # inreplace "libview/pps-job.h", /^(gboolean pps_job_run)/, "PPS_PUBLIC \\1"

    # args = %w[
    #   -Dviewer=true
    #   -Dpreviewer=true
    #   -Dthumbnailer=true
    #   -Dnautilus=false
    #   -Dcomics=enabled
    #   -Ddjvu=enabled
    #   -Dpdf=enabled
    #   -Dtiff=enabled
    #   -Dtests=false
    #   -Ddocumentation=false
    #   -Duser_doc=false
    #   -Dintrospection=enabled
    #   -Dsysprof=disabled
    #   -Dkeyring=enabled
    #   -Dgtk_unix_print=enabled
    #   -Dspell_check=enabled
    # ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
  end
end
