# This module is for serializing / deserializing graph objects
import Graph, Buckets
import marshal

type GraphSerializable* = generic g,str
  serialize*(g: Graph,   str: Stream)
  deserialize*(g: Graph, str: Stream)


  
