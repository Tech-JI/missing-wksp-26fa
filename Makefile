build:
	@mkdir -p build
	@latexmk -xelatex -cd -outdir=$(CURDIR)/build -out2dir=$(CURDIR)/src src/main.tex 2>&1 > /dev/null
	@echo Build successful.

.PHONY: build clean

clean:
	@rm -rf build
	@rm -f src/main.pdf
