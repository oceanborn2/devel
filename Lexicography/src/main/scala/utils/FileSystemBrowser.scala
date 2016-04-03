package utils

import java.io.File

import scala.Array.canBuildFrom
import scala.util.matching.Regex

class FileSystemBrowser {
  def recursiveListFiles(f: File, r: Regex): Array[File] = {
    // http://stackoverflow.com/questions/2637643/how-do-i-list-all-files-in-a-subdirectory-in-scala
    val these = f.listFiles
    val good = these.filter(f => r.findFirstIn(f.getName).isDefined)
    good ++ these.filter(_.isDirectory).flatMap(recursiveListFiles(_, r))
  }

}
