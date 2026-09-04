# AGENTS.md

Workshop teaching materials (Missing Workshop 26FA, TechGC). No application code — only documents.

## Layout

- `src/` — Beamer slide deck. `src/main.tex` is the entrypoint; each topic is a `\include`d section file (`techji.tex`, `package.tex`, `shell.tex`, `mac.tex`, `vscode.tex`, `markdown.tex`, `recommend.tex`, `thanks.tex`). New slides go in the matching section file, not `main.tex`. This branch (`Mac`) is macOS-only; the cross-platform version with the WSL guide lives on branch `26fa-update`.
- `markdown/` — handout docs for attendees (setup + grammar demo), not built.
- `src/publicity/advertise.md` — recruitment/PR copy, separate from the deck.

## Build

- `make build` — runs latexmk (xelatex) on `src/main.tex` (intermediates in `build/`, final PDF in `src/`).
- `make clean` — removes `build/` and `src/main.pdf` (regenerate with `make build`).
- The Beamer deck needs the `metropolis` theme and `minted`, which requires Pygments and `-shell-escape` (latexmk's default rule for xelatex adds it). `src/main.pdf` is committed — rebuild and commit it when slides change.
- Generated PDFs are committed; edit the sources, not the PDFs.

## Conventions

- Git LFS tracks `*.png`, `*.jpg`, `*.pdf`, `*.gif` — don't commit large binaries without it.
- LaTeX artifacts (`*.aux`, `*.log`, `_minted-main`, `build/`, etc.) are gitignored.
- Commit style is conventional commits (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`) with a `(mac)` scope.
- Content is aimed at freshmen without dev setup; keep wording beginner-friendly and verify any command/version claims against official docs before editing.
