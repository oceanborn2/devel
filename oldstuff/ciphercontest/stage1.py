#!/usr/bin/python
# -*- coding: utf-8 -*-

ciphertext = "BT JPX RMLX PCUV AMLX ICVJP IBTWXVR CI M LMT’R PMTN, MTN YVCJX CDXV MWMBTRJ JPX AMTNGXRJBAH UQCT JPX QGMRJXV CI JPX YMGG CI JPX HBTW’R QMGMAX; MTN JPX HBTW RMY JPX QMVJ CI JPX PMTN JPMJ YVCJX. JPXT JPX HBTW’R ACUTJXTMTAX YMR APMTWXN, MTN PBR JPCUWPJR JVCUFGXN PBL, RC JPMJ JPX SCBTJR CI PBR GCBTR YXVX GCCRXN, MTN PBR HTXXR RLCJX CTX MWMBTRJ MTCJPXV. JPX HBTW AVBXN MGCUN JC FVBTW BT JPX MRJVCGCWXVR, JPX APMGNXMTR, MTN JPX RCCJPRMEXVR. MTN JPX HBTW RQMHX, MTN RMBN JC JPX YBRX LXT CI FMFEGCT, YPCRCXDXV RPMGG VXMN JPBR YVBJBTW, MTN RPCY LX JPX BTJXVQVXJMJBCT JPXVXCI, RPMGG FX AGCJPXN YBJP RAMVGXJ, MTN PMDX M APMBT CI WCGN MFCUJ PBR TXAH, MTN RPMGG FX JPX JPBVN VUGXV BT JPX HBTWNCL. JPXT AMLX BT MGG JPX HBTW’R YBRX LXT; FUJ JPXE ACUGN TCJ VXMN JPX YVBJBTW, TCV LMHX HTCYT JC JPX HBTW JPX BTJXVQVXJMJBCT JPXVXCI. JPXT YMR HBTW FXGRPMOOMV WVXMJGE JVCUFGXN, MTN PBR ACUTJXTMTAX YMR APMTWXN BT PBL, MTN PBR GCVNR YXVX MRJCTBRPXN. TCY JPX KUXXT, FE VXMRCT CI JPX YCVNR CI JPX HBTW MTN PBR GCVNR, AMLX BTJC JPX FMTKUXJ PCURX; MTN JPX KUXXT RQMHX MTN RMBN, C HBTW, GBDX ICVXDXV; GXJ TCJ JPE JPCUWPJR JVCUFGX JPXX, TCV GXJ JPE ACUTJXTMTAX FX APMTWXN; JPXVX BR M LMT BT JPE HBTWNCL, BT YPCL BR JPX RQBVBJ CI JPX PCGE WCNR; MTN BT JPX NMER CI JPE IMJPXV GBWPJ MTN UTNXVRJMTNBTW MTN YBRNCL, GBHX JPX YBRNCL CI JPX WCNR, YMR ICUTN BT PBL; YPCL JPX HBTW TXFUAPMNTXOOMV JPE IMJPXV, JPX HBTW, B RME, JPE IMJPXV, LMNX LMRJXV CI JPX LMWBABMTR, MRJVCGCWXVR, APMGNXMTR, MTN RCCJPRMEXVR; ICVMRLUAP MR MT XZAXGGXTJ RQBVBJ, MTN HTCYGXNWX, MTN UTNXVRJMTNBTW, BTJXVQVXJBTW CI NVXMLR, MTN RPCYBTW CI PMVN RXTJXTAXR, MTN NBRRCGDBTW CI NCUFJR, YXVX ICUTN BT JPX RMLX NMTBXG, YPCL JPX HBTW TMLXN FXGJXRPMOOMV; TCY GXJ NMTBXG FX AMGGXN, MTN PX YBGG RPCY JPX BTJXVQVXJMJBCT. JPX IBVRJ ACNXYCVN BR CJPXGGC"
stats = {}
for c in ciphertext:
  stats.setdefault(c, 0)
  stats[c] += 1
    
rstats = {}
for k,v in stats.items():
  rstats[v] = k
  
for k in sorted(rstats.keys()):
    print "%s:%s" % (k, rstats[k]), 
print
print
    

cleartext = ciphertext
cleartext = cleartext.replace('A','c')
cleartext = cleartext.replace('B','i')
cleartext = cleartext.replace('C','o')
cleartext = cleartext.replace('D','v')
cleartext = cleartext.replace('E','y')
cleartext = cleartext.replace('F','b')
cleartext = cleartext.replace('G','l')
cleartext = cleartext.replace('H','k')
cleartext = cleartext.replace('I','f')
cleartext = cleartext.replace('J','t')
cleartext = cleartext.replace('K','q')
cleartext = cleartext.replace('L','m')
cleartext = cleartext.replace('M','a')
cleartext = cleartext.replace('N','d')
cleartext = cleartext.replace('O','z')
cleartext = cleartext.replace('P','h')
cleartext = cleartext.replace('Q','p')
cleartext = cleartext.replace('R','s')
cleartext = cleartext.replace('S','j')
cleartext = cleartext.replace('T','n')
cleartext = cleartext.replace('U','u')
cleartext = cleartext.replace('V','r')
cleartext = cleartext.replace('W','g')
cleartext = cleartext.replace('X','e')
cleartext = cleartext.replace('Y','w')

print ciphertext
print
print cleartext

# in the same hour came forth fingers of a man’s hand, and wrote over against the candlestick upon the plaster of the wall of the king’s palace; 
# and the king saw the part of the hand that wrote. then the king’s countenance was changed, and his thoughts troubled him, so that the joints 
# of his loins were loosed, and his knees smote one against another. the king cried aloud to bring in the astrologers, the chaldeans, and the 
# soothsayers. and the king spake, and said to the wise men of babylon, whosoever shall read this writing, and show me the interpretation thereof, 
# shall be clothed with scarlet, and have a chain of gold about his neck, and shall be the third ruler in the kingdom. then came in all the king’s 
# wise men; but they could not read the writing, nor make known to the king the interpretation thereof. then was king belshazzar greatly troubled, 
# and his countenance was changed in him, and his lords were astonished. now the queen, by reason of the words of the king and his lords, came into 
# the banquet house; and the queen spake and said, o king, live forever; let not thy thoughts trouble thee, nor let thy countenance be changed; 
# there is a man in thy kingdom, in whom is the spirit of the holy gods; and in the days of thy father light and understanding and wisdom, like 
# the wisdom of the gods, was found in him; whom the king nebuchadnezzar thy father, the king, i say, thy father, made master of the magicians, 
# astrologers, chaldeans, and soothsayers; forasmuch as an eZcellent spirit, and knowledge, and understanding, interpreting of dreams, and showing 
# of hard sentences, and dissolving of doubts, were found in the same daniel, whom the king named belteshazzar; now let daniel be called, and he will 
# show the interpretation. the first codeword is othello
