#!/usr/bin/python
# -*- coding: utf-8 -*-

ciphertext = "MHILY LZA ZBHL XBPZXBL MVYABUHL HWWPBZ JSHBKPBZ JHLJBZ KPJABT HYJHUBT LZA ULBAYVU"
for x in xrange(1,26):
  cleartext = ''
  for c in ciphertext:
    i = ord(c)
    if i>64:
      i -= 64
      i += x
      i = i % 26
      c = chr(64+i)
    cleartext = "%s%s" % (cleartext, c)
  print "%03d %s" % (x, cleartext)
    
# 019 FABER EST SUAE QUISQUE FORTUNAE APPIUS CLAUDIUS CAECUS DICTUM ARCANUM EST NEUTRON
# English translation: Each man is the smith of his own fortune.
# Français: Chaque homme est le forgeron de sa propre fortune