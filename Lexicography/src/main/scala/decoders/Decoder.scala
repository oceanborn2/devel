package decoders

import core.Dictionary
import core.Word

trait Decoder {
  def decode(fields: Array[String], dict: Dictionary): Option[Word]
}