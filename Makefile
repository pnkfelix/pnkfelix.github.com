index.html: index.txt
	perl Markdown_1.0.1/Markdown.pl index.txt > index.html

%.html: %.txt
	perl Markdown_1.0.1/Markdown.pl $< > $@
