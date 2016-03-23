//
// $Id: Connection.java,v 1.1 2002/04/14 21:03:07 pascal Exp $
//
// $Log: Connection.java,v $
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
import java.sql.*;

public class Connection {

    private String driver;
    private String dburl;
    private String user;
    private String password;

    Connection(String driver, String dburl, String user, String password) {

      this.driver   = driver;
      this.dburl    = dburl;
      this.user     = user;
      this.password = password;

    }

}
