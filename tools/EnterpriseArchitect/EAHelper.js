!INC EAConstants
!INC Generics

// récupérer un objet "générique" en XML via le ProjectInterface et reconvertir en objet interne EA
// non utilisé
function findObject(guid) {
	var res = projectInterface.getElementByGUID(guid);
	return XMLToGUID(res);
}

// Objet élémentaire de description des éléments du modèle
// sous une forme manipulable de manière générique et 
// embarquant l'objet concerné en tant qu'attribut
function ModelItem(guid, type, name, obj, note, src, trg, rset) {
	this.guid = guid;
	this.type = type;
	this.name = name;
	this.obj = obj;
	this.note = note;
	this.src = src;
	this.trg = trg;
	this.rset = rset;
	return this;
}

function indexobj(obj, pName) {
	var otype = obj.ObjectType;
	var oname = obj.Name;
	var oguid = null;
	var oalias = obj.Alias;
	var onotes = obj.Notes;	
	var osrc = null;
	var otrg = null;
	var orset = null;
	
	//Session.Output("otype: " + otype + " / oname: " + oname);
	
	switch(otype) { 
		case otAttribute: oguid = obj.AttributeGUID; break;
		case otPackage: oguid = obj.PackageGUID; break;
		case otElement: oguid = obj.ElementGUID; break;
		case otConnector: /* Dependency, InformationFlow, Generalization, Association* ... */
			oguid = obj.ConnectorGUID; 
			osrc = obj.ClientEnd; 
			otrg = obj.SupplierEnd;
			orset = null; // related set
			break; 
		case otConnectorEnd: oguid = obj.ConnectorEndGUID; break;
		case otDiagram: oguid = obj.DiagramGUID; break;
		case otScenario: oguid = obj.ScenarioGUID; break; 
		case otCollection: oguid = null; break; 
		case otModel: oguid = obj.ModelGUID; break;
		case otRequirement: oguid = obj.RequirementGUID; break;
		case otStereotype: oguid = obj.StereotypeGUID; break;
		case otTaggedValue: oguid = obj.TaggedValueGUID; break;
		case otConstraint: oguid = obj.ConstraintGUID; break;
		case otRepository: oguid = obj.RepositoryGUID; break;
		case otFile: oguid = obj.FileGUID; break;
		case otEffort: oguid = obj.EffortGUID; break;
		case otMetric: oguid = obj.MetricGUID; break;
		case otIssue: oguid = obj.IssueGUID; break;
		case otRisk: oguid = obj.RiskGUID; break;
		case otTest: oguid = obj.TestGUID; break;
		case otDiagramObject: oguid = obj.DiagramObjectGUID; break;
		case otDiagramLink: oguid = obj.DiagramLinkGUID; break;
		case otResource: oguid = obj.ResourceGUID; break;
		case otMethod: oguid = obj.MethodGUID; break;
		case otParameter: oguid = obj.ParameterGUID; break;
		case otClient: oguid = obj.ClientGUID; break;
		case otAuthor: oguid = obj.AuthorGUID; break;
		case otDatatype: oguid = obj.DatatypeGUID; break;
		case otTask: oguid = obj.TaskGUID; break;
		case otTerm: oguid = obj.TermGUID; break;
		case otProjectIssues: oguid = obj.ProjectIssuesGUID; break;
		case otAttributeConstraint: oguid = obj.AttributeConstraintGUID; break;
		case otAttributeTag: oguid = obj.AttributeTagGUID; break;
		case otMethodConstraint: oguid = obj.MethodConstraintGUID; break;
		case otMethodTag: oguid = obj.MethodTagGUID; break;
		case otConnectorConstraint: oguid = obj.ConnectorConstraintGUID; break;
		case otConnectorTag: oguid = obj.ConnectorTagGUID; break;
		case otProjectResource: oguid = obj.ProjectResourceGUID; break;
		case otReference: oguid = obj.ReferenceGUID; break;
		case otRoleTag: oguid = obj.RoleTagGUID; break;
		case otCustomProperty: oguid = obj.CustomPropertyGUID; break;
		case otPartition: oguid = obj.PartitionGUID; break;
		case otTransition: oguid = obj.TransitionGUID; break;
		case otEventProperty: oguid = obj.EventPropertyGUID; break;
		case otEventProperties: oguid = obj.EventPropertiesGUID; break;
		case otPropertyType: oguid = obj.PropertyTypeGUID; break;
		case otProperties: oguid = obj.PropertiesGUID; break;
		case otProperty: oguid = obj.PropertyGUID; break;
		case otSwimlaneDef: oguid = obj.SwimlaneDefGUID; break;
		case otSwimlanes: oguid = obj.SwimlanesGUID; break;
		case otSwimlane: oguid = obj.SwimlaneGUID; break;
		case otNone: oguid = null; break;
		default: 
			Session.Output("Manqué:" + obj.Name + obj.ObjectType);
			break;
	}
	
	// Indexage par GUID
	var modelitem = null;
	if (oguid != null) {
		try {
			modelitem = index[oguid];
		} catch (e) {
			//Session.Output("Création :::: guid:" + oguid + "/" +modelitem.guid);
			modelitem = new ModelItem(oguid, otype, oname, obj, onotes, osrc, otrg, orset);
			index[oguid] = modelitem;
		}
		// Indexage par destination d'extraction
		if (pName == null) 
			pName = 'idx';
		if (!index[pName])
			index[pName]= [];
		index[pName][oguid] = modelitem;
	} else if (otype != otCollection && otype!= otCustomProperty) {
			//Session.Output("Err: oguid = null => " + otype + " /" + oname);
	}
	
	return obj;
}



// Afficher l'ensemble des éléments et leur type déclaré
function show(elements, pName) {
	if (elements == null) {
		Session.Output("Rien à montrer: " + pName);
		return;
	}
	var it = new Enumerator(elements);
	while (!it.atEnd()) {
		var e as EA.Element;
		var e = it.item();
		var params = indexobj(e, pName);
		Session.Output("params:" + params == null  + "/" + e==null ? 'e=null' : e.Name);
		if (params != null) {
			var oguid = params.guid;
			if (oguid != null) {
				var t = params.type;
				var name = params.name;
				var alias = params.alias;
				var notes = params.notes;
				Session.Output(params.name + "/" +  params.type + "/" + params.guid + "/" + params.alias + "/" + params.notes);
			}
		} else {
			Session.Output("¤¤¤¤¤");
		}
		it.moveNext();
	}
}

// Récupérer un élément par son GUID
function getelement(guid) {
	var res as EA.Element;
	res = Repository.GetElementByGuid(guid);
	return res;
}

// Récupérer un package par son GUID
function getpackage(guid) {
	var res as EA.Package;
	res = Repository.GetPackageByGuid(guid);
	return res;
}

// Récupérer un connecteur par son GUID
function getconnector(guid) {
	var res as EA.Connector;
	res = Repository.GetConnectorByGuid(guid);
	return res;
}

function recurse(obj, res) {
	if (obj == null) 
		return null;
	
	var objtype = obj.ObjectType;
	var objname = obj.Name;
	
	//Session.Output("> type: " + objtype + " name: " + objname);
	try {
		if (objtype == otCollection) {
			var acol as EA.Collection;
			acol = obj;
			var acolCnt = acol.Count;
			if (acolCnt == 0) 
				return;
			
			//Session.Output("recursing into collection: " + acol.Count);
			var itcol = new Enumerator(acol);
			while (!itcol.atEnd()) {
				var childobj = itcol.item();
				recurse(childobj, res);
				itcol.moveNext();
			}
		} else {	
			res.push(obj);
		}

		params = indexobj(obj, null);
		//Session.Output("!" + obj.ElementGuid); // + "/" + obj.type + "/" + obj.Name + "/" + obj.Alias);	

		if (objtype == otPackage) {
			recurse(obj.Packages        , res);
			recurse(obj.Elements        , res);
			recurse(obj.Diagrams        , res);
			recurse(obj.Connectors      , res);
			
		} else if (objtype == otElement) {
			recurse(obj.Elements        , res);
			recurse(obj.Attributes      , res); 
			recurse(obj.Connectors      , res); 
			recurse(obj.Constraints     , res);
			//recurse(obj.CustomProperties, res);
			//recurse(obj.Diagrams        , res);
			//recurse(obj.Efforts         , res);
			recurse(obj.EmbeddedElements, res);
			//recurse(obj.StateTransitions, res);
			
		} else if (objtype == otScenario, res) {
			recurse(obj.Scenarios       , res);
		} else {
			Session.Output("Type oublié: " + objtype);
		}
	} finally {
		//Session.Output("< type: " + objtype + " name: " + objname);
	}
	return res;
}

function checkStereotype(obj, st) {
	var res = false;
	var elt as EA.Element;
	elt = obj;
	var est = elt.StereotypeEx();
	res = (est==st);
	if (!res) {
		est = est.split(new RegExp("[,]"));
		for (var ast in est) {
			res = (ast==st);
			if (res) break;
		}
	}
	return res;
}



// Récupération de l'API EA
Repository.EnsureOutputVisible("Script");
Repository.ClearOutput("Script");
var projectInterface = Repository.GetProjectInterface();
var index = []; // Index de tous les objets référencés