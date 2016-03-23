package ops.frm.valuedomains;

//
// $Id: ValueDomain.java,v 1.3 2002/05/18 19:18:51 pascal Exp $
//
// $Log: ValueDomain.java,v $
// Revision 1.3  2002/05/18 19:18:51  pascal
// Some improvements
//
// Revision 1.2  2002/04/14 21:05:05  pascal
// minor modifications
//
//
// $Author: pascal $
//
// This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
//
// Copyright (C) Pascal Munerot
//


import java.util.Hashtable;
import java.util.Enumeration;

public class ValueDomain {

    protected ValueDomain() { }

    /**
     * returns the list of values as an enumeration
     */
    public Enumeration getValues() { return index.keys(); }

    /**
     * returns the list of labels as an enumeration
     */
    public Enumeration getLabels() { return index.elements(); }

    protected static Hashtable index = new Hashtable();
    public    Hashtable getIndex() { return index; }



}
