package utils.pdf

object TestsConstants {
  def OSNAME = System.getProperty("os.name")

  val BASEPATH = if (OSNAME.indexOf("nux") > -1 || OSNAME.indexOf("nix") > -1) {
    "/media/Acer_/lang/"
  } else {
    "c:/lang/"
  }
  val SOURCESPATH = BASEPATH + "sources/"
  val FR_SOURCES = SOURCESPATH + "fr/"
  val EN_SOURCES = SOURCESPATH + "en/"

  val GUTENBERG = SOURCESPATH + "gutenberg/"
  val FR_GUTENBERG = GUTENBERG + "french/"

}