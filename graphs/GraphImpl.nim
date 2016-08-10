#import trees
#import Buckets

type

  GraphStore*[KT:SomeInteger] = object of RootObj

  SparseGraphStore*[KT:SomeInteger] = object of GraphStore[KT]


  StringRec* = object

  # 1 page = 4096 bytes
  Chunk* = array [1..64, byte]
  Page*  = array [1..64, Chunk]

  IncidenceMatrixStore* = object of GraphStore
    #directed*: bool
    bidirected*:bool
    nbVertices*:int
    nbEdges*:int
    case directed*:bool
    of true:
    undirMatrix: array[int,int]
    of false:
    dirMatrix: array[int, int]

    flag* {.bitsize:1.}: cuint
