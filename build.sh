#!/bin/bash

create_build_job() {
        mkdir build
        cd build
        ls
        mkdir essay
        cd essay
        mkdir pdf
        mkdir html
        ls
        cd ..
        mkdir presentation
        cd presentation
        mkdir pdf
        mkdir html
        ls
        cd ../..
}

make_presentation() {
	if [ -e "presentation/presentation.tex" ]; then
                cd build/presentation/pdf
		pdflatex ../../../presentation/presentation.tex
		pdflatex ../../../presentation/presentation.tex
                cd ../html
                htlatex ../../../presentation/presentation.tex
		rm -f *.aux *.log *.dvi *.toc *.out *.snm *.nav
		cd ../../..
	else
		echo "presentation.tex"
		echo "presentation failure!"
		cd ..
		return 1
	fi
}

make_essay() {
	if [ -e "essay/essay.tex" ]; then
		cd build/essay/pdf
		pdflatex ../../../essay/essay.tex
		pdflatex ../../../essay/essay.tex
                cd ../html
                htlatex ../../../essay/essay.tex
		rm -f *.aux *.log *.dvi *.toc *.out *.tmp *.lg *.tmp *.4tc *.4ct *dvi *idv *xref 
		cd ../../..
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

	if [ -e "bulid/presentation/pdf/presentation.pdf" ]; then
		cp build/presentation/pdf/presentation.pdf $TITLE/Presentation_v${BUILD_NUMBER}.pdf
	else
		echo "report does not exist"
		echo "zip failure!"
	fi
	
	if [ -e "build/essay/pdf/essay.pdf" ]; then
		cp build/essay/pdf/essay.pdf $TITLE/essay_v${BUILD_NUMBER}.pdf
	else
		echo "essay does not exist"
		echo "zip failure!"
	fi
	
	zip --version
	zip $TITLE.zip $TITLE/*
}

clean_build_job() {
        if [ -r "build/" ]; then
                rm -r build
        else
                echo "build does not exist"
        fi
}
