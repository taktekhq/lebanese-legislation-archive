# Lebanese Legislation: the source pages

Every page behind [lebaneselegislation.com](https://lebaneselegislation.com/), exactly as
[legallaw.ul.edu.lb](https://legallaw.ul.edu.lb/) served it: the Lebanese University's
Centre for Research and Studies in Legal Informatics. One file per document holds the
current version; git history keeps every earlier one, so `git log -p law/0007/7815.html`
shows when and how a page changed.

The database in [taktekhq/lebanese-legislation](https://github.com/taktekhq/lebanese-legislation)
is built from these pages, and every law text in it is checked to be a span of its page here.
That repository mounts this one at `archive/` as a git submodule, so a plain clone of it
does not download these 606,000 pages.

## Get it

```sh
git clone https://github.com/taktekhq/lebanese-legislation-archive.git   # about 1.3 GB, 18 GB checked out
# or, inside a clone of lebanese-legislation:
git submodule update --init archive
```

To fetch only some types, clone without the pages and check out what you need:

```sh
git clone --filter=blob:none --sparse https://github.com/taktekhq/lebanese-legislation-archive.git
cd lebanese-legislation-archive && git sparse-checkout set law
```

The same pages are on Hugging Face as Parquet, one row per page:
[taktekhq/lebanese-legislation-archive](https://huggingface.co/datasets/taktekhq/lebanese-legislation-archive).
They are rebuilt from this repository on every change by
[the huggingface workflow](.github/workflows/huggingface.yml).

## What is here

| Path | What |
|---|---|
| `<type>/<id ÷ 1000>/<id>.html` | the page of one document, e.g. `law/0007/7815.html` for law 7815 |
| `<type>.tsv` or `<type>-NN.tsv` | the index of a type: `doc_id`, `url`, `title`, `first_seen`, `last_changed`, `content_sha`, `blob_sha`, `raw_bytes`; split in parts of 100,000 ids when large |
| `pages/`, `pages.tsv` | the site's listing and search pages, named after their address |

Types: `law` (the law's page), `lawtext` (its full text), `lawarticle`, `lawsection`,
`ruling`, `opinion`, `agreement`, `article`, `journal`, `research`, `news`, `custompage`.

A document the site stops serving is removed from the current files; its history stays.
The `http://` and `https://` addresses of the same listing page share one file in `pages/`.

## How it is updated

A scraper reads the site every day and commits what changed, one commit per type:
`archive: law, 5 pages changed (2026-10-31)`. History before 1 Nov 2026 comes from the
private repository where the archive started, kept commit for commit.

## Terms

The pages are the Centre's. Credit the Centre for Research and Studies in Legal
Informatics, Lebanese University, when you reuse them. This is an independent, unofficial
archive, without state or University endorsement. We add no rights or restrictions over the
source documents. It is not legal advice or an official publication.
