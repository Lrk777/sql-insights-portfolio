# Data license & attribution

## Source

This project analyzes **The Complete Journey** grocery panel (household transactions, products, demographics, campaigns, coupons), originating from the **84.51° / Dunnhumby Customer Journey** study and distributed for academic / non-commercial learning via:

- Official: [Dunnhumby Source Files](https://www.dunnhumby.com/source-files/)
- Convenient processed tables used in this lab: [bradleyboehmke/completejourney](https://github.com/bradleyboehmke/completejourney) (R data package; CSV export for DuckDB)

## Terms (summary — read the upstream sources)

- Data is provided for **non-commercial / educational / portfolio learning** use.
- **Do not redistribute** the raw CSV / RDS extracts in a public GitHub repo.
- Attribute **Dunnhumby / 84.51°** and the Complete Journey study.
- Do **not** imply employment by, partnership with, or endorsement from Dunnhumby, 84.51°, or any retailer depicted in the panel.

## This repository

- **Code** (SQL, scripts, docs): MIT — see `LICENSE`.
- **Raw data**: not committed; see `data/manifest.md` and `scripts/download_notes.md`.
- Findings and sample query outputs contain **aggregate numbers only**, derived by running the SQL in this repo.

If upstream license terms conflict with any mirror, **upstream Dunnhumby / 84.51° terms prevail**.
