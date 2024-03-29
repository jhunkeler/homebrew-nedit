class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor w/ Debian patches"
  homepage "https://sourceforge.net/projects/nedit/"
  url "http://deb.debian.org/debian/pool/main/n/nedit/nedit_5.7.orig.tar.gz"
  sha256 "add9ac79ff973528ad36c86858238bac4f59896c27dbf285cbe6a4d425fca17a"
  license "GPL-2.0-or-later"
  revision 1000

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  uses_from_macos "bison" => :build

  patch do
    url "https://deb.debian.org/debian/pool/main/n/nedit/nedit_5.7-5.debian.tar.xz"
    sha256 "32bf3fc15dbb6154838a34d560ca5b0f3e7744301f4c15f8a2af8ad2ea3d0764"
    apply %w[
      patches/50_ChangeNCinMan.patch
      patches/fix_typo_in_help.patch
      patches/language-mode-detection.patch
      patches/multiple-tabrows.patch
      patches/show-filename.patch
      patches/drag-move-v1_5.patch
      patches/allow_reproducible_builds.patch
    ]
  end
  def install
    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    system "make", os, "MOTIFLINK='-lXm'"
    system "make", "-C", "doc", "man", "doc"

    bin.install "source/nedit"
    bin.install "source/nc" => "ncl"

    man1.install "doc/nedit.man" => "nedit.1x"
    man1.install "doc/nc.man" => "ncl.1x"
    (etc/"X11/app-defaults").install "doc/NEdit.ad" => "NEdit"
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/nedit 2>&1", 1)
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/ncl 2>&1", 1)
  end
end
