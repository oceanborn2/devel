import java.io.File

import core.{Dictionary, Language}
import decoders.fr.base.{LexiqueDecoder, PallierDecoder}
import decoders.fr.syn.FRThesaurusDecoder

object Main {

  def OSNAME = System.getProperty("os.name")

  /*val BASEPATH = if (OSNAME.indexOf("nux") > -1 || OSNAME.indexOf("nix") > -1) {
    "/media/lang/"
  } else {
    "c:/lang/"
  }*/

  val SOURCESPATH = "sources/"
  val FR_SOURCES = SOURCESPATH + "fr/"
  val EN_SOURCES = SOURCESPATH + "en/"

  val GUTENBERG = SOURCESPATH + "gutenberg/"
  val FR_GUTENBERG = GUTENBERG + "french/"


  def getBasicWords(): Dictionary = {
    println("osname:" + OSNAME)
    var dict = new Dictionary(Language("fr", "FR_fr", "francais"))

    val lexiquePath = FR_SOURCES + "lexique/Lexique3.txt"
    println("lexique path: " + lexiquePath)
    new LexiqueDecoder().parse(lexiquePath, "iso-8859-15", 1, dict, 0)
    println("dict size after lexique: " + dict.size + " words")

    val pallierPath = FR_SOURCES + "pallier/liste.de.mots.francais.frgut.txt"
    println("pallier path: " + pallierPath)
    new PallierDecoder().parse(pallierPath, "iso-8859-15", 0, dict, 0)
    println("dict size after pallier: " + dict.size + " words")

    println(dict.get("avoir").get)
    dict
  }

  def saveBasicWords(dict: Dictionary) {
    utils.utils.printToFile(new File("basicWords.txt"))(p => {
      dict.sorted.foreach(p.println _)
    })
  }

  def saveSynonyms(dict: Dictionary) {
    utils.utils.printToFile(new File("synonyms.txt"))(p => {
      dict.sortedWords.foreach((w) => {
        p.print(w.tok + ":")
        w.syn.foreach((wl) => p.print(wl.word.tok + ","))
        p.println()
      })
    })
  }

  def getSyn(dict: Dictionary) {
    val frthesPath = FR_SOURCES + "fr-thesaurus/fr-thesaurus.txt"
    new FRThesaurusDecoder().parse(frthesPath, "iso-8859-15", 1, dict, 0)
  }

  def main(args: Array[String]): Unit = {
    println("source path   : " + SOURCESPATH)
    println

    val dict = getBasicWords
    saveBasicWords(dict)
    getSyn(dict)
    saveSynonyms(dict)

    val ds = dict.stats
    println("dictionary stats: ")
    println("word entries: " + ds.entries)
    println("synonym entries: " + ds.syn)
    println("antonym entries: " + ds.ant)
    System.exit(0)
  }
}
