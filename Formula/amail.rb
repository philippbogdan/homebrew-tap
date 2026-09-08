class Amail < Formula
  include Language::Python::Virtualenv

  desc "Local email CLI for agents using Gmail and Exchange on macOS"
  homepage "https://github.com/philippbogdan/amail"
  url "https://github.com/philippbogdan/amail/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6da5419419f4f2d76a31125fcb40d5342d5e8cc4efcb71efdfe263ce2007f2c2"
  license "MIT"

  depends_on :macos
  depends_on "python@3.14"

  def install
    virtualenv_create(libexec, formula_opt_bin("python@3.14")/"python3.14", system_site_packages: false)
    app = libexec/"app"
    app.install %w[
      amail cli.py configuration.py local_store.py body_index.py
      mail_sender.py gmail_backend.py mail_operations.py mail_operations.jxa
      send.applescript bulk_mark.py workflows.py policy.py feedback.py usage.py
    ]
    app.install "README.md", "LICENSE", "CONTRIBUTING.md", "SECURITY.md", "CHANGELOG.md", "docs", "skills"
    inreplace app/"amail", "#!/usr/bin/env python3", "#!#{libexec}/bin/python"
    bin.install_symlink app/"amail"
  end

  def caveats
    <<~EOS
      Run amail setup to discover and select your Apple Mail accounts.
      Gmail API access also needs gog and your own Google OAuth client.
      Configuration and credentials stay in your private user storage.
      See https://github.com/philippbogdan/amail/blob/main/docs/SETUP.md
    EOS
  end

  test do
    ENV["AMAIL_STATE_DIR"] = (testpath/"state").to_s
    ENV["AMAIL_CONFIG"] = (testpath/"config.json").to_s
    assert_match version.to_s, shell_output("#{bin}/amail --version")
    assert_match "JSONL", shell_output("#{bin}/amail schema batch")
    assert_match "mark-bulk", shell_output("#{bin}/amail --help")
    assert_match "setup", shell_output("#{bin}/amail --help")
    assert_match "amail setup", shell_output("#{bin}/amail accounts 2>&1", 1)
  end
end
