#!/usr/bin/env bash
set -euo pipefail

# Auto-generate credentials on first run
if [ ! -f .env ]; then
  echo "First run: generating credentials and saving to .env"
  STATICRYPT_PASSWORD=$(openssl rand -base64 32)
  STATICRYPT_SALT=$(openssl rand -hex 16)
  printf "STATICRYPT_PASSWORD=%s\nSTATICRYPT_SALT=%s\n" "$STATICRYPT_PASSWORD" "$STATICRYPT_SALT" > .env
  echo "Done. Keep .env safe."
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

# Use staticrypt's built-in --share-remember to get the hashed key, then use ? instead of #
# so links work when clicked directly from Slack, Teams, email, etc.
FRAGMENT=$(/opt/homebrew/bin/npx staticrypt "$(ls source/*.html | head -1)" \
  -p "$STATICRYPT_PASSWORD" -s "$STATICRYPT_SALT" --share --share-remember 2>/dev/null | tail -1)
QUERY="${FRAGMENT//#/?}"

echo ""
echo "All encrypted. Ready to commit."
echo ""
echo "Magic links:"
for src in source/*.html; do
  filename=$(basename "$src")
  echo "  https://kugbca-futu.github.io/webshare/${filename}${QUERY}"
done
