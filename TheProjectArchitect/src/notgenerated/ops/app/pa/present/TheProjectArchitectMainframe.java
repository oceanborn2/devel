package ops.app.pa.present;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

/**
 * Titre :        The Project Architect
 * Description :  A project intended to provide an integrated set of tools for project management
 * Copyright :    Copyright (c) 2001
 * Société :
 * @author Pascal Munerot
 * @version 1.0
 */

public class TheProjectArchitectMainframe extends JFrame {
  JPanel contentPane;
  JMenuBar jMenuBar1 = new JMenuBar();
  JMenu jMenuFile = new JMenu();
  JMenuItem jMenuFileExit = new JMenuItem();
  JMenu jMenuHelp = new JMenu();
  JMenuItem jMenuHelpAbout = new JMenuItem();
  JToolBar jToolBar = new JToolBar();
  JButton jButton1 = new JButton();
  JButton jButton2 = new JButton();
  JButton jButton3 = new JButton();
  ImageIcon image1;
  ImageIcon image2;
  ImageIcon image3;
  JLabel statusBar = new JLabel();
  BorderLayout borderLayout1 = new BorderLayout();

  /**Construire le cadre*/
  public TheProjectArchitectMainframe() {
    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
    try {
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  /**Initialiser le composant*/
  private void jbInit() throws Exception  {
    image1 = new ImageIcon(ops.app.pa.present.TheProjectArchitectMainframe.class.getResource("/src/images/openFile.gif"));
    image2 = new ImageIcon(ops.app.pa.present.TheProjectArchitectMainframe.class.getResource("/src/images/closeFile.gif"));
    image3 = new ImageIcon(ops.app.pa.present.TheProjectArchitectMainframe.class.getResource("/src/images/help.gif"));
    //setIconImage(Toolkit.getDefaultToolkit().createImage(TheProjectArchitectMainframe.class.getResource("[Votre icône]")));
    contentPane = (JPanel) this.getContentPane();
    contentPane.setLayout(borderLayout1);
    this.setSize(new Dimension(400, 300));
    this.setTitle("The Project Architect");
    statusBar.setText(" ");
    jMenuFile.setText("Fichier");
    jMenuFileExit.setText("Quitter");
    jMenuFileExit.addActionListener(new ActionListener()  {
      public void actionPerformed(ActionEvent e) {
        jMenuFileExit_actionPerformed(e);
      }
    });
    jMenuHelp.setText("Aide");
    jMenuHelpAbout.setText("A propos");
    jMenuHelpAbout.addActionListener(new ActionListener()  {
      public void actionPerformed(ActionEvent e) {
        jMenuHelpAbout_actionPerformed(e);
      }
    });
    jButton1.setIcon(image1);
    jButton1.setToolTipText("Ouvrir un fichier");
    jButton2.setIcon(image2);
    jButton2.setToolTipText("Fermer le fichier");
    jButton3.setIcon(image3);
    jButton3.setToolTipText("Aide");
    jToolBar.add(jButton1);
    jToolBar.add(jButton2);
    jToolBar.add(jButton3);
    jMenuFile.add(jMenuFileExit);
    jMenuHelp.add(jMenuHelpAbout);
    jMenuBar1.add(jMenuFile);
    jMenuBar1.add(jMenuHelp);
    this.setJMenuBar(jMenuBar1);
    contentPane.add(jToolBar, BorderLayout.NORTH);
    contentPane.add(statusBar, BorderLayout.SOUTH);
  }
  /**Opération Fichier | Quitter effectuée*/
  public void jMenuFileExit_actionPerformed(ActionEvent e) {
    System.exit(0);
  }
  /**Opération Aide | A propos effectuée*/
  public void jMenuHelpAbout_actionPerformed(ActionEvent e) {
    TheProjectArchitectMainframe_AboutBox dlg = new TheProjectArchitectMainframe_AboutBox(this);
    Dimension dlgSize = dlg.getPreferredSize();
    Dimension frmSize = getSize();
    Point loc = getLocation();
    dlg.setLocation((frmSize.width - dlgSize.width) / 2 + loc.x, (frmSize.height - dlgSize.height) / 2 + loc.y);
    dlg.setModal(true);
    dlg.show();
  }
  /**Remplacé, ainsi nous pouvons sortir quand la fenêtre est fermée*/
  protected void processWindowEvent(WindowEvent e) {
    super.processWindowEvent(e);
    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
      jMenuFileExit_actionPerformed(null);
    }
  }
}