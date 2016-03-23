#!/bin/sh

ls | grep .pdf \
    | while read line; do \
    TXTNAME=`echo $line | cut -d "." -f 1` 
    pdftotext $line $TXTNAME.txt \
	;done

FILENUM=`ls | grep .txt | wc | gsed -e "s@    @ @g" | awk '{print $2}'`
ls | grep .txt \
    | while read line; do \
    cat $line | gsed -e "s@ @@g" | head -15 | \
	while read vline; do \
	    LENGTH=`echo $vline | grep -v -E '^\【' | grep -v 論文 | grep -v 講演 | grep -v 学会 | grep -v 発表 | grep -v 大学 | grep -v 研究第 | gsed -e "s@ @@g" | wc`
	    #echo $LENGTH
	    LENGTH=`echo $LENGTH | gsed -e "s@   @ @g" | awk '{print $3}'`
	    
	    if [ 41 -lt $((LENGTH)) ]; then
		PDFNAME=`echo $line | cut -d "." -f 1`
		mv $PDFNAME.pdf $vline.pdf
		#echo $PDFNAME:$vline.pdf
		break
	    fi
	    done
    done
    
rm *.txt
