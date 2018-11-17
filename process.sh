#!/usr/bin/env bash

FLAVOUR=C
ARTICLE_TYPE=article

while getopts :c:t: OPT
do
	case "$OPT" in
		c) FLAVOUR="$OPTARG";;
		t) ARTICLE_TYPE="$OPTARG";;
		?) printf "Usage: %s: [-c COLOUR] [-t ARTICLETYPE] [FILE...]" $0; exit 2;;
	esac		
done
shift $(($OPTIND - 1))

[ "$@" ] || { echo "No files to process"; exit 2; }

SRCDIR=sample
ORIGINALDIR=$(pwd)
cd "$SRCDIR"

make --file "$ORIGINALDIR/makefile" \
	-r\
	DESTDIR="$ORIGINALDIR/target" \
	FLAVOUR="$FLAVOUR" \
	ARTICLE_TYPE="$ARTICLE_TYPE" \
	TEMPLATEDIR="$ORIGINALDIR" \
	"$@"
cd "$ORIGINALDIR"
