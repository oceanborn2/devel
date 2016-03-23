package ops.app.pa.present;

/**
 * Titre :        The Project Architect
 * Description :  This project intends to provide a generic framework and a set of tools for helping with project management. GUIs will also be provided.
 * Copyright :    Copyright (c) 2001
 * Société :      Open Source
 * @author Pascal Munerot
 * @version 1.0
 */

import ops.app.pa.engine.Engine;

public class TheProjectArchitect {

  private static Engine theEngine; // As of now, the engine is only a local artefact. Shall become distributed soon

  public TheProjectArchitect() {
  }

  public static void connectToEngine()
  throws Exception
  {
    if (theEngine == null) theEngine = new Engine("localhost", 4001);
    try
    {
      theEngine.connect();
    }
    catch (Exception e) { }
    finally  {
      theEngine.disconnect();
    }
  }

  public void runProjectManagementEngine()
  {

  }

  public static void main(String[] args) throws Exception
  {

    TheProjectArchitect theProjectArchitect1 = new TheProjectArchitect();
    System.out.println("Welcome to the Project Architect");

    connectToEngine(); // try to reach the project management server

  }

}