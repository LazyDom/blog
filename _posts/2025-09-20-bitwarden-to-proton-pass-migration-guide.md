---
layout: post
title: "Bitwarden → Proton Pass Migration Guide (Secure, Clean Transition)"
categories: [security, password-managers, migration]
description: Step-by-step instructions, caveats, and best practices for safely migrating your vault from Bitwarden to Proton Pass without data loss or leaks.
tagline: Move your secrets from Bitwarden to Proton Pass—without leaving any behind.
cdn_base: "https://gist.githubusercontent.com/LazyDom/b419742c099e5eb6d98c769d1381eb82/raw/a1b3af5b5b8ac49c92e1e35e6a28b08f55e487f9/"
author: LazyDom
date: 2025-09-20
---

> This guide walks you through exporting from Bitwarden, importing into Proton Pass, verifying integrity (logins, TOTP seeds, notes, cards, identities), handling items that **do not** migrate automatically (attachments, passkeys, shares), and securely disposing of leftover export files.

<!--more-->

## TL;DR
1. Clean your Bitwarden vault first (trash, duplicates, legacy accounts, stale 2FA codes).
2. Export **unencrypted JSON** (needed for Proton Pass import) – store it *briefly* with strict permissions.
3. Import JSON in Proton Pass → Settings → Import → Bitwarden.
4. Manually recreate: attachments, Send links, passkeys (FIDO2/WebAuthn), collections/shares, password history.
5. Spot‑check critical items (bank, email, cloud, registrar) + a few TOTP codes.
6. Securely shred the export file and any temporary derivatives.

---
## 1. Why Migrate? :incoming_envelope:

_Bitwarden vs Proton Pass: Key Differences_

{% gist LazyDom/128bdadda1a237cfbc1caadcc30bfb7a %}

**NOT** a “better crypto” argument—both are strong. It’s about ecosystem consolidation, aliasing, and UI preferences.

### Hide My Email: why it shines
- Unique per‑site aliases: avoid cross‑site tracking and credential stuffing that target reused addresses.
- Autofill + instant generation: create and fill an alias at signup without leaving the flow.
- Private reply routing: receive replies without exposing your real mailbox; turn off forwarding anytime.
- One‑click kill switch: disable a spammed alias without touching your primary email or changing logins.
- Clean separation: keep vendors from learning your canonical address while preserving deliverability.

![Proton Pass generating a unique email alias during signup autofill]({{ page.cdn_base }}email-alias-autofill.png)
*Proton Pass creating and autofilling a per‑site alias (your real address is never exposed)*

### Added Security & Hygiene Perks
- **Dark Web Monitoring** – Paid Proton plans can surface breach exposures tied to your primary email (and increasingly aliases), giving you early warning to rotate credentials before active abuse.
- **Password Health (Weak / Reused)** – A consolidated view (or periodic manual audit) to spot weak, short, or re‑used secrets so you can prioritize rotations while everything is fresh in your mind post‑migration.
- **Inactive / Missing 2FA Signal** – Identify high‑value accounts lacking TOTP/passkey fields; treat migration as a trigger to enable MFA everywhere feasible (email, registrar, banking, cloud consoles). Proton Pass makes it obvious which entries have no TOTP seed yet.

---
## 2. Pre‑Migration Checklist :clipboard:

_Pre‑Migration Tasks and Rationale_

{% gist LazyDom/eca5f2955fd25f6f4c7d0c2576b28984 %}

> Tip: Create a plaintext (temporary) checklist file to tick off, then shred it at the end.

---
## 3. Clean & Classify Bitwarden Data :wastebasket:
Group edge cases now:
- **Attachments** – Proton Pass currently: re‑attach manually (download → add to item in Pass).
- **Send items** – Export does *not* include them; copy any content you still need.
- **Passkeys (FIDO2/WebAuthn authenticators)** – Not exportable; you must re‑register with each site in a passkey-supporting Proton Pass client.
- **Collections / Shared (Org)** – Personal import ignores organizational scoping. Plan manual recreation / team migration.
- **Password History** – Not imported. If needed, export a separate encrypted archive (optional) & store offline.

Optional labeling strategy: In Bitwarden, prefix critical items with a temporary tag like `CRIT-` to speed post‑import sampling.

---
## 4. Export from Bitwarden (Safely) :outbox_tray:
Bitwarden Web Vault → Settings → Export Vault.

_Export Format Options_

{% gist LazyDom/89730e4f291147d1ef481a3e31690aaa %}

Steps:
1. Choose **JSON (unencrypted)**.
2. Enter master password → download `bitwarden_export_YYYYMMDD.json`.

    ![Bitwarden Web Vault export dialog selecting JSON (unencrypted) format]({{ page.cdn_base }}bitwarden-export-vault.gif)
    *Bitwarden Export: choose JSON (unencrypted) then download before hashing & secure disposal*

3. (Optional security hardening) Immediately set strict perms & hash it:

    ```bash
    chmod 600 bitwarden_export_20250904.json
    sha256sum bitwarden_export_20250904.json > bitwarden_export_20250904.json.sha256
    ``` 

4. (Optional audit) Quick schema glance:
```bash
head -n 40 bitwarden_export_20250904.json | sed 's/"password": ".*"/"password": "REDACTED"/'
```

_**Security Notes:**_
- Keep file on an encrypted volume if possible.
- **Do not email / cloud-sync** the raw export.
- Close unrelated apps while it exists.

---
## 5. Proton Pass Import :inbox_tray:
Browser Extension / Web App → Settings → Import → Pick “Bitwarden”.
Upload the JSON; Proton parses and maps types:

![Proton Pass vault header with settings gear menu open highlighting the Import option entry point]({{ page.cdn_base }}proton_pass_home_pg.png)
*Accessing Import: open the gear menu in the Proton Pass header and choose Import to start bringing in your Bitwarden JSON*

![Proton Pass settings page highlighting the Import tab before choosing a source]({{ page.cdn_base }}proton_pass_import_tab.png)
*Navigate to Settings → Import to begin a Bitwarden vault migration*

_Bitwarden → Proton Pass Mapping_

{% gist LazyDom/32017348abf86a9f05c082b3ad21baf3 %}

Items **NOT** imported: attachments, sends, org collections, password histories, FIDO2 devices.

![Proton Pass Bitwarden import dialog with the Bitwarden source selected and Import button highlighted]({{ page.cdn_base }}proton_pass_hit_import_button.png)
*Bitwarden import dialog: confirm file selection then click Import to start processing*

![Proton Pass import workflow selecting Bitwarden JSON and confirming item counts]({{ page.cdn_base }}proton-pass-import-vault.gif)
*Proton Pass import: select Bitwarden JSON, map types, and review summary before finalizing*

If the import UI reports errors:
- "Unknown field" → likely future Bitwarden attribute; safe to ignore.
- "Invalid JSON" → redownload; ensure no editor auto-saved changes (VS Code formatting etc.).

> If file size is large (> few MB) and browser stalls, try a different browser or Proton Pass desktop (if available) to avoid memory aborts.

---
## 6. Post‑Import Validation :white_check_mark:
1. **Count Check** – Bitwarden item count vs Proton Pass count (± items you knew wouldn’t migrate).
2. **Critical Sampling** – Open each `CRIT-` tagged item; test a login (in private browser session) for a few high-value services.
3. **TOTP Integrity** – For 3–5 random entries, generate a code in Proton Pass & Bitwarden (don’t delete BW yet) → they should match within the same 30s window.
4. **Search Smoke Test** – Search by a rare domain; confirm it appears.
5. **Attachments** – Manually add files where needed; consider whether they truly must live in the manager.

When satisfied, either locally archive Bitwarden (log out) or keep in read‑only mode a few days as rollback.

---
## 7. Recreate Non‑Migrated Elements :recycle:

_Manual Re‑creation Checklist_

{% gist LazyDom/2c21794c25363f5fed96b2e429b36428 %}

> For high-value accounts, take opportunity to rotate weak / reused passwords during recreation.

---
## 8. Secure Disposal of Export :fire:

After you have 100% confidence:
```bash
sha256sum -c bitwarden_export_20250904.json.sha256   # (optional integrity re-check)
shred -u -n 3 bitwarden_export_20250904.json         # overwrite & delete
rm -f bitwarden_export_20250904.json.sha256
history -d $(history | tail -n 1 | awk '{print $1}') 2>/dev/null || true  # scrub command (optional)
```
If using an SSD, shredding may not guarantee physical overwrite—rely on full‑disk encryption + deletion.

---
## 9. Optional: Minimal Sanitized Subset Script :scissors:
If you want to migrate *only* logins (omit cards, identities, notes) you can pre-filter. Example Node.js one-liner (run locally, never on shared host):

```bash
node -e 'const fs=require("fs");const src=JSON.parse(fs.readFileSync("bitwarden_export_20250904.json","utf8"));src.items=src.items.filter(i=>i.type===1);fs.writeFileSync("bitwarden_logins_only.json",JSON.stringify(src));'
chmod 600 bitwarden_logins_only.json
```
Import `bitwarden_logins_only.json` instead. (Type 1 = login in BW schema.)

---
## 10. Troubleshooting :warning:

_Common Issues and Fixes_

{% gist LazyDom/b3e2b8620621995399d0847d096d1b79 %}

---
## 11. Rollback Plan :rewind:
Hold Bitwarden account (do **not** delete) for a grace period (e.g., 7–14 days). If a missing item surfaces, export just that item (copy manually) into Proton, then finalize by deleting BW vault **after** verifying no dependencies (browser extension removal, mobile app sign‑out, emergency access revocation).

---
## 12. Security Mindset Checklist (Final Pass) :shield:
- [ ] Enforced 2FA on Proton account
- [ ] Shredded Bitwarden export(s)
- [ ] Revoked Bitwarden browser extension & mobile app
- [ ] Rotated any reused / weak passwords encountered
- [ ] Verified random TOTP codes
- [ ] Re-established critical passkeys (if used)
- [ ] Documented any manual recreation steps for audit

---
## 13. FAQ :question:
**Q: Can I keep Bitwarden as encrypted backup?**

Yes, but ensure unique master password & enable 2FA; understand potential confusion later.

**Q: Are passkeys exported?**

No—re-register them.

**Q: Do I need to sign out everywhere before deleting Bitwarden?**

Recommended: sign out, revoke sessions; reduces risk of stale device leak.

**Q: Should I use CSV instead of JSON?**

JSON preserves more structure (preferred here).

**Q: Is shredding on SSD meaningful?**

Limited; rely on disk encryption + logical deletion.

**Q: Should I disable Bitwarden autofill before or during migration?**

Yes. Disable (or uninstall) the Bitwarden extension/app’s autofill before validating Proton Pass so you don’t get overlapping prompts or accidentally test a login filled by the old manager. Keep Bitwarden accessible in a separate browser profile or window only for reference until the rollback window closes.

**Q: What about passwords already saved in the browser (Chrome/Firefox/Edge/Safari)?**

Export or review them first, then clear them out (after verifying Proton Pass has the entries) to avoid a “shadow” credential store leaking outdated passwords or creating confusing duplicate suggestions. Also disable the built‑in browser password manager’s offer‑to‑save and auto‑sign‑in features once Proton Pass is active.

---
## 14. Wrap‑Up :checkered_flag:
Migration is mostly data hygiene and verification. Take the chance to prune, rotate, and standardize naming. Once stable, remove legacy access paths to reduce attack surface.

> Improvements or edge cases you hit? Add them to a running changelog file (not stored with secrets) so future migrations are even smoother.

Happy (secure) migrating!
