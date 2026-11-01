---
pretty_name: Lebanese Legislation source pages
language:
- ar
- fr
license: other
license_name: public-texts-credit-the-centre
license_link: https://lebaneselegislation.com/data/
tags:
- legal
- law
- lebanon
- html
- web-archive
size_categories:
- 100K<n<1M
configs:
- config_name: law
  data_files: data/law.parquet
- config_name: lawtext
  data_files: data/lawtext.parquet
- config_name: lawarticle
  data_files: data/lawarticle.parquet
- config_name: lawsection
  data_files: data/lawsection.parquet
- config_name: ruling
  data_files: data/ruling.parquet
- config_name: opinion
  data_files: data/opinion.parquet
- config_name: agreement
  data_files: data/agreement.parquet
- config_name: article
  data_files: data/article.parquet
- config_name: journal
  data_files: data/journal.parquet
- config_name: research
  data_files: data/research.parquet
- config_name: news
  data_files: data/news.parquet
- config_name: custompage
  data_files: data/custompage.parquet
- config_name: pages
  data_files: data/pages.parquet
---

# Lebanese Legislation source pages

Every page behind [lebaneselegislation.com](https://lebaneselegislation.com/), exactly as
[legallaw.ul.edu.lb](https://legallaw.ul.edu.lb/) served it: one row per page, with the
page's bytes in `html`. The structured database built from these pages is
[taktekhq/lebanese-legislation](https://huggingface.co/datasets/taktekhq/lebanese-legislation).

This dataset is generated from the GitHub repository
[taktekhq/lebanese-legislation-archive](https://github.com/taktekhq/lebanese-legislation-archive)
on every change. Each page's change history is there, in git.

## Columns

`doc_id`, `url`, `title`, `first_seen`, `last_changed`, `content_sha`, `blob_sha`,
`raw_bytes`, `path` (the file in the repository) and `html` (the exact bytes served).
The `pages` subset (listing and search pages) has no `doc_id`, `title` or `raw_bytes`.

## Terms

The pages are from the Centre for Research and Studies in Legal Informatics, Lebanese
University. Credit the Centre when you reuse them. This is an independent, unofficial
archive, without state or University endorsement. We add no rights or restrictions over
the source documents. It is not legal advice or an official publication.
