package decoders

import core.Dictionary

trait CSVReader extends Reader with Decoder {
  def separator: Char

  def parse(filename: String, encoding: String, headerLines: Int, dict: Dictionary, startCountingAt: Int): Int = {
    val count = startCountingAt
    val f = scala.io.Source.fromFile(filename, encoding)
    var lc = 0
    for (line: String <- f.getLines()) {
      if (headerLines == 0 | (headerLines > 0 && lc >= headerLines)) {
        val fields = line.split(separator)
        decode(fields, dict)
      }
      lc += 1
    }
    count
  }
}