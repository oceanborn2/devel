#!/bin/bash

java -Xms512m -Xmx2048m -jar tools/pdfbox-app-2.0.3.jar ExtractText $*

# "C:\Program Files\Calibre2\ebook-convert.exe" %* 

