
all: report

figures:
	./sync.sh

report: figures
	pdflatex report.tex

slides: figures
	mv ./figures/*.pdf ./.
	pdflatex slides.tex

clean: 
	rm -rf ./figures
	rm -f *.pdf *.aux *.log *.gz *.dvi *.nav *.snm *.out *.toc *~

