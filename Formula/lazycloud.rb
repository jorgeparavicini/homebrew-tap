class Lazycloud < Formula
  desc "A terminal UI for various cloud provider CLIs"
  homepage "https://github.com/jorgeparavicini/lazycloud"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.6/lazycloud-aarch64-apple-darwin.tar.gz"
      sha256 "a77f441725744be75637d060122850cc1f3b1f5139ce3579880f1a7ef24f40c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.6/lazycloud-x86_64-apple-darwin.tar.gz"
      sha256 "040e70794124010dbc67c8c622f4d1a518827b851574e2e8172b35d58b27d1b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.6/lazycloud-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "171c21c2e543fd9876346a4074d81df0dce8d77785acabad535d47bde8329b55"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.6/lazycloud-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "857dbc014401a164269c6b8b576156e434ade345b5f941f1ef202c2f48c7f510"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lazycloud" if OS.mac? && Hardware::CPU.arm?
    bin.install "lazycloud" if OS.mac? && Hardware::CPU.intel?
    bin.install "lazycloud" if OS.linux? && Hardware::CPU.arm?
    bin.install "lazycloud" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
