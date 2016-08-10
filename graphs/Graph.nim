import intsets, ropes, sequtils, algorithm, tables, macros
include GraphImpl, Serializer



type

  TGraphKey* = distinct SomeInteger

  TGraphObj*    = object of RootObj
    id*: uint64 # 2^6=1.8*10^19 possible values

  TPropertySet* = object of TGraphObj
    properties*: Table[string, string]

  TBitmap* = distinct IntSet

  TGraphFeatures*[KT: TBitmap | uint8 | uint16 | uint32 | uint64] = object
    directed* : bool
    hypegraph*: bool
    keySize*  : int
    depth*    : uint8

  TGraph*[GS:GraphStore]       = object of TGraphObj

    store: GS

    directed*:bool
      ## Is the graph directed?

    hypergraph*:bool
      ## Is it an hypergraph? i.e. does it use multiple vertices for a single
      ## edge (at least one edge?) - To be calculated

    depth*: uint8
      ## For viewing in 3 dimensions as layers

  TVertex*      = ref object of TGraphObj
    ## A node (also known as Vertex)

  TNode* = TVertex
    ## Another name for the type Vertex

  TEdgeDirection* = enum dirSource, dirTarget
    ## Direction for an edge

  TAbstractEdge*        = ref object of TGraphObj

  TEdge* = ref object of TAbstractEdge
    #direction: EdgeDirection
    source*: TVertex
    target*: TVertex

  THyperEdge* = ref object of TAbstractEdge
    vertices*: seq[TVertex]



proc newGraph(keyBitSize:uint8, directed: bool=false, hypergraph: bool=false, depth: uint8=1)=
  discard


method `[]`*(g:TGraph)=
  discard

method addEdge*(g: TGraph, s, t: TVertex, directed: bool)=
  discard

method addEdge*(g: TGraph, edges: openarray[TVertex])=
  discard

method direction*(e: TEdge)=
  discard

iterator vertices*(g: TGraph) : seq[TVertex]=
  discard

iterator edges*(g: TGraph): seq[TEdge] =
  discard

