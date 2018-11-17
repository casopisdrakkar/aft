O projekte
==========

Toto je konverzná pipeline pre prevod Markdown -> Adobe Indesign ICML format.

Softvérové požiadavky
--

* `pandoc`. 
* `xsltproc`
* `bash`

Detaily
=======
Adobe ICML je XML formát reprezentujúci kompletný vysádzaný dokument preAdobe InDesign. InDesign dokáže priamo importovať súbory ICML do dokumentu.


Drakkar
=======
Pipeline má nasledovné kroky

1. prevod Markdown na ICML pomocou `pandoc`. Výsledkom je XML súbor formátu ICML.
2. oprava a doplnenie vlastností, ktoré `pandoc` nezvládne, resp. nepodporuje, pomocou XSLT šablóny. Výsledkom je hotový opravený ICML súbor.


## Súbory

### `process.sh`
Štartovací skript, ktorý to spustí.

### `template.icml`
Šablóna používaná v `pandoc`u ako kostra pre výstupný súbor.

### `drakkar.xslt`
XSLT šablóna opravujúca nedostatky a bugy ICML, ktorý vylezie z `pandoc`u.

Použitie s `make`
===

    make VPATH=sample DESTDIR=target -d -r holmes-pes.icml jeste-jednou-holmes.icml
    
    