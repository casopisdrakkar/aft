#!/usr/bin/env bash

MARKDOWN_INPUT_FULLPATH=${1:?"Missing path to Markdown article source"}
MARKDOWN_INPUT=$(basename ${MARKDOWN_INPUT_FULLPATH})
ICML_INTERMEDIATE=${MARKDOWN_INPUT%.markdown}-intermediate.icml
ICML=${MARKDOWN_INPUT%.markdown}.icml
FLAVOUR=C
ARTICLE_TYPE=article

mkdir -p target 2> /dev/null

echo "Converting Markdown to intermediate InDesign ICML"
echo "Flavour: ${FLAVOUR}"

pandoc --verbose -i ${MARKDOWN_INPUT_FULLPATH} --o target/${ICML_INTERMEDIATE} --to icml+fenced_divs+raw_html+raw_attribute  --standalone --template template.icml --variable=articleFlavour="${FLAVOUR}"

echo "Patching intermediate ICML"

xsltproc --param articleFlavour "'${FLAVOUR}'" --param articleType "'${ARTICLE_TYPE}'" -o target/${ICML} drakkar.xslt target/${ICML_INTERMEDIATE}
