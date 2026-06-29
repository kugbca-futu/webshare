#!/usr/bin/env bash
set -euo pipefail

# Auto-generate credentials on first run
if [ ! -f .env ]; then
  echo "First run: generating credentials and saving to .env"
  STATICRYPT_PASSWORD=$(openssl rand -base64 32)
  STATICRYPT_SALT=$(openssl rand -hex 16)
  printf "STATICRYPT_PASSWORD=%s\nSTATICRYPT_SALT=%s\n" "$STATICRYPT_PASSWORD" "$STATICRYPT_SALT" > .env
  echo "Done. Keep .env safe — losing it means you can't update existing links."
  echo ""
fi

set -a; source .env; set +a

sources=$(ls source/*.html 2>/dev/null || true)
if [ -z "$sources" ]; then
  echo "No HTML files found in source/"
  exit 1
fi

failed=0
for src in source/*.html; do
  filename=$(basename "$src")
  /opt/homebrew/bin/npx staticrypt "$src" \
    -p "$STATICRYPT_PASSWORD" \
    -d . \
    -s "$STATICRYPT_SALT" \
    --remember 7

  if head -2 "$filename" | grep -q 'class="staticrypt-html"'; then
    echo "ok  $filename"
  else
    echo "FAIL $filename"
    failed=1
  fi
done

[ "$failed" -eq 1 ] && echo "" && echo "One or more failed. Do not commit." && exit 1

HASHED_PWD=$(node -e "
const { webcrypto: { subtle } } = require('crypto');
async function step(pass, salt, iter, hash) {
  const enc = new TextEncoder();
  const key = await subtle.importKey('raw', enc.encode(pass), 'PBKDF2', false, ['deriveBits']);
  const bits = await subtle.deriveBits({ name: 'PBKDF2', hash, iterations: iter, salt: enc.encode(salt) }, key, 256);
  return Buffer.from(bits).toString('hex');
}
(async () => {
  const h1 = await step(process.env.STATICRYPT_PASSWORD, process.env.STATICRYPT_SALT, 1000, 'SHA-1');
  const h2 = await step(h1, process.env.STATICRYPT_SALT, 14000, 'SHA-256');
  const h3 = await step(h2, process.env.STATICRYPT_SALT, 585000, 'SHA-256');
  process.stdout.write(h3);
})();
")

echo ""
echo "All encrypted. Ready to commit."
echo ""
echo "Magic links:"
for src in source/*.html; do
  filename=$(basename "$src")
  echo "  https://kugbca-futu.github.io/webshare/${filename}?staticrypt_pwd=${HASHED_PWD}&remember_me=1"
done
