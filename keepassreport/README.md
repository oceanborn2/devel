A quick XSL stylesheet to transform Keepass XML into a nicely formatted PDF report using XSL:FO.

The XML is first transformed to XSL-FO via the XSL-T stylesheet and then FOP is used to transform it to PDF.

Please be aware that the PDF must be protected as it is in clear text.

Further development will try to provide PDF encryption and temporary files shredding.

Currently works with Saxon-HE and has not been tested with the Keepass embedded XSL-T processor. Anyway, it would only be able to produce an XSL-FO file.


