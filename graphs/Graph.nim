import intsets, ropes, sequtils, algorithm, tables
import graphimpl, serializer


#[type
    Node* = concept n
        `==`(n, n) is bool

    Graph* = concept g
        var x: Node
        distance(g, x, x) is float

type
  GraphNode[T] = object
    data: T
    outTransitions: seq[ref GraphNode]
    incTransitions: seq[ref GraphNode]

  Graph[T] = object
    nodes: seq[ref GraphNode[T]]

  [http://forum.nim-lang.org/t/2411](http://forum.nim-lang.org/t/2411)


]#

type
  GraphObj*    = object of RootObj
    id*: uint64 # 2^64=1.8*10^19 possible values


  PropertySet* = object of GraphObj
    properties*: Table[string, string]

  Graph*       = object of GraphObj

    directed*:bool
      ## Is the graph directed?

    hypergraph*:bool
      ## Is it an hypergraph? i.e. does it use multiple vertices for a single
      ## edge (at least one edge?) - To be calculated

    depth*: uint8
      ## For viewing in 3 dimensions as layers

  Vertex*      = ref object of GraphObj
    ## A node (also known as Vertex)

  Node* = Vertex
    ## Another name for the type Vertex

  EdgeDirection* = enum dirSource, dirTarget
    ## Direction for an edge

  AbstractEdge*        = ref object of GraphObj

  Edge* = ref object of AbstractEdge
    #direction: EdgeDirection
    source*: Vertex
    target*: Vertex

  HyperEdge* = ref object of AbstractEdge
    vertices*: seq[Vertex]




method `[]`*(g:Graph)=
  discard

method addEdge*(g: Graph, s, t: Vertex, directed: bool)=
  discard

method addEdge*(g: Graph, edges: openarray[Vertex])=
  discard

method direction*(e: Edge)=
  discard

iterator vertices*(g: Graph) : seq[Vertex]=
  discard

iterator edges*(g: Graph): seq[Edge] =
  discard





