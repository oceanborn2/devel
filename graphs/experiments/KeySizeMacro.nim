import macros

macro KeySize(body: expr, keybits): stmt=
    result = newStmtList()
    result.add parseExpr("key: uint" & $keybits)

#when isMainModule:
#  KeySize(8)
