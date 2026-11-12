# Download notes

1. Prefer the automated script: `python3 scripts/download_data.py` (needs `pyreadr`, `pandas`).
2. Manual alternative: clone or curl files from  
   `https://github.com/bradleyboehmke/completejourney/tree/master/data`  
   then convert `.rda` / `.rds` → CSV (same script does this).
3. Official Dunnhumby Source Files page also hosts Complete Journey; if you use that dump, map column names to the schema in `docs/schema.md` (IDs may differ slightly from the R package extract).
4. Place CSVs in `data/raw/`. Do not commit them.
5. `promotions.csv` is large (~20M rows). Core Q01–Q10 run without it; load only if you enable optional promo-support queries.
