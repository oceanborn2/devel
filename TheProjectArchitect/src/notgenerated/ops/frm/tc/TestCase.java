package ops.frm.tc;

/**
 * Title:        The Project Architect
 * Description:  This project intends to provide a generic framework and a set of tools for helping with project management. GUIs will also be provided.
 * Copyright:    Copyright (c) 2001
 * Company:      Open Source
 * @author Pascal Munerot
 * @version 1.0
 */

import java.lang.String;

public abstract class TestCase {

  public TestCase() {
  }

  public abstract String getTestCaseName();
  public void log(Object o) { System.out.println(o); }

}