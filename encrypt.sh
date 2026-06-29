#!/usr/bin/env bash
set -euo pipefail

# Generate password on first run. Salt is managed by staticrypt in .staticrypt.json.
if [ ! -f .env ]; then
  printf "STATICRYPT_PASSWORD=%s\n" "$(openssl rand -base64 32)" > .env
  echo "Generated password saved to .env. Keep it safe."
  echo ""
fi

sources=$(ls source/*.html 2>/dev/null || true)
if [ -z "$sources" ]; then
  echo "No HTML files found in source/"
  exit 1
fi

failed=0
for src in source/*.html; do
  filename=$(basename "$src")
  npx staticrypt "$src" -d . --remember 7

  if head -2 "$filename" | grep -q 'class="staticrypt-html"'; then
    echo "ok  $filename"
  else
    echo "FAIL $filename"; failed=1
  fi
done

[ "$failed" -eq 1 ] && echo "" && echo "One or more failed. Do not commit." && exit 1

FRAGMENT=$(npx staticrypt "$(ls source/*.html | head -1)" --share --share-remember 2>/dev/null | tail -1)
QUERY="${FRAGMENT//#/?}"
QUERY="${QUERY/&remember_me/&remember_me=1}"

echo ""
echo "All encrypted. Ready to commit."
echo ""
echo "Magic links:"
for src in source/*.html; do
  echo "  https://kugbca-futu.github.io/webshare/$(basename "$src")${QUERY}"
done
