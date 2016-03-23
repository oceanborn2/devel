package ops.frm.idgen;
 
/**
 * Title:        The Project Architect
 * Description:  This is the base class for generating unique ids
 * Copyright:    Copyright (c) 2001
 * Company:      Open Source
 * @author Pascal Munerot
 * @version 1.0
 */

public abstract class AbstractIdentGenerator {

  // Characters used as tokens in the ident string
  protected final static String TOKENSET = new String("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_abcdefghijklmnopqrstuvwxyz");
  protected final static int    TOKENSET_LEN = TOKENSET.length();
  protected String root;

  // Theses constructors are deliberately left with very few parameters in order to allow
  // for higher flexibility in the inherited classes
  public AbstractIdentGenerator() { this.root = null; }

  public AbstractIdentGenerator(String root) {
   this.root = root;
  }

  // helper for charAt access
  protected char CharAt(int index) {
    return TOKENSET.charAt(index % TOKENSET_LEN);
  }

  // returns an identifier given a randseed and a root string
  public abstract String getIdent();

}
