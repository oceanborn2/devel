//
// $Id: FieldDesc.java,v 1.1 2002/04/14 21:48:19 pascal Exp $
//
// $Log: FieldDesc.java,v $
// Revision 1.1  2002/04/14 21:48:19  pascal
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

import java.io.Serializable;

public class FieldDesc implements Serializable {

    private static String name;

    public FieldDesc(String name) {
      this.name = name;
    }

}
