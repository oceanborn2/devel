package ops.app.pa.present;

import javax.swing.UIManager;
import java.awt.*;

/**
 * Titre :        The Project Architect
 * Description :  A project intended to provide an integrated set of tools for project management
 * Copyright :    Copyright (c) 2001
 * Société :      
 * @author Pascal Munerot
 * @version 1.0
 */

public class TheProjectArchitectApp {
  boolean packFrame = false;

  /**Construire l'application*/
  public TheProjectArchitectApp() {
    TheProjectArchitectMainframe frame = new TheProjectArchitectMainframe();
    //Valider les cadres ayant des tailles prédéfinies
    //Compacter les cadres ayant des infos de taille préférées - ex. depuis leur disposition
    if (packFrame) {
      frame.pack();
    }
    else {
      frame.validate();
    }
    //Centrer la fenetre
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    Dimension frameSize = frame.getSize();
    if (frameSize.height > screenSize.height) {
      frameSize.height = screenSize.height;
    }
    if (frameSize.width > screenSize.width) {
      frameSize.width = screenSize.width;
    }
    frame.setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);
    frame.setVisible(true);
  }
  /**Méthode principale*/
  public static void main(String[] args) {
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    new TheProjectArchitectApp();
  }
}