package $packagename;

[% classname = name %]
[% PROCESS copyright.java.include %]

[% globals.imports_as_code %]

public interface [% classname %] extends javax.ejb.EJBObject {

    [% classname %] create()
    throws java.rmi.RemoteException, javax.ejb.CreateException;

}



