# webshare

Share HTML deliverables with clients via a link. They click it and it opens. No login required on their end.

The file is encrypted locally using [StatiCrypt](https://github.com/robinmoisson/staticrypt) and hosted on GitHub Pages. The decryption key is embedded in the link. Anyone with the full link can read it. Anyone without it sees a password prompt.

## Prerequisites

- [Node.js](https://nodejs.org)
- Git
- GitHub Pages enabled on this repo (Settings > Pages > Deploy from main branch root)

## First-time setup

```bash
git config core.hooksPath .githooks
./encrypt.sh
```

First run generates a password and saves it to `.env`.

## Workflow

1. Add or edit HTML files in `source/`
2. `./encrypt.sh` prints the links when done
3. `git add *.html && git commit -m "..." && git push`

GitHub Pages deploys within about a minute of pushing.

## Sharing

Copy a link from the `./encrypt.sh` output and send it. Works from Slack, Teams, email.

## Password rotation

1. Update `STATICRYPT_PASSWORD` in `.env`
2. `./encrypt.sh`
3. Commit and push
4. Resend links. Old ones stop working once the new files are live.
