build:
	@mkdir -p build
	@latexmk -xelatex -cd -outdir=$(CURDIR)/build -out2dir=$(CURDIR)/src src/main.tex 2>&1 > /dev/null
	@cd wsl && pandoc -f markdown -t pdf wsl.md -o wsl.pdf \
		--pdf-engine=xelatex --template eisvogel --filter pandoc-latex-environment --listings
	@echo Build successful.

.PHONY: build clean

clean:
	@cd wsl && rm -f wsl.pdf
