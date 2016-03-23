package ops.app.pa.present.security;

import javax.swing.JDialog;

/**
 * <p>Title: The Project Architect</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author Pascal Munerot
 * @version 1.0
 */

public class LoginWindow extends JDialog {

  public LoginWindow() {
    try {
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  private void jbInit() throws Exception {
    this.setDefaultCloseOperation(3);
    this.setModal(true);
    this.setResizable(false);
  }
}