import intsets, unittest, times
include "../buckets"

suite "buckets-types":

  test "newbucket-types":
    let numsb = @[20.byte, 32, 255, 252, 11, 43, 55]
    let bb = newBucket[byte](numsb)
    echo($bb)

    let numsi = @[1,2,3]
    let bi = newBucket[int](numsi)
    echo($bi)

    let numsf = @[1.0,2,3]
    let bf = newBucket[float](numsf)
    echo($bf)

    let numsf32 = @[1.0'f32,2,3]
    let bf32 = newBucket[float32](numsf32)
    echo($bf32)

    let numsf64 = @[1.0'f64,2,3]
    let bf64 = newBucket[float64](numsf64)
    echo($bf64)

    var numsis:intsets.IntSet = initIntSet()
    let bis = newBucket[intsets.IntSet](numsis)
    echo($bis)

    let numss = @["A","B","C"]
    let bs = newBucket[string](numss)
    echo($bs)

