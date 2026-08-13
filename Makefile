build:
	@cd wsl && pandoc -f markdown -t pdf wsl.md -o wsl.pdf \
		--pdf-engine=xelatex --template eisvogel --listings
	@echo Build successful.

.PHONY: build clean

clean:
	@cd wsl && rm -f wsl.pdf
