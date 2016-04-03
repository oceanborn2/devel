package decoders.fr.syn

import core.Dictionary
import core.Word
import decoders.CSVReader
import decoders.Decoder

class FRThesaurusDecoder extends CSVReader with Decoder {
  def separator = ','

  def decode(fields: Array[String], dict: Dictionary): Option[Word] = {
    val baseWordOpt = dict.get(fields(0))
    if (baseWordOpt != None) {
      val baseWord = baseWordOpt.get
      fields.foreach {
        w =>
        //println("cand: " + w)
          val newSynOpt = dict.get(w)
          if (newSynOpt != None) {
            val newSyn = newSynOpt.get
            if (baseWord != newSyn) {
              //println("new syn:" + newSyn.tok + " for word: " + baseWord.tok)
              baseWord.addSyn(newSyn)
            }
          }
      }
    } else {
      println("not found word: " + fields(0))
    }
    return dict.register(fields(0).trim().toLowerCase())
  }
}

