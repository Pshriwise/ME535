
all: report

figures:
	./sync.sh

report: figures
	pdflatex report.tex

slides: figures
	pdflatex slides.tex

clean: 
	rm -rf ./figures
	rm -f slides.pdf report.pdf *.aux *.log *.gz *.dvi *.nav *.snm *.out *.toc *~

