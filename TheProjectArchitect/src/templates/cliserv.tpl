package $packagename;

[% classname = name %]
[% PROCESS copyright.java.include %]

[% globals.imports_as_code %]
import [% packagename %].[% classname %]Home;

public class [% classname %]Client {

	private Context ctx;

	public [% classname %]Client() {
         try {
	   Properties props = new Properties();
	   this.ctx = new InitialContext(props);
	   Object objref = ctx.lookup("[% classname %]");
	   [% classname %]Home home = ([% classname %]Home) javax.rmi.PortableRemoteObject.narrow(objref, [% classname %]Home.class);
	 } catch (Exception e) { e.printStackTrace(); }
	}

	public Context getContext() { return this.ctx; }
}



