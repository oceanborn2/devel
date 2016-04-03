package decoders.fr.base

import core.Dictionary
import core.Word
import decoders.CSVReader
import decoders.Decoder

class PallierDecoder extends CSVReader with Decoder {
  def separator = '\t'

  def decode(fields: Array[String], dict: Dictionary): Option[Word] = {
    return dict.register(fields(0).trim().toLowerCase())
  }
}