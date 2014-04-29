#!/bin/bash
# Extracting figure captions from fulltext PLOS ONE HTML

for j in *.html
	do
	STEM=$(echo $j | cut -c 1-12)
	echo "$STEM"
	CAPNUM=$(egrep '<p><strong>Figure [0-9][0-9]?\.' $j | wc -l)
	if [ $CAPNUM -eq 0 ]
	then 
	:
	else
		mkdir $STEM
			for i in $(seq 1 $CAPNUM)
			do
			echo "$i"
			cmd="awk '/<p><strong>Figure [0-9][0-9]?\./{x++}x==$i' $j | sed -n '/<p><strong>Figure/,/<span>doi:10.1371/p' | sed '/<span>doi:10.1371/d'  > ./$STEM/$STEM.cap.$i"
			eval "$cmd"
			echo "stage 1"
			done
			echo "stage 2"
	fi
	echo "stage 3"
done
