#=
convert.jl:
- Julia version:
- Author: pasca
- Date: 2018-11-24
=#

using AbstractTrees
using Gumbo
using DataFrames
using Dates
using Unicode

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
    data=[]
    resize!(data, length(dt)+1)
    #push!(data, [ [d.bookTitle, d.bookUrl, d.invoiceUrl, d.orderPrice, d.orderStatus, d.orderDate, d.idx] for d in dt])
    data = map(d::BookInfo -> [d.bookTitle, d.bookUrl, d.invoiceUrl, d.orderPrice, d.orderStatus, d.orderDate, d.idx], dt)
    # for d in dt
    #     push!(data, [])
    #     println(d)
    # end

    #data = cast(String[][] #convert(Array{Any}, dt)
    #fd = length(dt)
    #data = map(bi -> [r for r in dt[idx]], 1:fd)
    #println(data[1])

    #println(typeof(data[1]))
    d = DataFrame(data)
    writetable("book.txt", d)
#        [:bookTitle, :bookUrl, :InvoiceURL, :orderPrice, :orderStatus, :orderDate, :idx],
#        ["bookTitle", "bookUrl", "InvoiceURL", "orderPrice", "orderStatus", "orderDate", "idx"],
        # header=true,
        # separator=';', quotemark='"',nastring="",
        # false)
    d
end

function displayRec(orderDiv, counter, dt)
    if typeof(orderDiv) == HTMLElement{:div}
        classN = get(orderDiv.attributes, "class", "")
        if classN == "product-line unseen"
            productTopLine = orderDiv.children[1]
            orderInfo = productTopLine.children[1]
            orderRefInfo   = orderInfo.children[1].children[1]
            invoiceURL = string(orderRefInfo.attributes["href"])
            orderRef = string(orderRefInfo.children[1])
            orderDate = string(orderInfo.children[2].children[1])
            orderPriceTemp = string(orderInfo.children[3].children[1])
            if orderPriceTemp == ""
                orderPriceTemp = "_0.00"
            end
            orderCurrency = SubString(orderPriceTemp,1,1)
            orderPriceTemp = lstrip(isbad, orderPriceTemp)
            orderPrice = parse(Float32, strip(orderPriceTemp))
            orderStatus = string(orderInfo.children[4].children[1])
            productTopList = orderDiv.children[2]
            productInfo = productTopList.children[1] #2 causes uncontrolled array out of bound in C layer

            bookInfo = productInfo.children[1]
            if length(bookInfo.children)>1
                println("***", counter)
            end

            for item in bookInfo.children
                bookTitle   = join(split(string(item.children[1])),"-")
                bookURL = string(item.attributes["href"])
                s = BookInfo(
                    bookTitle,
                    bookURL,
                    invoiceURL,
                    orderPrice,
                    orderStatus,
                    orderDate,
                    counter)
                push!(dt, s)
            end
        end
    end
    dt
end

dt = BookInfo[]
f = open("orders.html")
lines = read(f, String)
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

#println(dt)
items = builddf(dt)
