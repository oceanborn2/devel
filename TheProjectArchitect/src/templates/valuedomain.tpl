package [% packagename %];
[% classname = name %]
[% PROCESS copyright.java.include %]

[% globals.imports_as_code %]
import ops.frm.valuedomains.ValueDomain;

/**
 * A value domain for [% classname %]
 */

public class [% classname %]ValueDomain extends ValueDomain {

	/**
         * default constructor for class [% classname %]ValueDomain
         */
	private [% classname %]ValueDomain() {
	}

[% FOREACH attr = entries %]
	public final static [% spec.javatype %] [% attr.uniq.valdomid %] = new [% spec.javatype %]([% attr.value %]); // [% attr.comment %]

[% END %]


	public    [% spec.javatype %] getValueFor([% spec.javatype %] key) {
	    if (key == null) return null;
	    return ([% spec.javatype %]) index.get(key);
	}

	public    [% spec.javatype %] getValueFor([% spec.javatype %] key, [% spec.javatype %] defaultvalue) {
	    if (key == null) return defaultvalue;
	    [% spec.javatype %] res = ([% spec.javatype %]) index.get(key);
	    if (res == null) return defaultvalue;
	    return ([% spec.javatype %]) res;
	}

	private   static Hashtable valueIndex = new Hashtable();
	static {
[% FOREACH attr = entries %]
	    index.put("[% attr.value %]", new [% spec.javatype %]([% attr.value %]));
[% END %]
	}

}





