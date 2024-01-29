class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor w/ Debian patches"
  homepage "https://sourceforge.net/projects/nedit/"
  url "http://deb.debian.org/debian/pool/main/n/nedit/nedit_5.7.orig.tar.gz"
  sha256 "32bf3fc15dbb6154838a34d560ca5b0f3e7744301f4c15f8a2af8ad2ea3d0764"
  license "GPL-2.0-or-later"
  revision 1

  resource "patches" do
    url "http://deb.debian.org/debian/pool/main/n/nedit/nedit_5.7-5.debian.tar.xz"
    sha256 "32bf3fc15dbb6154838a34d560ca5b0f3e7744301f4c15f8a2af8ad2ea3d0764"
  end

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  uses_from_macos "bison" => :build

  def install
    resources("patches").stage { "." }
    File.foreach("debian/patches/series", "\n") do |fp|
      system "patch", "-p1", fp.chomp
    end
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
