# webshare

Share HTML deliverables with clients via a secure link. They click it and it opens — no login, no account, nothing to install. The file is encrypted so it can sit on a public URL and only the person with the link can read it.

## How it works

HTML files in `source/` are encrypted locally using [StatiCrypt](https://github.com/robinmoisson/staticrypt) (AES-256, runs in the browser) and hosted on GitHub Pages. The decryption key lives in the link itself. Anyone with the full link can open the file. Anyone without it sees a password prompt.

## Prerequisites

- [Node.js](https://nodejs.org) (for the encryption script)
- Git
- A GitHub account with Pages enabled on this repo (Settings → Pages → Deploy from main branch root)

## First-time setup

```bash
git config core.hooksPath .githooks
./encrypt.sh
```

`encrypt.sh` generates a password on first run and saves it to `.env`. Nothing else to configure.

## Workflow

1. Add or edit HTML files in `source/`
2. `./encrypt.sh` — encrypts everything and prints magic links
3. `git add *.html && git commit -m "..." && git push`

The pre-commit hook blocks any unencrypted HTML from being committed. GitHub Pages deploys within about a minute of pushing.

## Sharing

Copy a link from the `./encrypt.sh` output and send it directly. Works when clicked from Slack, Teams, email, or any browser.

## Password rotation

1. Update `STATICRYPT_PASSWORD` in `.env` with a new value
2. `./encrypt.sh` — prints new links
3. Commit and push
4. Resend links — old ones stop working as soon as the new files are live
