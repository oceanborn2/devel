package core

import java.util.Locale
import java.text.Collator
import scala.collection.mutable.HashMap

/**
 * Dictionary statistics
 */
case class DictionaryStats(entries: Int, syn: Int, ant: Int)

/**
 * Dictionary
 */
class Dictionary(lang: Language) {

  val locale = new Locale(lang.iso)

  val collator = Collator.getInstance(locale)
  /**
   * Dictionary content
   */
  var index = new HashMap[String, Word]

  /**
   * Dictionary size
   */
  def size = index.size

  /**
   * count duplicate words
   */
  var duplicates = 0

  /**
   * reset the duplicates counter
   */
  def resetDuplicateCount = duplicates = 0

  /**
   * Retrieves a word by its name
   */
  def get(tok: String): Option[Word] = index.get(tok)

  /**
   * Register a new word and updates the words count if the word did not exist already
   * Also accounts for duplicate words
   */
  def register(tok: String): Option[core.Word] = {
    var w: Option[core.Word] = index.get(tok)
    if (w != None) {
      duplicates += 1
      w
    } else {
      //w = new Word(index.size + 1, tok)
      index.+=((tok, new Word(index.size + 1, tok)))
      w
    }
  }

  /**
   * Words access as an iterator
   */
  def words = index.keys

  /**
   * Words access as a list
   */
  def asList = index.keys.toList

  /**
   * Sorted list of words (keys)
   */
  def sorted = asList.sortWith((e1, e2) =>
    collator.compare(e1, e2) < 0) //e1.compareTo(e2)>0)

  /**
   * Words instances
   */
  def sortedWords = index.values.toList.sortWith((e1, e2) => collator.compare(e1.tok, e2.tok) < 0)

  /**
   * Return the dictionary statistics
   */
  def stats: DictionaryStats = {
    var nbSyn = 0
    var nbAnt = 0
    index foreach ((t2) => {
      val w: Word = t2._2
      val syns = w.syn
      val nbNewSyn = w.syn.size //if (w.rels != None) w.rels.size else 0
      nbSyn += nbNewSyn
      val nbNewAnt = w.ant.size //if (w.rels != None) w.rels.size else 0
      nbAnt += nbNewAnt
      if (nbNewSyn > 0 || nbNewAnt > 0) {
        println("word: " + t2._1 + " => " + nbNewSyn + " , " + nbNewAnt)
      }
    })
    return DictionaryStats(index.size, nbSyn, nbAnt)
  }

}