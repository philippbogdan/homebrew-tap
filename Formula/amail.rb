class Amail < Formula
  include Language::Python::Virtualenv

  desc "Local email CLI for agents using Gmail and Exchange on macOS"
  homepage "https://github.com/philippbogdan/amail"
  url "https://github.com/philippbogdan/amail/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "4c79a70edda244546c15515f512e3fe06c3634952d89b8b7e06dedfc5f84ddf4"
  license "MIT"

  depends_on :macos
  depends_on "python@3.14"

  def install
    virtualenv_create(libexec, formula_opt_bin("python@3.14")/"python3.14", system_site_packages: false)
    app = libexec/"app"
    app.install %w[
      amail cli.py configuration.py local_store.py body_index.py
      mail_sender.py gmail_backend.py mail_operations.py mail_operations.jxa
      send.applescript native_editor.py native_transport.py
      bulk_mark.py workflows.py policy.py feedback.py usage.py
    ]
    app.install "README.md", "LICENSE", "CONTRIBUTING.md", "SECURITY.md", "CHANGELOG.md", "docs", "skills"
    inreplace app/"amail", "#!/usr/bin/env python3", "#!#{libexec}/bin/python"
    bin.install_symlink app/"amail"
  end

  def caveats
    <<~EOS
      Run amail setup to discover and select your Apple Mail accounts.
      Sending needs Mail Automation and host Accessibility permission; every
      account sends through Apple Mail. Optional live Gmail reads need gog and
      your own Google OAuth client.
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
