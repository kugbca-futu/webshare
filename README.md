# webshare

Encrypted client deliverables on GitHub Pages. Source HTML lives in `source/` (gitignored). `encrypt.sh` encrypts everything and writes to the repo root. Only encrypted files are committed.

## Setup

```bash
git config core.hooksPath .githooks
./encrypt.sh
```

First run generates a password automatically and saves it to `.env`. Nothing else to configure.

## Workflow

1. Edit or add HTML in `source/`
2. `./encrypt.sh` — encrypts everything and prints magic links
3. `git add *.html && git commit -m "..." && git push`

The pre-commit hook blocks any unencrypted HTML from being committed.

## Sharing

Copy a link from the `./encrypt.sh` output and send it. Works when clicked directly from Slack, Teams, or email. Recipient clicks, page opens — no login, nothing to install.

## Password rotation

1. Update `STATICRYPT_PASSWORD` in `.env`
2. `./encrypt.sh` — prints new magic links
3. Commit and push
4. Resend links — old ones stop working immediately
