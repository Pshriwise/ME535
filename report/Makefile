
all: report

figures:
	./sync.sh

report: figures
	pdflatex report.tex

clean: 
	rm *.pdf *.aux *.log
	rm -rf figs
