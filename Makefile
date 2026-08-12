build:
	@pandoc -f markdown -t pdf wsl/wsl.md -o wsl/wsl.pdf --pdf-engine=xelatex -V mainfont="Noto Serif CJK SC"

.PHONY: build clean

clean:
	@rm wsl/wsl.pdf
