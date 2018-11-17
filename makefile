.POSIX:

FLAVOUR = C
ARTICLE_TYPE = article

.SUFFIXES: .markdown .iiml .icml

.markdown.iiml:
	pandoc --verbose $< --output $*.iiml --to icml+fenced_divs+raw_html+raw_attribute --standalone --template template.icml --variable=articleFlavour="${FLAVOUR}"
.iiml.icml:
	xsltproc --param articleFlavour "'${FLAVOUR}'" --param articleType "'${ARTICLE_TYPE}'" --output $*.icml drakkar.xslt $<
