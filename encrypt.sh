#!/usr/bin/env bash
set -euo pipefail

if [ -f .env ]; then
  set -a; source .env; set +a
fi

if [ -z "${STATICRYPT_PASSWORD:-}" ] || [ -z "${STATICRYPT_SALT:-}" ]; then
  echo "Error: STATICRYPT_PASSWORD and STATICRYPT_SALT must be set in .env"
  exit 1
fi

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

[ "$failed" -eq 0 ] && echo "" && echo "All encrypted. Ready to commit."
[ "$failed" -eq 1 ] && echo "" && echo "One or more failed. Do not commit." && exit 1
