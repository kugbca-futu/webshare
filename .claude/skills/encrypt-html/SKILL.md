---
description: Encrypt all deliverables in source/ using ./encrypt.sh. Run this any time a source file is added or changed before committing.
allowed-tools: Bash, Read
---

Run from the repo root:

```bash
./encrypt.sh
```

Reads every HTML file from `source/`, encrypts it, writes the encrypted output to the repo root, and prints magic links. Generates `.env` with the password automatically on first run. Salt is managed by StatiCrypt in `.staticrypt.json`, which is committed to the repo. Never commit source/ files or run staticrypt manually on the root HTML files.
