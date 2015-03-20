class Utils {

	def runLiveEditor(args) {
		def LEPath = 'C:/Program Files (x86)/Hewlett-Packard/HP Exstream/LiveEditor 4.0.104/Live.exe'
		def command = "${LEPath} "      // Create the String
		def proc = command.execute()    // Call *execute* on the string
		proc.waitFor()                  // Wait for the command to finish
	}
	
	def base64toString (String s) {
		if (s.size()==0 || s.trim().size() == 0) { '' } 
		byte[] decBytes = s.decodeBase64()
		new String(decBytes)
	}

	def getStringAsArray(String fullText) {
		def lines = []
		fullText.split("\r\n").each { String it -> lines.add(it) } //collect() //each ( it -> 
		lines
	}

}


