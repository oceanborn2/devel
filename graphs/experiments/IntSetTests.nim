import os, intsets, sequtils, algorithm, unittest, stopwatch, math

suite "basic":

  test "nimlib":
    var x = initIntSet()
    x.incl(1)
    x.incl(2)
    x.incl(3)
    x.incl(5)
    x.incl(7)
    x.incl(11)
    x.incl(13)

    var xs = toSeq(items(x))
    xs.sort(cmp[int])
    assert xs == @[1, 2, 3, 5, 7, 11, 13]
    echo (xs)

    var y: IntSet
    assign(y, x)
    var ys = toSeq(items(y))
    ys.sort(cmp[int])
    assert ys == @[1, 2, 3, 5, 7, 11, 13]

  test "negative-indices":
    var x = initIntSet()
    x.clear()
    for i in countup(-32*8,32*8):
      x.incl(i)

    echo(x)
    echo(x.contains(-255))
    echo(x.contains(255))
    echo(x.contains(-512))
    echo(x.contains(512))
    echo ("negative-indices - sizeof(x): ", sizeof(x))

    for i in countup(-32*32,32*32):
      x.incl(i)

  test "negative-consistency":
    var x = initIntSet()
    let testNums = @[8693, 15485059, 15485077]
    x.clear()
    for i in items(testNums):
      x.incl(i)
      x.incl(-i)

    for i in items(testNums):
      assert(x.contains(i))
      assert(x.contains(-i))

    echo(x)
    echo ("negative-consistency - sizeof(x): ", sizeof(x))

  test "performance":
    for j in 1..10:
      var c = clock()
      bench(c):
        var x = initIntSet()
        var count=0
        for k in countup(1,10):
          for i in countup(0, 1000_000):
            x.incl(i)
            inc(count)
            if count == 7:
              count=0
              x.excl(i)

      echo("elapsed time: " & $c.seconds)
      echo ("performance - sizeof(x): ", sizeof(x))

####################################################

proc calcSieve(n,expected:int)=
  let maxRange = n
  var c = clock()
  bench(c):
    var crible = initIntSet()
    crible.clear()
    #crible.incl(1)
    for n in countup(2,maxRange):
      crible.incl(n)

    var n = 2
    while (n < maxRange):
      var i = n
      while (i < maxRange):
        i = i + n
        crible.excl(i)
      inc n

    var xs = toSeq(items(crible))
    xs.sort(cmp[int])

    echo($xs)
    let nbp = xs.len()
    echo("nb primes: ", nbp)
    assert nbp==expected # not counting one
    echo("sizeof-sieve:", sizeof(crible))

  echo("elapsed time: " & $c.seconds)


suite "sieve":

  # url for checking the expected number of primes: https://primes.utm.edu/howmany.html
  # another interesting site: http://numbermatics.com/n/9999883/
  # http://www.naturalnumbers.org/ppanalysis.html
  # http://codegolf.stackexchange.com/questions/34664/shortest-test-for-primality-for-byte?noredirect=1&lq=1


  test "crible-erathostene-100_000":
    calcSieve(100_000, 9_592)

  test "crible-erathostene-1000_000":
    calcSieve(1000_000, 78_948)

  test "crible-erathostene-10_000_000":
    calcSieve(10_000_000, 664_579)

  test "crible-erathostene-10_000_000":
    calcSieve(100_000_000, 5_761_455)
