import unittest

suite "arithmetic-tests":

  test "divmod1":
    let a: int = 7
    let b: int = 3
    let d: int = `div` (a,b)
    let r: int = `mod` (a,b)
    echo($a & " / " & $b & " => " & $d & "," & $r)

  test "divmod2":
    let a = 7
    let b = 3
    let d = `div` (a,b)
    let r = `mod` (a,b)
    echo($a & " / " & $b & " => " & $d & "," & $r)

  test "divmod3":
    let a = 7
    let b = 3
    let d = a div b
    let r = a mod b
    echo($a & " / " & $b & " => " & $d & "," & $r)

