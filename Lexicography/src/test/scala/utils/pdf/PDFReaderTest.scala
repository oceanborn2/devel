package utils.pdf

object PDFReaderTest {
  def main(args: Array[String]) {
    val reader: PDFReader = new PDFReader()
    reader.extractText_itext(
      TestsConstants.FR_GUTENBERG + "hugo_les_miserables_fantine.pdf",
      TestsConstants.FR_GUTENBERG + "hugo_les_miserables_fantine_itext.txt", 1, 496)

    reader.extractText_pdfbox(
      TestsConstants.FR_GUTENBERG + "hugo_les_miserables_fantine.pdf",
      TestsConstants.FR_GUTENBERG + "hugo_les_miserables_fantine_pdfbox.txt", 1, 496)

  }
}

