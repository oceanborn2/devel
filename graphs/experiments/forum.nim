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
