function filter(fromCollection, predicate, pName) {
	var res = new Array();
	if (fromCollection == null) {
		return res;
	}
	it = new Enumerator(fromCollection);
	var i=0;
	while (!it.atEnd()) {
		var obj as EA.Element;
		obj = it.item();
		if (predicate == null|predicate(obj)) {
			res[i] = obj;
			if (!index[pName])
				index[pName]=[];
			index[pName][obj.ElementGUID] = obj;
			i++;
		}
		it.moveNext();
	}	
	Session.Output('\n')
	return res;
}


function map(fromCollection, processentry, pName) {
	if (fromCollection == null) {
		Session.Output("return from map: empty collection");
		return;
	}
	it = new Enumerator(fromCollection);
	while (!it.atEnd()) {
		var obj as EA.Element;
		obj = it.item();
		if (processentry!=null)
			processentry(obj, pName);
		it.moveNext();
	}	
}

function hashmap() {
	this.init = function(s,fks) {
		this._dict = new ActiveXObject("Scripting.Dictionary");
		this._s = s; // entrée simple (1) ou multiple (0)
		this._fks = fks; // fonctions de calcul de clés en fonction du type de l'objet
	}
	
	this.set(k,v) = function(k,v,s) {
		if (s!=1) { // entrées multiples
			var cdict = null;
			if (!this._dict.Exists(k)) {
				cdict = new ActiveXObject("Scripting.Dictionary");
				this._dict.Add(k, cdict);
			} else cdict = this._dict.item(k);
			try {
				cdict.Add(this._fks.item(v.type()), v);
			} catch (e) {
				cdict.Add(k, v);
				Session.Output("Attention: fonction de calcul de clé manquante");
			}
		}
		else this._dict.Add(k,v); // entrée simple
	}
	
	this.get(k) = function(k) {
		return this._dict.item(k);
	}
	
	this.keys() = function() {
		return this._dict.Keys();
	}

	this.items() = function() {
		return this._dict.Items();
	}
	
	this.fromCollection(c, fk) = function(c, fk) {
		var en = new Enumerator(c); 
		while (!en.atEnd()) {
			var o = c.item();
			this._dict.Add(fk(o),o);
			c.moveNext();
		}
	}
}

function Graph() {
	
	function Edge() {
		this.init = function() {
			this._values = null;
		}
		this.setValue(k,v) = function(k,v) {
			if (this._values == null) {
				this._values = new ActiveXObject("Scripting.Dictionary"); //valeurs indexées
			} else if (this._values.Exists(k)) 
				this._values.remove(k);
			this._values.Add(k,v);
		}
		this.getValue(k) = function(k) {
			return this.item(k);
		}
	}
	
	function Node() {
		this.init = function() {
			this._values = new ActiveXObject("Scripting.Dictionary"); //valeurs indexées
			this._edges  = new ActiveXObject("Scripting.Dictionary"); //arêtes indexées
			this._edit   = 0; // Mode édition (1) ou parcours (0)
		}
		this.setValue(k,v) = function(k,v) {
			if (this._values.Exists(k)) 
				this._values.Remove(k);
			this._values.Add(k,v);
		}
		this.getValue(k) = function(k) {
			return this.item(k);
		}
		this.neighbours(filt) = function(filt) {
			return filter(this._edges, filt,'');
		}
		this.precs = function(filt) {
		}
		this.succs = function(filt) {
		}
		
	}
	
	this.init() = function(fk) {
		this._fk = fk; // fonction de calcul de clé
		this._nodes = new ActiveXObject("Scripting.Dictionary");
	}
	
	this.addNode(n) = function(n) {
		if (!n.__k) n.___k = this._fk(n);
		this._nodes.Add(n.___k, n);
	}
	
	this.nodes() = function() { return this._nodes; }
	this.edges() = function() {	return this._edges; }
	
	}
