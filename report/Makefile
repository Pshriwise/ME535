
all: report

figures:
	./sync.sh

report: figures
	pdflatex report.tex

clean: 
	rm -rf ./figures
	rm *.pdf *.aux *.log

