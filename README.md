# webshare

Encrypted client deliverables on GitHub Pages. Source HTML lives in `source/` (gitignored). `encrypt.sh` encrypts everything and writes to the repo root. Only encrypted files are committed.

## Setup

```bash
git config core.hooksPath .githooks
```

Create `.env` in the repo root (get credentials from the team):

```
STATICRYPT_PASSWORD=<password>
STATICRYPT_SALT=<salt>
```

## Workflow

1. Edit or add HTML in `source/`
2. `./encrypt.sh`
3. `git add <file>.html && git commit -m "..." && git push`

The pre-commit hook blocks any unencrypted HTML from being committed.

## Sharing

`./encrypt.sh` prints the correct magic links after encrypting. Copy from there.

Magic links use the hashed password in the URL fragment, not the raw password. The format is:

```
https://kugbca-futu.github.io/webshare/<filename>#staticrypt_pwd=<hashed-password>
```

Recipients open the link in a browser with no login required. Decryption happens entirely in their browser — the password never leaves their machine.

Paste the link into the browser address bar directly. Some messaging apps (Slack, Teams) strip URL fragments when opening links, which breaks auto-decryption.

## Password rotation

1. Update `STATICRYPT_PASSWORD` in `.env`
2. `./encrypt.sh` (prints new magic links)
3. Commit and push
4. Resend links — old ones stop working immediately
