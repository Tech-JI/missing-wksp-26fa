# AGENTS.md

Workshop teaching materials (Missing Workshop 26FA, TechGC). No application code — only documents.

## Layout

- `src/` — Beamer slide deck. `src/main.tex` is the entrypoint; each topic is a `\include`d section file (`package.tex`, `shell.tex`, `vscode.tex`, `markdown.tex`, `recommend.tex`, `thanks.tex`). New slides go in the matching section file, not `main.tex`.
- `wsl/wsl.md` — standalone WSL install guide, compiled to PDF via pandoc. Contains embedded HTML/CSS styling (pandoc-specific); keep the `<style>` block when editing.
- `markdown/` — handout docs for attendees (setup + grammar demo), not built.
- `src/publicity/advertise.md` — recruitment/PR copy, separate from the deck.

## Build

- `make build` — runs pandoc inside `wsl/` (`wsl/wsl.md` → `wsl/wsl.pdf`) so image paths in the markdown are plain filenames. Uses `-f markdown-smart`, xelatex, the **eisvogel** pandoc template, and fonts Times New Roman + **SimSun** (CJK). Requires `pandoc`, `xelatex`, the eisvogel template, and those fonts installed; CI-free, builds only on your machine.
- `make clean` — removes `wsl/wsl.pdf` only.
- The Beamer deck has **no make target**: compile `src/main.tex` directly (needs the `metropolis` theme and `minted`, which requires Pygments and `-shell-escape`). `src/main.pdf` is committed — rebuild and commit it when slides change.
- Generated PDFs are committed; edit the sources, not the PDFs.

## Conventions

- Git LFS tracks `*.png`, `*.jpg`, `*.pdf`, `*.gif` — don't commit large binaries without it.
- LaTeX artifacts (`*.aux`, `*.log`, `_minted-main`, etc.) are gitignored.
- Commit style is conventional commits (`feat:`, `fix:`, `docs:`, `chore:`); PRs are used for wsl/ content (see history).
- Content is aimed at freshmen without dev setup; keep wording beginner-friendly and verify any command/version claims against official docs before editing.
