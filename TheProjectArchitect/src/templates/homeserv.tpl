package $packagename;

[% classname = name %]
[% PROCESS copyright.java.include %]

[% globals.imports_as_code %]

/**
 * [% classname %] ejb home interface definition 
 *
 */

public interface [% classname %]Home extends javax.ejb.EJBHome {
  
   /**
    * create method
    */
    [% classname %]Home create()
    throws java.rmi.RemoteException, javax.ejb.CreateException;

}



