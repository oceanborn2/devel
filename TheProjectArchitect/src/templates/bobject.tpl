package $packagename;

[% classname = name %]
[% PROCESS copyright.java.include %]

[% globals.imports_as_code %]

/**
 * A class for handling [% classname %] objects
 *
*/

public class [% classname %]Desc implements Serializable {

	/**
         * Default constructor for class $classname
         *
         */

	[% classname %]Desc() {
	}
[% FOREACH attr = entries %]
[% shorttype = attr.javatype %]
[% attrname = attr.name %]
[% attrbeanname = attr.javabean_name %]
	/**
         * $attrname attribute, getter and setter
	 *
         */
	private $shorttype $attrname;
	public  $shorttype get$attrbeanname() { return this.$attrname; }
	public void set$attrbeanname($shorttype $attrname) {
		this.$attrname = $attrname;
        }
[% END %]
}




