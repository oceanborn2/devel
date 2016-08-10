type

  GraphDataStructure* = object of RootObj
    directed*:bool    ## Is the graph directed

  DenseMatrixGraph*   = object of GraphDataStructure
  SparseMatrixGraph*  = object of GraphDataStructure

#  Graph[gds: GraphDataStructure]* = object
  Graph* = object
    dirnimected*:bool    ## Is the graph directed
    engine: GraphDataStructure

  Vertex* = object

  Edge* = object

proc newGraph(directed: bool, gds:GraphDataStructure): Graph {.constructor.} =
  var g = new Graph(directed, engine = gds)
  g.engine = gds
  return g

iterator edges*(g: Graph) =
  discard

