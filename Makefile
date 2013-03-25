all: index.html rust-questions.html

#%.html: %.txt
#	perl Markdown_1.0.1/Markdown.pl $< > $@

%.html: %.txt
	pandoc -s -f markdown -t html5 $< -o $@
