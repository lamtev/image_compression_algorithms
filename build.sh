#!/bin/bash

make_presentation() {
	cd presentation
	if [ -e "presentation.tex" ]; then
		pdflatex presentation.tex
		pdflatex presentation.tex
                htlatex presentation.tex
		rm -f *.aux *.log *.dvi *.toc *.out *.snm *.nav *.lg *.tmp *.4tc *.4ct *idv *xref
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
		htlatex essay.tex
		rm -f *.aux *.log *.dvi *.toc *.out *.lg *.tmp *.4tc *.4ct *idv *xref
		cd ..
	else
		echo "essay.tex"
		echo "essay failure!"
		cd ..
		return 1
	fi
}

compress_picture() {
	cd picture_for_compression
	if [ -e "shakal.jpg" ]; then
		cd ..
		mkdir compressed_pictures
		cd compressed_pictures
		mkdir temp
		
		jpegoptim --dest=temp/ --size=1 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/1.jpg
		mv temp/1.jpg ./
		
		jpegoptim --dest=./temp/ --size=10 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/2.jpg
		mv temp/2.jpg ./
		
		jpegoptim --dest=./temp/ --size=20 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/3.jpg
		mv temp/3.jpg ./
		
		jpegoptim --dest=./temp/ --size=30 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/4.jpg
		mv temp/4.jpg ./
		
		jpegoptim --dest=./temp/ --size=40 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/5.jpg
		mv temp/5.jpg ./
		
		jpegoptim --dest=./temp/ --size=50 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/6.jpg
		mv temp/6.jpg ./
		
		jpegoptim --dest=./temp/ --size=60 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/7.jpg
		mv temp/7.jpg ./
		
		jpegoptim --dest=./temp/ --size=70 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/8.jpg
		mv temp/8.jpg ./
		
		jpegoptim --dest=./temp/ --size=80 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/9.jpg
		mv temp/9.jpg ./
		
		jpegoptim --dest=./temp/ --size=90 ../picture_for_compression/shakal.jpg
		mv temp/*.jpg temp/10.jpg
		mv temp/10.jpg ./
		
		cd ..
		
	else
		echo "picture not found"
		cd ..
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
	cd $TITLE
	mkdir pics
	cd ..
	
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
	
	cd compressed_pictures
	FOUND=$(find ./ -name "*.jp*g" -print -quit)
	if ! [ "X$FOUND" = "X" ]; then 
	#if [ -e "*.jpg" ]; then
		cd ..
		mv -i $(find compressed_pictures/ -name "*.jpg") $TITLE/pics/
	else
		echo "pictures does not exist"
		echo "zip failure"
	fi
	
	zip --version
	zip $TITLE.zip $TITLE/*
}
