package $packagename;

[% tablename = spec.uniq.tablename %]
[% classname = name %]
[% PROCESS copyright.java.include %]

[% globals.imports_as_code %]
import [% packagename %].[% classname %]Desc;

/**
 * a class for persisting [% classname %]Desc
 *
 */

public class [% classname %]Dbms {

	/**
	 * Keeps track of already prepared queries
	 *
	 */
	private static Hashtable prepStmtCache = new Hashtable();

	/**
	 * Default constructor for [% classname %]Dbms
	 *
	 */
	[% classname %]Dbms() {
	}

	/**
	 * Prepares a string containing a comma separated list of the table fields
	 *
	 * @param buf An instantiated StringBuffer object
	 */
	protected StringBuffer getCommaListOfFields(StringBuffer buf) {
	    buf.append("[% FOREACH attr = entries %][% attr.uniq.sqlfield %][% UNLESS loop.last %],[% END %][% END %]");
	    return buf;
	}

	/**
	 * Prepares a string containing a comma separated list of placeholders for the table fields
	 *
	 * @param buf An instantiated StringBuffer object
	 */
	protected StringBuffer getCommaListOfPlaceHolders(StringBuffer buf) {
	    buf.append("[% FOREACH attr = entries %]?[% UNLESS loop.last %],[% END %][% END %]");
	    return buf;
	}

	/**
	 * Inserts a record into [% tablename %].
	 *
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 */
	public void insert([% classname %]Desc record)
        throws java.sql.SQLException, Exception {
	    StringBuffer buf = new StringBuffer("insert into [% tablename %] (");
	    getCommaListOfFields(buf);
	    buf.append(") values (");
	    getCommaListOfPlaceHolders(buf);
	    buf.append(")");
	}

	/**
	 * Delete a record in [% tablename %] given its primary key
	 *
	 * @param record The record to delete
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 */
	public void delete([% classname %]Desc record)
        throws java.sql.SQLException, Exception {
	    StringBuffer buf = new StringBuffer("delete [% tablename %] where ");
	    String query = buf.toString();
	}

	/**
	 * Deletes all the records in [% tablename %].
         *
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 */
	public void deleteAll()
        throws java.sql.SQLException, Exception {
	    String query = "delete [% tablename %]";
	}

	/**
	 * Updates a record given a corresponding instance
	 *
	 * @param record a [% classname %]Desc business object
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 */
	public void update([% classname %]Desc record)
	throws java.sql.SQLException, Exception {
	    StringBuffer buf = new StringBuffer("update [% tablename %] set ... where ...");
	}

	/**
	 * Computes the select part string
	 *
	 * @param buf An instantiated StringBuffer object
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 */
	protected void computeSelectPart(StringBuffer buf) {
	    buf.append("select ");
	    getCommaListOfFields(buf);
	    buf.append(" from [% tablename %]");
	}

	/**
	 * Selects all the records in [% tablename %].
	 *
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 * @return Vector A vector of [% classname %]Desc
	 */
	public Vector selectAll()
        throws java.sql.SQLException, Exception {
	    StringBuffer buf = new StringBuffer(255);
	    computeSelectPart(buf);
	    Vector v = new Vector();
	    return v;
	}

	/**
	 * Selects a collection of record based a key record (not primary)
	 *
	 * @param record The record to use as a key (all fields that are not null, and combination between them)
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 * @return Vector A vector of [% classname %]Desc
	 */
	public Vector selectSome([% classname %]Desc record)
	throws java.sql.SQLException, Exception {
	    StringBuffer buf = new StringBuffer(255);
	    computeSelectPart(buf);
	    Vector v = new Vector();
	    return v;
	}

	/**
	 * Finds a record given its primary key fields
	 *
	 * @param record The record to use as a primary key
	 * @exception java.sql.SQLException
	 * @exception java.lang.Exception
	 * @return [% classname %]_desc : The found record, null if the record was not found
	 */
	public [% classname %]Desc findByPrimaryKey([% classname %]Desc record)
        throws java.sql.SQLException, Exception {
	    return null;
	}





}




