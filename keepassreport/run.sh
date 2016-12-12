#!/bin/bash

shred -u -x -n 20 printable.fo printable.pdf
saxon printable.xml -xsl:XSL/KDBX_Tabular_FO.xsl -o:printable.fo && fop printable.fo printable.pdf
# shred -n 20 -u -x printable.fo printable.xml


