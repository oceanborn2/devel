!INC EAConstants

function isService(o) { return checkStereotype(o, 'service');}
function isUser(o)    { return checkStereotype(o, 'user');}
function isTheme(o)   { return checkStereotype(o, 'thème');}
function isCasOuScenario(o) { return (o.ot == otScenario);}

function isEchanges (diag) {
	var st = diag.Stereotype();
	var prjItf = Repository.GetProjectInterface();
	return (st=='échanges');
} 