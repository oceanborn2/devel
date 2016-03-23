package ops.frm.tc;

/**
 * Title:        The Project Architect
 * Description:  This project intends to provide a generic framework and a set of tools for helping with project management. GUIs will also be provided.
 * Copyright:    Copyright (c) 2001
 * Company:      Open Source
 * @author Pascal Munerot
 * @version 1.0
 */

import java.lang.StringBuffer;

public class SequentialIdentGenerator extends AbstractIdentGenerator {

  private long seed;
  private String root;

  public SequentialIdentGenerator(String root, long seed) {
    this.root = root;
    this.seed = seed;
  }

  // returns an identifier given a randseed and a root string
  public String getIdent() {
    StringBuffer tmp = null;
    if (this.root != null) {
       tmp = new StringBuffer(this.root);
    }
    tmp.append(this.seed++);
    return tmp.toString();
  }

}
