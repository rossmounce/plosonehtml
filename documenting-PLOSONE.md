Base unique paper ID is a 7-digit number for each article, in the following examples we look at PLOS ONE article 0001234 which is titled 'Nogo Receptor 1 (RTN4R) as a Candidate Gene for Schizophrenia: Analysis Using Human and Mouse Genetic Approaches'

PLOS article full text HTML
http://dx.doi.org/10.1371/journal.pone.0001234
http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0001234

full text XML
http://www.plosone.org/article/fetchObjectAttachment.action?uri=info%3Adoi%2F10.1371%2Fjournal.pone.0001234&representation=XML

full text PDF
http://www.plosone.org/article/fetchObject.action?uri=info%3Adoi%2F10.1371%2Fjournal.pone.0001234&representation=PDF

citation RIS
http://www.plosone.org/article/getRisCitation.action?articleURI=info%3Adoi%2F10.1371%2Fjournal.pone.0001234

citation BibTex
http://www.plosone.org/article/getBibTexCitation.action?articleURI=info%3Adoi%2F10.1371%2Fjournal.pone.0001234

figure caption HTML
```
<p><strong>Figure 1.
```

Identifiers for each and every figure caption + figure in HTML
http://dx.doi.org/10.1371/journal.pone.0001234.g001

Figure image as PPT
http://www.plosone.org/article/info:doi/10.1371/journal.pone.0001234.g001/powerpoint

Figure image as PNG
http://www.plosone.org/article/info:doi/10.1371/journal.pone.0001234.g001/largerimage

Figure image as TIFF / 'original image' (largest in file size)
http://www.plosone.org/article/info:doi/10.1371/journal.pone.0001234.g001/originalimage

get unique number of figures in paper from HTML
grep '\.g[0-9][0-9][0-9].TIF' *.html | grep -v 'hidden' | wc

get all figure captions from each paper, one per line still HTMLized
egrep '<p><strong>Figure [0-9][0-9]?\.' FILE.html > captions.txt

for i in (egrep '<p><strong>Figure [0-9][0-9]?\.' FILE.html | wc)
	do
	touch $filename_plaincaptions.txt
	sed '$iq;d' captions.txt | awk -vRS="</span>" '/<span>/{gsub(/.*<span>|\n+/,"");print;exit}' >> $filename_plaincaptions.txt 	

get just text INSIDE span, i.e. the full plaintext of the figure caption
sed '1q;d' captions.txt | awk -vRS="</span>" '/<span>/{gsub(/.*<span>|\n+/,"");print;exit}'
 





