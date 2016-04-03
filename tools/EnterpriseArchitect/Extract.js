function Extractor() {
	
	this.init = function() {
		this.services = null;
		this.utilisateurs = null;
		this.themes = null;
		this.souspalier = null;
		this.casEtScenarios = null;
		this.connecteurs = null;
		this.diagrams = null;
		this.ecosyst = null;
		return this;
	}
	 
	this.extraireInfosPart = function () {
		Session.Output("InfoPart::Extraction des services");
		this.services     = filter(getpackage("{CF410435-0DFE-4316-B20E-3F17FF4B833B}").Elements, isService, 'service');
		show(this.services, 'service');

		Session.Output("InfoPart::Extraction des utilisateurs");
		this.utilisateurs = filter(getpackage("{9FE81E12-5E0A-45ce-8F7C-326BA29FEF08}").Elements, isUser,    'user');
		show(this.utilisateurs, 'user');
	
		Session.Output("InfoPart::Extraction des thèmes");
		this.themes       = filter(getpackage("{49CCEF00-F8DD-4c04-93A3-E19D3FC14CF8}").Packages, isTheme,   'theme');
		show(this.themes, 'theme');
			
		Session.Output("InfoPart::Extraction des scénarios");
		this.casEtScenarios = new Array();
		recurse(getpackage("{83387E2D-897D-4c15-83E2-1CE428C54663}"), this.casEtScenarios); // SIEL/Cas d'utilisation
		var res = filter(this.casEtScenarios, isCasOuScenario, 'scenarios'); 
		this.casEtScenarios = res;
		show(this.casEtScenarios);		
		
		Session.Output("InfoPart::Extraction de l'écosystème");
		this.ecosyst = getpackage("{7F1AC771-BECF-471a-8E23-8D38675066C4}").Elements;
		
		return this;
	}
	
	this.extraireSousPalier = function(guid) {
		this.souspalier = Repository.GetPackageByGuid(guid);
		var nom = this.souspalier.Name;
		this.sousPalierCode = nom.substring(0,4);
		nom = nom.substring(5, nom.length);
		this.sousPalierNom = nom;
		Session.Output("code: " + this.sousPalierCode + " / " + this.sousPalierNom);
		
		var connectors = this.souspalier.Connectors;
		//show(connectors, 'connectors');
		this.connecteurs = connectors;	
		Session.Output("Connecteurs: " + connectors.Count);
		var connectorsEn = new Enumerator(connectors);
		while (!connectorsEn.atEnd()) {
			var connector as EA.Connector;
			connector = connectorsEn.item();
			var srcId= connector.ClientID;
			var src = Repository.GetElementByID(srcId);
			var dstId= connector.SupplierID;
			var dst = Repository.GetElementByID(dstId);			
			//Session.Output(connector.ConnectorID + " " + connector.ConnectorGuid + " " + connector.Name + " " + connector.Alias + " " +connector.Type+ " " + src.Name + " => " + dst.Name);
			connectorsEn.moveNext();
		}
		
		this.diagrams    = this.souspalier.Diagrams;
		return this;
	}
	
}
