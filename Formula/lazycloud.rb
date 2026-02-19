class Lazycloud < Formula
  desc "A terminal UI for various cloud provider CLIs"
  homepage "https://github.com/jorgeparavicini/lazycloud"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.4/lazycloud-aarch64-apple-darwin.tar.gz"
      sha256 "945fe227a00ae057210b88ef5cb65aec4709254b5b4a2b3b5d667f0bedbffc74"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.4/lazycloud-x86_64-apple-darwin.tar.gz"
      sha256 "6359dc848eba7e53e53810fb912ad413aac8d0d49b79d55b198219e15ad7fea3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.4/lazycloud-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f4cd1e8b3705bd3a69f7321993179043ab2474799d9f3cfbb36f01a79e585105"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jorgeparavicini/lazycloud/releases/download/v0.1.4/lazycloud-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "80a81fc1a1a4965db6aa05bb7c350f9f1625ee1d95d432e3f40540c0fa6e97be"
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
