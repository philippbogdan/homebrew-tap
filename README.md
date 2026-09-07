# Homebrew tap

Homebrew packages maintained by [Philipp Bogdan](https://github.com/philippbogdan).

## amail

[amail](https://github.com/philippbogdan/amail) is a local email CLI for agents on macOS. It reads Apple Mail's cache and sends through the Gmail API or an existing authorised Exchange account. It supports JSON output, local drafts, mailbox operations and reviewed batches.

```sh
brew install philippbogdan/tap/amail
amail setup
```

Homebrew automatically adds this tap when installing the fully qualified formula. If you add the tap manually, your Homebrew version may require explicit formula trust:

```sh
brew tap philippbogdan/tap
brew trust --formula philippbogdan/tap/amail
brew install philippbogdan/tap/amail
```

This is a third-party tap, not Homebrew core. The formula uses a checksummed release and an isolated Python environment. It does not enable accounts, obtain credentials or send mail during installation.

You need a Mac with Google or Exchange accounts already connected to Apple Mail, and the required macOS permissions. Gmail's optional OAuth helper is installed separately. Follow [the setup guide](https://github.com/philippbogdan/amail/blob/main/docs/SETUP.md).

Update with:

```sh
brew update
brew upgrade philippbogdan/tap/amail
```

The package uses the same private amail configuration and ledger as a source installation. If both launchers exist, check `command -v amail` to see which your shell uses. Never delete state or credential files just to switch installation methods.

## Maintenance

Each update pins a published amail version and its SHA-256. CI installs from source and runs the formula's isolated test on macOS. The test does not access real email accounts or send mail.

```sh
brew install --build-from-source philippbogdan/tap/amail
brew test philippbogdan/tap/amail
```

MIT licensed.
