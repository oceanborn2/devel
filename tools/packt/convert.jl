#=
convert.jl:
- Julia version:
- Author: pasca
- Date: 2018-11-24
=#

# import Gumbo
# import AbstractTrees
# import DataFrames
# import Dates

using AbstractTrees
using Gumbo
using DataFrames
using Dates
using Unicode

#typealias NullableDate Union{Missing, Dates.Date} end

struct BookInfo
    bookTitle::String
    bookUrl::String
    invoiceUrl::String
    orderPrice::Float32
    orderStatus::String
    orderDate::String #Union{Missing, Dates.Date}
    idx::UInt16
end

function isbad(c::Char) return c in ['£','€', '_'] end

function builddf(dt)
    fc = fieldcount(BookInfo)
    fields = map(idx -> (fieldname(BookInfo, idx), fieldtype(BookInfo, idx)), 1:fc)
    # fields = zip(fieldname(BookInfo, 1), fieldtype(BookInfo, 1))
    d = DataFrame(dt, fields)
end

function displayRec(orderDiv, counter, dt)
    if typeof(orderDiv) == HTMLElement{:div}
        classN = get(orderDiv.attributes, "class", "")
        if classN == "product-line unseen"
            productTopLine = orderDiv.children[1]
            orderInfo = productTopLine.children[1]
            #println("orderInfo: ", orderInfo)
            orderRefInfo   = orderInfo.children[1].children[1]
            #println("orderRefInfo:", string(orderRefInfo))
            invoiceURL = string(orderRefInfo.attributes["href"]) # text
            orderRef = string(orderRefInfo.children[1])
            #println("order ref:", orderRef)
            #println("invoice url:", invoiceURL)

            orderDate = string(orderInfo.children[2].children[1])
            #try orderDate = parse(Date,  catch e end
            #println("orderDate: ", orderDate)

            orderPriceTemp = string(orderInfo.children[3].children[1])
            if orderPriceTemp == ""
                orderPriceTemp = "_0.00"
            end
            orderCurrency = SubString(orderPriceTemp,1,1)
            orderPriceTemp = lstrip(isbad, orderPriceTemp)
            orderPrice = parse(Float32, strip(orderPriceTemp))
            #println("orderPrice: ", orderPrice)

            orderStatus = string(orderInfo.children[4].children[1])
            #println("orderStatus: ", orderStatus)

            productTopList = orderDiv.children[2]
            productInfo = productTopList.children[1] #2 causes uncontrolled array out of bound in C layer

            bookInfo = productInfo.children[1]

            if length(bookInfo.children)>1
                println("***", counter)
            end

            for item in bookInfo.children
                bookTitle   = join(split(string(item.children[1])),"-")
                bookURL = string(item.attributes["href"])
                #println("bookURL: ", bookURL)
                #println("bookTitle: ", bookTitle)

                s = BookInfo(
                    bookTitle,
                    bookURL,
                    invoiceURL,
                    orderPrice,
                    orderStatus,
                    orderDate,
                    counter)
#                    println(s)
                push!(dt, s)
            end
        end
    end
    dt
end

dt = BookInfo[]
f = open("orders.html")
lines = read(f, String) # lines = readlines(f) returns an array, not a string
try
    counter = 1
    doc = parsehtml(lines)
    body = doc.root.children[2]
    for elem in PostOrderDFS(body)
        if typeof(elem) == HTMLElement{:div}
           elemId = get(elem.attributes, "id", "")
           if elemId == "orders-list"
                for orderDiv in elem.children
                    displayRec(orderDiv, counter, dt)
                    counter += 1
                end
            end
        end
   end
finally
    if f != Nothing
        close(f)
    end
end

println(dt)
#items = builddf(dt)
