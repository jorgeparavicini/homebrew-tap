class Lazycloud < Formula
  desc "A terminal UI for various cloud provider CLIs"
  homepage "https://github.com/jorgeparavicini/lazycloud"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.7/lazycloud-aarch64-apple-darwin.tar.gz"
      sha256 "2db66bed32b737291b88e733bc4ad5a6d773cd0931c623e798cf7cd2082803a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.7/lazycloud-x86_64-apple-darwin.tar.gz"
      sha256 "efffbe5897dd0e85827edbd1c35404bc378e61a27bdc906a90e21dec507e65db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.7/lazycloud-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a1eb767c6d6ee139432b1a5ea051faacbfcd62b37bc75e2132c4c27190eaf292"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.7/lazycloud-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d5a6a90c7ee6bd2570199d9d5a2e0fd4c9de3c0292bfbb1ce37ed8b569c00b90"
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
