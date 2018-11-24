#=
convert.jl:
- Julia version:
- Author: pasca
- Date: 2018-11-24
=#

#import Gumbo
#import AbstractTrees

#import Pkg
#Pkg.add("Gumbo")


using Gumbo
using AbstractTrees

#readlines()
f = open("")
doc = parsehtml()
body = doc.root.children[2]
for elem in PostOrderDFS(body)
    tagn = tag(elem)

    print elem
end

print(doc.root.children[2])

