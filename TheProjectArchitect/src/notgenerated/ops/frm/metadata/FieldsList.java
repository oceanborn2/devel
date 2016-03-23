//
// $Id: FieldsList.java,v 1.1 2002/04/14 21:48:20 pascal Exp $
//
// $Log: FieldsList.java,v $
// Revision 1.1  2002/04/14 21:48:20  pascal
// Initial add
//
//
// $Author: pascal $
//
// This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
//
// Copyright (C) Pascal Munerot
//

package ops.frm.metadata;

import java.util.Vector;
import java.io.Serializable;

public class FieldsList implements Serializable {

    private Vector fields = new Vector();

    public FieldsList() { }
    public FieldsList(Vector fields) {
    }

    public void newField(FieldDesc desc) {
      fields.add(desc);
    }


}
