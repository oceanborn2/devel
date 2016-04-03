package core

/**
 * Language class
 */
case class Language(code: String, iso: String, description: String)

/**
 * Gender enumeration
 */
object Gender extends Enumeration {
  type Gender = Value
  val UNKNOWN = Value(0, "Unknown")
  val NOUN = Value(1, "Noun")
  val PRONOUN = Value(2, "Pronoun")
  val ADJECTIVE = Value(3, "Adjective")
  val VERB = Value(4, "Verb")
}

import Gender._

/**
 * Relationship enumeration
 */
object RelationShip extends Enumeration {
  type RelationShip = Value
  val SYNONYM = Value(1, "Synonym")
  val ANTONYM = Value(2, "Antonym")
  val HOMONYM = Value(3, "Homonym")
  val ALTSPELL = Value(4, "Alternative spelling")
  val PALINDROME = Value(5, "Palindrome")
  val REVERSED = Value(6, "Reversed")
  val HYPERONYM = Value(7, "Hyperonym")
  // parent word ?
  val HYPONYM = Value(8, "Hyponym") // child word ?
}

import RelationShip._

case class WordLink(word: Word, rel: RelationShip, gender: Gender = UNKNOWN)

/**
 * Word class
 */
class Word(id: Int, token: String) {

  /**
   * Word unique id
   */
  def ident = id

  /**
   * Actual work token
   */
  def tok = token

  /**
   * to lowercase
   */
  def lower = token.toLowerCase()

  /**
   * to uppercase
   */
  def upper = token.toUpperCase()

  /**
   * This word's relationships
   */
  var rels = Array[WordLink]()

  /**
   * Add a new word relationship with an optional gender
   */
  def addNew(rel: RelationShip)(word: Word, gender: Gender = UNKNOWN) = {
    val wl = WordLink(word, rel, gender)
    println("wl:" + wl + " wl.gender: " + wl.gender + " wl.rel:" + wl.rel + " wl.word:" + wl.word.tok)
    rels :+= wl
  }

  /**
   * Add a new synonym
   */
  def addSyn(word: Word, gender: Gender = UNKNOWN) = addNew(SYNONYM)(word, gender)

  /**
   * Add a new antonym
   */
  def addAnt(word: Word, gender: Gender = UNKNOWN) = addNew(ANTONYM)(word, gender)

  /**
   * Retrieves the list of synonyms
   */
  def syn = {
    rels.filter(_.rel == SYNONYM)
  }

  /**
   * Retrieves the list of antonyms
   */
  def ant = {
    rels.filter(_.rel == ANTONYM)
  }
}


