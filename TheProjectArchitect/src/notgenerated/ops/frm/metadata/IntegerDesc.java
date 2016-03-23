//
// $Id: IntegerDesc.java,v 1.1 2002/04/14 21:48:20 pascal Exp $
//
// $Log: IntegerDesc.java,v $
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

import java.io.Serializable;

public class IntegerDesc extends FieldDesc implements FieldInterface, Serializable {

    private Integer value;

    public IntegerDesc(String name, Integer value) {
      super(name);
    }

}
