function normal(texte) {
	wordObj.Selection.TypeParagraph(texte);
}

function titre(title, level) {
	wordObj.Selection.TypeParagraph(title);
	style = 'Titre ' + level.toString(); // valeur numérique
	wordObj.Selection.Style = doc.Styles(style);
}

// Démarrage de l'API Automation 
var wordObj = new ActiveXObject("Word.Application");
var doc = wordObj.Documents.Add();
doc.Activate();

try {
	try {
		with (wordObj) {
			var titre1 = ActiveDocument.Styles ("Titre 1");
			var titre2 = ActiveDocument.Styles ("Titre 2");
			for (var i = 0; i <= 10; i++) {
				//var p = ActiveDocument.Content.Paragraphs.Add();
				//Selection = p.Range;
				Selection.TypeText("Titre1_" + i.toString());
				Selection.Style = titre1;
				Selection.TypeParagraph();

				for (var j = 0; j <= 10; j++) {
					Selection.TypeText("Titre2_" + i.toString());
					Selection.Style = titre2;
					Selection.TypeParagraph();
					
					//p = ActiveDocument.Content.Paragraphs.Add();
					//Selection = p.Range;
					Selection.TypeText("Texte normal");
					Selection.TypeParagraph();
					
					var t = ActiveDocument.Tables.Add();
					Selection = t.Range;
					
					
					
					
					Selection.Add(t);
				}
				
			}
		}
	} finally {
		Session.Output("Sauvegarde du document");
		doc.SaveAs("cdcobs");
	}
} catch(e) {
	Session.Output("Erreur: " + e);
	doc.SaveAs("cdcobs");
	wordObj.Quit();
	throw e;
} finally {
	wordObj.Quit();
}

