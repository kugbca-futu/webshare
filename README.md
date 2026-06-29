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

```
https://kugbca-futu.github.io/webshare/<filename>#staticrypt_pwd=<password>
```

Send the full link including the `#` fragment. Recipients open it in any browser with no login required. The password never leaves their browser.

## Password rotation

1. Update `STATICRYPT_PASSWORD` in `.env`
2. `./encrypt.sh`
3. Commit and push
4. Resend links — old ones stop working immediately
