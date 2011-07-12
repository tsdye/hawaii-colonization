CC=gcc
EMACS=emacs
BATCH_EMACS=$(EMACS) --batch -Q -l init.el colonization.org

all: colonization.pdf

colonization.tex: colonization.org
	$(BATCH_EMACS) -f org-export-as-latex

colonization.pdf: colonization.tex
	rm -f colonization.aux 
	if pdflatex colonization.tex </dev/null; then \
		true; \
	else \
		stat=$$?; touch colonization.pdf; exit $$stat; \
	fi
	bibtex colonization
	while grep "Rerun to get" colonization.log; do \
		if pdflatex colonization.tex </dev/null; then \
			true; \
		else \
			stat=$$?; touch colonization.pdf; exit $$stat; \
		fi; \
	done

colonization.ps: colonization.pdf
	pdf2ps colonization.pdf

clean:
	rm -f *.aux *.log colonization.ps *.dvi *.blg *.bbl *.toc *.tex *~ *.out colonization.pdf *.xml *.lot colonization-blx.bib *.lof

real-clean: clean
	rm -f *.pdf
