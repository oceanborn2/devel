//
// $Id: ForeignKey.java,v 1.1 2002/04/14 21:03:07 pascal Exp $
//
// $Log: ForeignKey.java,v $
// Revision 1.1  2002/04/14 21:03:07  pascal
// Added new files into the framework
//
//
// $Author: pascal $
//
// This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
//
// Copyright (C) Pascal Munerot
//

package ops.frm.dbms;

import java.lang.String;
import ops.frm.metadata.FieldDesc;
import ops.frm.metadata.FieldsList;

public class ForeignKey extends BaseKey {

    public ForeignKey() { super(); }

    public ForeignKey(FieldsList fields) {
    }

}
