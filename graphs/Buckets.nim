import intsets

const
  BLOCKSIZE : int = 32768
  PAGESIZE  : int = 4096

type
  Bucket*[DATATYPE]  = object
    typesize*: int
    blockcapacity* :int
    data*: seq[DATATYPE]

  #BitBucket* = Bucket[seq[IntSet]]

proc newBucket*[DATATYPE](pData:seq[DATATYPE]): Bucket[DATATYPE] {.constructor.} =
  result = Bucket[DATATYPE]()
  result.typesize = sizeof(DATATYPE)
  result.blockcapacity = `div` (BLOCKSIZE, result.typesize) # / result.typesize) #`div` int(result.typesize)
  result.data = pData


