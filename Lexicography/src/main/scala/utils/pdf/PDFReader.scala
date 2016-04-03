package utils.pdf

import java.io.{File, FileOutputStream, PrintWriter}
import com.itextpdf.text.pdf.parser._
import com.itextpdf.text.pdf.{PdfName, PdfDictionary, PdfReader}
import org.apache.pdfbox.pdmodel.PDDocument
import org.apache.pdfbox.util.PDFTextStripper

class MyTextRenderListener(out: PrintWriter) extends RenderListener {

  var lastText: String = ""

  def beginTextBlock {
    if (lastText.trim() == "") {
      out.println()
    }
  }

  def renderText(renderInfo: TextRenderInfo) {
    //    val bls: LineSegment = renderInfo.getBaseline()
    //    val als: LineSegment = renderInfo.getAscentLine()
    //    val dls: LineSegment = renderInfo.getDescentLine()
    //    val blss = bls.toString()
    //    out.println(blss.substring(40))
    lastText = renderInfo.getText()
    out.print(lastText)
  }

  def endTextBlock() {
    out.println()
  }

  def renderImage(renderInfo: ImageRenderInfo) {

  }
}

class PDFReader {

  /**
   * Extracts text from a PDF document.
   * @param sourceFile  the original PDF document
   * @param destFile the resulting text file
   * @throws IOException
   */
  def extractText_itext(sourceFile: String, destFile: String, fromPage: Int = 1, toPage: Int) {
    val out: PrintWriter = new PrintWriter(new FileOutputStream(destFile))
    val reader: PdfReader = new PdfReader(sourceFile)
    val numberOfPages = reader.getNumberOfPages()
    val listener: RenderListener = new MyTextRenderListener(out)
    val processor = new PdfContentStreamProcessor(listener)
    try {
      out.println("<Document nbPage=\"" + numberOfPages + "\" >")
      out.println("<Extract from=\"" + fromPage + "\" to=\"" + toPage + "\">")
      for (i <- fromPage to (if (toPage < 0) numberOfPages else toPage)) {
        out.print("<Page n=" + i + ">")
        try {
          val pageDic: PdfDictionary = reader.getPageN(i)
          val resourcesDic = pageDic.getAsDict(PdfName.RESOURCES)
          processor.processContent(ContentByteUtils.getContentBytesForPage(reader, i), resourcesDic)
        } finally {
          out.println("</Page>")
        }
      }
    } finally {
      out.println("</Extract>")
      out.println("</Document>")
      out.flush()
      out.close()
    }
  }

  def extractText_pdfbox(sourceFile: String, destFile: String, fromPage: Int = 1, toPage: Int) {
    val doc = PDDocument.load(new File(sourceFile))
    val stripper: PDFTextStripper = new PDFTextStripper()
    val numberOfPages = doc.getNumberOfPages()
    stripper.setStartPage(fromPage)
    stripper.setEndPage((if (toPage < 0) numberOfPages else toPage))
    stripper.writeText(doc, new PrintWriter(new FileOutputStream(destFile)))
  }

}