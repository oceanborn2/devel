package decoders

import core.Dictionary

trait Reader {
  def parse(filename: String, encoding: String, headerLines: Int, dict: Dictionary, startCountingAt: Int): Int
}
