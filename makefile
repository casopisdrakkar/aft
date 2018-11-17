.POSIX:

FLAVOUR = C
ARTICLE_TYPE = article
DESTDIR = .

%.iiml: %.markdown
	pandoc --verbose $< --output $@ --to icml+fenced_divs+raw_html+raw_attribute --standalone --template template.icml --variable=articleFlavour="${FLAVOUR}"
%.icml: %.iiml
	xsltproc --param articleFlavour "'${FLAVOUR}'" --param articleType "'${ARTICLE_TYPE}'" --output ${DESTDIR}/$@ drakkar.xslt $<
