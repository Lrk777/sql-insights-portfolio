#!/usr/bin/env python3
"""Download Complete Journey tables and export CSVs into data/raw/."""

from __future__ import annotations

import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
BASE = "https://raw.githubusercontent.com/bradleyboehmke/completejourney/master/data"

FILES = [
    "campaign_descriptions.rda",
    "campaigns.rda",
    "coupon_redemptions.rda",
    "coupons.rda",
    "demographics.rda",
    "products.rda",
    "transactions.rds",
    # Optional / large — uncomment to also pull promotions:
    # "promotions.rds",
]


def main() -> int:
    try:
        import pyreadr  # noqa: F401
    except ImportError:
        print("Install deps: python3 -m pip install pyreadr pandas", file=sys.stderr)
        return 1

    import pyreadr

    RAW.mkdir(parents=True, exist_ok=True)
    for name in FILES:
        dest = RAW / name
        url = f"{BASE}/{name}"
        print(f"Downloading {name} …")
        urllib.request.urlretrieve(url, dest)

    for path in sorted(RAW.glob("*.rda")) + sorted(RAW.glob("*.rds")):
        result = pyreadr.read_r(str(path))
        for obj_name, df in result.items():
            out_name = obj_name if obj_name not in (None, "None") else path.stem
            out = RAW / f"{out_name}.csv"
            df.to_csv(out, index=False)
            print(f"  wrote {out.name}: {len(df):,} rows")

    print("Done. Raw CSVs are gitignored — see data/manifest.md")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
