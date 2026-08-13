build:
	@cd wsl && pandoc -f markdown -t pdf wsl.md -o wsl.pdf \
		--pdf-engine=xelatex --template eisvogel --listings \
		-V mainfont="Verdana" -V CJKmainfont="Maple Mono NF CN" -V monofont="JetBrainsMono NF"
	@echo Build successful.

.PHONY: build clean

clean:
	@cd wsl && rm -f wsl.pdf
