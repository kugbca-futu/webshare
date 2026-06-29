# Security

## What this protects against

The encrypted HTML files are served publicly. Anyone can download them. Without the password they cannot read the content — decryption happens in the browser using AES-256 with 600,000 PBKDF2 iterations, which makes brute-force attacks slow.

The password never travels to a server. It lives in the link and, after first open, in the recipient's browser localStorage for 7 days.

## What this does not protect against

**Link forwarding.** Anyone with the link can open the file and can share the link with others. This is a sharing tool, not an access control system. If you need to revoke access for a specific person, rotate the password and reissue links.

**Browser history and logs.** The password is a query parameter (`?staticrypt_pwd=...`). It will appear in the recipient's browser history. GitHub Pages access logs are not exposed to repo owners, but treat the link itself as the secret.

**Weak passwords.** The auto-generated password is a 32-character random string. If you replace it with something short or guessable, the encryption is only as strong as that password.

## What to keep safe

- `.env` — contains the password. Never commit it. If lost, you can set a new password and re-encrypt, but all existing links will break.
- The magic links themselves — treat them like a shared password.

## Reporting issues

Open an issue in this repo. For vulnerabilities in StatiCrypt itself, follow their [security policy](https://github.com/robinmoisson/staticrypt/blob/main/SECURITY.md).
