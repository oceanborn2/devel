package ops.frm.idgen;

/**
 * Title:        The Project Architect
 * Description:  This project intends to provide a generic framework and a set of tools for helping with project management. GUIs will also be provided.
 * Copyright:    Copyright (c) 2001
 * Company:      Open Source
 * @author Pascal Munerot
 * @version 1.0
 */

import java.util.Random;

public class RandomIdentGenerator extends AbstractIdentGenerator {

  private Random rand;
  private int length;

  public RandomIdentGenerator(String root, long seed, int length) {
    super(root);
    this.length = length;
    this.rand = new Random(seed);
  }

  public RandomIdentGenerator(String root, Random rand, int length) {
    super(root);
    this.length = length;
    this.rand = rand;
  }


  // returns an identifier given a randseed and a root string
  public String getIdent() {
    int len;
    StringBuffer tmp;
    if (root != null) {
       tmp = new StringBuffer(root);
       len = tmp.length();
       }
    else { tmp = new StringBuffer(length); len = 0; }
    int rank = rand.nextInt() % this.TOKENSET_LEN;
    while (len < length) {
      tmp.append(this.TOKENSET.charAt(rank));
      rank = rand.nextInt() % this.TOKENSET_LEN;
    }
    return tmp.toString();
  }

  public RandomIdentGenerator() {
    try {
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  private void jbInit() throws Exception {
  }

}
