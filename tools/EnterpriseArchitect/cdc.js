// Génération du cahier des charges des échanges

// Importer les fichiers sources externes
!INC Generics
!INC EAConstants
!INC EAHelper
!INC WordHelper
!INC Predicates
!INC Extract

function documenterUtilisateur(utilisateur, pName) {
//	if (utilisateur == null) 
//		return;	
	wh.title(utilisateur.Name, 2);
	wh.frametable(utilisateur.Notes);
}

function documenterService(service, pName) {
	wh.title(service.Name, 2);
	wh.frametable(service.Notes);
}

function documenterTheme(theme, pName) {
	wh.title(theme.Name, 2);
	wh.frametable(theme.Notes);
}

function documenterCasEtScenarios(cas, pName) {
	nomDuCas = cas.Name;
	var niveau = 2;
	try { nomDuCas.substring(0,2)== 'UC' ? 2: 3; } catch (e) {}
	wh.title(cas.Name, niveau);
	wh.frametable(cas.Notes);
}

function creerAppendices(donneesCom) {
	wh = new WordHelper();
	wh.begindocument("appendices.doc");	
 
	services       = donneesCom.services;
	utilisateurs   = donneesCom.utilisateurs;
	themes         = donneesCom.themes;
	casEtScenarios = donneesCom.casEtScenarios;
	try {
		try {
		wh.title("Liste des cas d'utilisation et des scénarios", 1);
		map(casEtScenarios, documenterCasEtScenarios, 'casEtScenarios');		

		wh.title('Liste des utilisateurs', 1);
		map(utilisateurs, documenterUtilisateur, 'utilisateurs');		

		wh.title("Liste des services", 1);
		map(services, documenterService, 'services');		

		wh.title("Liste des thèmes", 1);
		map(themes, documenterTheme, 'themes');					
			
		} finally {
			Session.Output("Sauvegarde du document");
			wh.enddocument();
		}
	} catch(e) {
		Session.Output("Erreur: " + e);
		wh.enddocument();
		wh.cleanup();
		throw e;
	} finally {
		wh.cleanup();
	}
	
}

function documenterConnecteur(conn, pName) {
	Session.Output(conn.ConnectorID);
	var aname = conn.Alias != null && conn.Alias !='' ? conn.Alias : conn.Name;
	var src = Repository.GetElementByID(conn.ClientID);
	var dst = Repository.GetElementByID(conn.SupplierID);
	var srcName = src.Alias != '' ? src.Alias: src.Name;
	var dstName = dst.Alias != '' ? dst.Alias: dst.Name;
	var titre = srcName + " => " + dstName + " [" + aname + "]";
	wh.title(titre, 2);
	wh.normal("Stéréotype: " + conn.StereotypeEx());
	wh.normal(conn.Notes);
}

function documenterDiagrammeEchanges(diag, pName) {
	var prjItf = Repository.GetProjectInterface();
	prjItf.PutDiagramImageOnClipboard(diag.DiagramGUID, 0); // copier l'image du diagramme dans le presse-papier
	wh.paste();
	wh.normal('');
	var dconn = diag.DiagramLinks;
	Session.Output("Nombre de liens de diagrammes: " + dconn.Count);
	function documenterEchange(ech, pName) {
		var conn = Repository.GetConnectorByID(ech.ConnectorID);
		var titre = conn.Alias != '' ? conn.Alias: conn.Name;
		var connType = conn.Type; // InformationFlow
		Session.Output("!object type:" + conn.ObjectType);
		wh.title(titre, 3);
		wh.normal(conn.Notes);
	}	
	map(dconn, documenterEchange, 'échange');
}
  
function makeReport(souspalier) {
	wh = new WordHelper();
	var sousPalierCode = souspalier.sousPalierCode;
	var sousPalierNom = souspalier.sousPalierNom;
	Session.Output("Sous palier: " + sousPalierNom);
	wh.begindocument(sousPalierCode + ".doc");	
	
	var connecteurs = souspalier.connecteurs;
	var diagrams    = souspalier.diagrams;
	try {
		try {
			wh.title("Palier: " + 	sousPalierCode + " - " + sousPalierNom, 1);
			wh.normal(connecteurs.Count + " connecteurs ");		
			wh.normal("");
			map(connecteurs, documenterConnecteur, 'connecteurs');
			
			wh.normal(diagrams.Count + " diagrammes");		
			var echangesDiagrams = filter(diagrams, isEchanges, 'échanges');
			wh.normal(echangesDiagrams.Count + " diagrammes d'échanges");		
			map(echangesDiagrams, documenterDiagrammeEchanges, 'échanges');
		} finally {
			Session.Output("Sauvegarde du document");
			wh.enddocument();
		}
	} catch(e) {
		Session.Output("Erreur: " + e);
		wh.enddocument();
		wh.cleanup();
		throw e;
	} finally {
		wh.cleanup();
	}
	
}
var wh = null;

Session.Output("========= Extraction des données communes =======");
var extractor = new Extractor();
extractor.init();
var donneesCom = extractor.extraireInfosPart();
creerAppendices(donneesCom);


Session.Output("========= Extraction des données par sous-paliers et génération des rapports =======");
var ListePaliers = new Array("{65476ED1-56A5-4d94-9C82-D88817612DF6}", "{28DA3794-F9BF-4a5c-B201-9B1C7D567ABC}", "{7BCEE7E7-A358-4156-9149-0BEF2A60335D}", "{9D77537A-361D-482c-926C-417547C31E6E}", "{2183BB4A-1913-47aa-BA99-63520895C009}");
for (var i = 0; i <5; i++) {
	var guid = ListePaliers[i];
	var donneesSousPalier = extractor.extraireSousPalier(guid);
	Session.Output("*1");
	makeReport(donneesSousPalier);
	Session.Output("*2");
}
