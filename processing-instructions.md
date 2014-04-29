# Finding Phylogenetic Figure Captions & Figures in PLOS ONE articles

## Author: 
Ross Mounce, University of Bath

## Operating System and specific software tools used in this article
Ubuntu Linux 14.04 LTS, *grep*, *tr*, *sed*, *wget*, *awk*, *mv*, *mmv*

## Aim:

We want to automate the process of determining if a figure caption of a scientific paper relates to a phylogenetic tree figure (image). We will start-off approaching this as a binary classification problem; either the figure caption relates to a phylogenetic tree in the corresponding figure image (scored as '1'), or it does not (scored as '0'). This will help identify the figure images for which further processing is applicable, downstream, to attempt to convert (only) phylogenetic tree images back into open, immediately re-usable, machine-readable data. 


## Method:

Legally-obtain full text articles from the PLOS ONE website corresponding to the first 2000 articles published.

For this I simply iterated n+1 from the first PLOS ONE article published:
http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0000001
http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0000002
http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0002000

Eight numbers are not used by PLOS ONE in the range 1-2000, so I iterated to 0002008 to get 2000 articles:
* journal.pone.0000084
* journal.pone.0000951
* journal.pone.0000976
* journal.pone.0001140
* journal.pone.0001307
* journal.pone.0001432
* journal.pone.0001509
* journal.pone.0001726

According to Cameron Neylon [here](http://blogs.plos.org/opens/2014/03/09/best-practice-enabling-content-mining/) PLOS requires a 30 second crawl delay between downloads, so one can implement this with wget -w 30
```
wget -w 30 -i first-2000-PLOSONE-articles.txt
```


Tidying up:
```
mmv 'info_doi%2F10.1371%2Fjournal\.*' '#1.html'
mkdir 2000-HTML-articles
mv *.html 2000-HTML-articles/
```

## Parsing-out article data

The title of each article can be obtained from line 19 of each HTML file.
```
ls *.html | sed 's@\.html@@' > ../articleIDs.txt 
ls *.html | xargs awk "FNR==19" | sed -E -e 's@<title>PLOS ONE:@@' -e 's@</title>@@' -e 's@^[[:space:]]+@@g'  > ../titles.txt
ls *.html | xargs grep -h -m1 'name=\"citation_author\"' | sed -E -e 's@<meta name="citation_author" content="@@' -e 's@"/>@@' -e 's@^[[:space:]]+@@g' > ../firstauthors.txt
```

script to extract figure captions for each HTML file, creating them as separate plaintext files within an articleID subfolder:
```
#!/bin/bash
# Extracting figure captions from fulltext PLOS ONE HTML

for j in *.html
	do
	STEM=$(echo $j | cut -c 1-12)
	echo "article $STEM"
	CAPNUM=$(egrep '<p><strong>Figure [0-9][0-9]?\.' $j | wc -l)
	if [ $CAPNUM -eq 0 ]
	then 
	:
	else
		mkdir $STEM
			for i in $(seq 1 $CAPNUM)
			do
			echo "figure $i of $j"
			cmd="egrep -A7 '<p><strong>Figure $i' $j | sed 's@doi:10\.1371\/journal\.pone\.[0-9][0-9][0-9][0-9][0-9][0-9][0-9]\.g0[0-9][0-9]</span>.*@THISISTHEEND@' | sed '/<span>THISISTHEEND/q' > ./$STEM/$STEM.cap.$i"
			eval "$cmd"
			done
	fi
done
```

For this particular dataset of 2000 PLOS ONE articles from ID 0000001 to 0002008, only 1949 of these appear to have figures. In these 1949 articles there are 9880 figures ( find . -type f | wc -l ) 

## Searching parsed-out figure captions for phylogeny captions

Still to be written properly but here's what I imagine I'll do:

use grep -r

then for all grep hits we know PLOS has regular URL structure, so can download (& then analyze) the corresponding figure image for each relevant figure caption
e.g.

../pone.0001234/pone.0001234.cap.1
corresponds to
http://www.plosone.org/article/info:doi/10.1371/journal.pone.0001234.g001/originalimage

so just need to convert to that string format and wget
