package ops.frm.valuedomains;

// ops.frm.valuedomains.DataValueFactory.java  - Copyright (C) Pascal Munerot 2001.
// This file belongs to the 'Project Architect' project and is licensed under the GNU Public License.
//
// $Id : $
//
// $Log: DataValueFactory.java,v $
// Revision 1.1  2001/12/06 21:38:39  pascal
// *** empty log message ***
//
//
//
// This class is responsible for generating object versions of primitive types

public final class DataValueFactory {

    private DataValueFactory() { }

    public Double allocate(double value) { return new Double(value); }
    public Float allocate(float value) { return new Float(value); }
    public Integer allocate(int value) { return new Integer(value); }
    public String allocate(char[] value) { return new String(value); }

}
