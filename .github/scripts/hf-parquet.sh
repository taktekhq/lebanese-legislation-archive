#!/usr/bin/env bash
# Turn the archive checkout into the Hugging Face Parquet files: one file per page
# type, one row per page, with the index columns and the page's exact bytes.
#
#   .github/scripts/hf-parquet.sh OUT_DIR
#
# Run from the root of a full checkout. Needs the duckdb CLI.
set -euo pipefail
OUT="${1:?usage: hf-parquet.sh OUT_DIR}"
mkdir -p "$OUT/data"
duck() { duckdb -c "SET preserve_insertion_order=false; SET temp_directory='${TMPDIR:-/tmp}/duckdb'; $1"; }
for dir in */; do
  typ="${dir%/}"
  [ "$typ" = pages ] && continue
  if [ -f "$typ.tsv" ]; then index="'$typ.tsv'"; else index="'$typ-[0-9][0-9].tsv'"; fi
  duck "COPY (
    SELECT CAST(i.doc_id AS BIGINT) AS doc_id, i.url, i.title, i.first_seen, i.last_changed,
           i.content_sha, i.blob_sha, CAST(i.raw_bytes AS BIGINT) AS raw_bytes,
           p.filename AS path, p.content AS html
    FROM read_csv($index, delim='\t', header=true, quote='', escape='', all_varchar=true) i
    LEFT JOIN read_blob('$typ/*/*.html') p
      ON p.filename = printf('%s/%04d/%d.html', '$typ', CAST(i.doc_id AS BIGINT) // 1000, CAST(i.doc_id AS BIGINT))
    ORDER BY doc_id
  ) TO '$OUT/data/$typ.parquet' (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 2000);"
  echo "$typ: $(du -h "$OUT/data/$typ.parquet" | cut -f1)"
done
duck "COPY (
  SELECT i.url, i.first_seen, i.last_changed, i.content_sha, i.blob_sha, p.filename AS path, p.content AS html
  FROM read_csv('pages.tsv', delim='\t', header=true, quote='', escape='', all_varchar=true) i
  LEFT JOIN read_blob('pages/*.html') p
    ON p.filename = 'pages/' || regexp_replace(regexp_replace(i.url, '^[^/]*//[^/]*/', ''), '[^A-Za-z0-9.=-]+', '_', 'g') || '.html'
  ORDER BY i.url
) TO '$OUT/data/pages.parquet' (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 2000);"
echo "pages: $(du -h "$OUT/data/pages.parquet" | cut -f1)"
# Every page in an index must have its file, and every file must be in an index.
duck "SELECT 'missing pages: ' || count(*) FILTER (WHERE html IS NULL) || ' of ' || count(*) FROM read_parquet('$OUT/data/*.parquet')"
