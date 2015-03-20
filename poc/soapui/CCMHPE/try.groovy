// 1st step: Run the SOAP request against the EWS web service and retrieve the base64 encoded response
// Either continue or stop based on error status
def step1RequestURL() {
	// grab the testcase and run it
	def groovyUtils = new com.eviware.soapui.support.GroovyUtils(context);  
	def stepBase = testRunner.testCase.testSteps["Requete_DLF_URL"]; 
	stepBase.run(testRunner, context)

	// retrieve the returning XML stream
	def xmlResult = stepBase.testRequest.response.getContentAsXml(); 
	log.info(xmlResult)
	
	// get a holder object to deal with XPATH 
	def responseHolder = groovyUtils.getXmlHolder(xmlResult)

	response = responseHolder.getNodeValues("//fileName/text()")
	log.info("returned URL : " + response[0].size() + " => " + response[0])
	response[0]
}

def step3RunLiveEditor(List<String> params) {
	def cmdLineArgs = params.join(" ")
	runLiveEditor(cmdLineArgs)
}

// *************************************************************
// Scenario entry point
// actual URL
def dlfPath = step1RequestURL()
step3RunLiveEditor([dlfPath])

'COMPLETED OK'



// *************************************************************
// utility functions
//

// decode a base64 string to a stream of bytes
def base64toBytes (String s) {
	if (s.size()==0 || s.trim().size() == 0) { '' } 
	byte[] decBytes = s.decodeBase64()
}

// decode a base64 string to a cleartext string
def base64toString (String s) {
	new String(base64toBytes(s))
}

// split a string and return an array of string
// splitting is done based on the sep character sequence
def getStringAsArray(String fullText,sep="\r\n") {
	def lines = []
	fullText.split(sep).each { String it -> lines.add(it) }  
	lines
}


// run the live editor
def runLiveEditor(cmdLine) {
	//def LEPath = 'C:/Program Files (x86)/Hewlett-Packard/HP Exstream/LiveEditor 4.0.104/Live.exe'
	def LEPath = 'C:/Program Files (x86)/Internet Explorer/iexplore.exe'
	def baseUrl = 'http://localhost:8080/DocServer/'
     def cmdLine2 = (cmdLine =~ /C\:\\HpExstream\\Outputs\\/).replaceFirst(baseUrl)
		
	//log.info(":::" + cmdLine)
	//def command = "${LEPath} ${cmdLine}"      
	//def proc = command.execute()    
	//proc.waitFor()    
}