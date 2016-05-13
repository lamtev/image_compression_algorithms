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
	FOUND=$(find ./ -name "*.jp*g" -print -quit)
	if ! [ "X$FOUND" = "X" ]; then 
	
		mv *.jp*g pic.jpg
		cd ..
		mkdir compressed_pictures
		cd compressed_pictures
		mkdir temp
		
		cp ../picture_for_compression/pic.jpg ./1.jpg
		
		jpegoptim --dest=./temp/ --max=90 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./2.jpg
		
		jpegoptim --dest=./temp/ --max=80 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./3.jpg
		
		jpegoptim --dest=./temp/ --max=70 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./4.jpg
		
		jpegoptim --dest=./temp/ --max=60 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./5.jpg
		
		jpegoptim --dest=./temp/ --max=50 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./6.jpg
		
		jpegoptim --dest=./temp/ --max=40 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./7.jpg
		
		jpegoptim --dest=./temp/ --max=30 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./8.jpg
		
		jpegoptim --dest=./temp/ --max=20 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./9.jpg
		
		jpegoptim --dest=./temp/ --max=10 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./91.jpg
		
		jpegoptim --dest=./temp/ --max=9 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./92.jpg
		
		jpegoptim --dest=./temp/ --max=8 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./93.jpg
		
		jpegoptim --dest=./temp/ --max=7 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./94.jpg
		
		jpegoptim --dest=./temp/ --max=6 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./95.jpg
		
		jpegoptim --dest=./temp/ --max=5 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./96.jpg
		
		jpegoptim --dest=./temp/ --max=4 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./97.jpg
		
		jpegoptim --dest=./temp/ --max=3 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./98.jpg
		
		jpegoptim --dest=./temp/ --max=2 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./99.jpg
		
		jpegoptim --dest=./temp/ --max=1 ../picture_for_compression/pic.jpg
		mv temp/pic.jpg ./991.jpg
		
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
	
	if [ -d ./compressed_pictures ]; then
		FOUND=$(find ./compressed_pictures -name "*.jp*g" -print -quit)
		if ! [ "X$FOUND" = "X" ]; then 
			mv -i $(find compressed_pictures/ -name "*.jpg") $TITLE/
		else
			echo "pictures does not exist"
			echo "zip failure"
		fi
	fi
	zip --version
	zip $TITLE.zip $TITLE/*
}
