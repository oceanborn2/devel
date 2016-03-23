package $packagename;

[% classname = name %]
[% PROCESS copyright.java.include %]

[% globals.imports_as_code %]

/**
 * Exception class for [% classname %]Desc business objects 
 *
 */

public class [% classname %]Exception extends Exception {

	/**
         * Default constructor for class [% classname %]Exception
	 */

	[% classname %]Exception() {
	}

}





