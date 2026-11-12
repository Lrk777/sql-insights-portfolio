#!/usr/bin/env python3
"""Run SQL files in order against a local DuckDB database."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "sql"
DEFAULT_DB = ROOT / "cpg.duckdb"

ORDER = [
    "00_load.sql",
    "01_dq_checks.sql",
    "02_clean_views.sql",
    "03_mart_basket.sql",
    "10_q01_demo_coverage.sql",
    "11_q02_join_integrity.sql",
    "12_q03_category_mix.sql",
    "13_q04_promo_intensity.sql",
    "14_q05_campaign_funnel.sql",
    "15_q06_commodity_ranks.sql",
    "16_q07_hh_cohorts.sql",
    "17_q08_repeat_purchase.sql",
    "18_q09_coupon_efficiency.sql",
    "19_q10_data_gap_watchlist.sql",
]


def run_file(con, path: Path) -> None:
    sql = path.read_text()
    # Strip pure line comments that are not inside statements is unnecessary —
    # DuckDB accepts -- comments. Execute as one script.
    print(f"→ {path.name}")
    con.execute(sql)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--db", type=Path, default=DEFAULT_DB)
    parser.add_argument("--only", nargs="*", help="Optional subset of SQL filenames")
    parser.add_argument("--export-samples", action="store_true")
    args = parser.parse_args()

    try:
        import duckdb
    except ImportError:
        print("Install: python3 -m pip install duckdb", file=sys.stderr)
        return 1

    tx = ROOT / "data" / "raw" / "transactions.csv"
    if not tx.exists():
        print("Missing data/raw/transactions.csv — run scripts/download_data.py first", file=sys.stderr)
        return 1

    files = ORDER
    if args.only:
        files = args.only

    con = duckdb.connect(str(args.db))
    # Make project root available for relative read_csv paths in SQL
    con.execute(f"SET file_search_path = '{ROOT.as_posix()}'")
    for name in files:
        path = SQL_DIR / name
        if not path.exists():
            print(f"Missing {path}", file=sys.stderr)
            return 1
        run_file(con, path)

    if args.export_samples:
        out = ROOT / "outputs" / "sample"
        out.mkdir(parents=True, exist_ok=True)
        exports = {
            "dq_results.csv": "SELECT * FROM dq_results ORDER BY check_id",
            "q01_demo_coverage.csv": "SELECT * FROM q01_demo_coverage",
            "q05_campaign_funnel.csv": "SELECT * FROM q05_campaign_funnel ORDER BY campaign_type",
            "q04_promo_intensity.csv": "SELECT * FROM q04_promo_intensity ORDER BY sales_value DESC LIMIT 15",
        }
        for fname, q in exports.items():
            try:
                con.execute(q).fetchdf().to_csv(out / fname, index=False)
                print(f"exported outputs/sample/{fname}")
            except Exception as exc:  # noqa: BLE001
                print(f"skip {fname}: {exc}")

    print(f"Done → {args.db}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
