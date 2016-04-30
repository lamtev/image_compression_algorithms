#!/bin/bash

make_presentation() {
	cd presentation
	if [ -e "presentation.tex" ]; then
		pdflatex presentation.tex
		pdflatex presentation.tex
		rm -f *.aux *.log *.dvi *.toc *.out *.snm *.nav
		cd ..
	else
		echo "presentation.tex"
		echo "presentation failure!"
		cd ..
		return 1
	fi
}

make_essay() {
	cd essay
	if [ -e "essay.tex" ]; then
		pdflatex essay.tex
		pdflatex essay.tex
		mkdir html 
		cd html
		htlatex ../essay.tex
		cd ..
		rm -f *.aux *.log *.dvi *.toc *.out
		cd ..
	else
		echo "essay.tex"
		echo "essay failure!"
		cd ..
		return 1
	fi
}

zip_artifacts() {
    ls
	if [ -z ${JOB_NAME} ] || [ -z ${BUILD_NUMBER}]; then
		echo "Vars JOB_NAME/BUILD_NUMBER are unset"
		echo "Zip failure!"
		return 1
	fi

	TITLE="${JOB_NAME}_v${BUILD_NUMBER}"
	mkdir "$TITLE"

	if [ -e "presentation/presentation.pdf" ]; then
		cp presentation/presentation.pdf $TITLE/Presentation_v${BUILD_NUMBER}.pdf
	else
		echo "report does not exist"
		echo "zip failure!"
	fi
	
	if [ -e "essay/essay.pdf" ]; then
		cp essay/essay.pdf $TITLE/essay_v${BUILD_NUMBER}.pdf
	else
		echo "essay does not exist"
		echo "zip failure!"
	fi
	
	zip --version
	zip $TITLE.zip $TITLE/*
}
