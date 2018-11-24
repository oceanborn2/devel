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


struct BookInfo
    bookTitle::String
    bookUrl::String
    invoiceUrl::String
    orderPrice::Float32
    orderStatus::String
    orderDate::String #Date
    idx::UInt16
end

"""
<div class="product-line unseen">
    <div class="product-top-line">
        <div class="float-left order-info">
            <div class="order-reference float-left"><a
                    href="https://www.packtpub.com/account/view_order/28759079">PAC-18-28759079-1090090</a>
            </div>
            <div class="order-date float-left">22 November 2018</div>
            <div class="order-price float-left">£0.00</div>
            <div class="order-status float-left">Shipped</div>
        </div>
        <div class="float-left toggle-product-line">+</div>
    </div>
    <div class="toggle order-product-list" style="display:none">
        <div class="order-product-item cf">
            <div class="order-product-item-inner">
                <a href="https://www.packtpub.com/networking-and-servers/windows-server-2016-cookbook">1
                    x Windows Server 2016 Cookbook [eBook]</a></div>
        </div>
    </div>
</div>
"""

function isbad(c::Char) return c in ['£','€', '_'] end

function displayRec(orderDiv, counter, items)
    if typeof(orderDiv) == HTMLElement{:div}
        classN = get(orderDiv.attributes, "class", "")
        if classN == "product-line unseen"
            productTopLine = orderDiv.children[1]
            orderInfo = productTopLine.children[1]
            orderRef = orderInfo.children[1]
            bookURL = string(orderRef.children[1].attributes["href"]) # href
            bookTitle = string(orderRef.children[1].children[1])
            invoiceURL = ""
            orderDate = ""
            try orderDate = parse(Date, orderInfo.children[2].text) catch e end

            orderPriceTemp = (string(orderInfo.children[3].children[1]))
            if orderPriceTemp == ""
                orderPriceTemp = "_0.00"
            end
            orderCurrency = SubString(orderPriceTemp,1,1) #Unicode.graphemes(orderPriceTemp).s.SubString(orderPriceTemp,1,1)
            orderPriceTemp = lstrip(isbad, orderPriceTemp)
            # a = Iterators.Stateful(orderPriceTemp)
            # popfirst!(a)
            #replace(orderPriceTemp, "$(orderCurrency)", count=1) #.eachMatch
            orderPrice = parse(Float32, strip(orderPriceTemp))

            orderStatus = string(orderInfo.children[4])

            productTopList = orderDiv.children[2]
            titleInfo = productTopList.children[1] #2 causes uncontrolled array out of bound in C layer
            bookTitle = strip(string(titleInfo.children[1].children))

            for item in titleInfo.children
                s = BookInfo(
                    bookTitle,
                    bookURL,
                    invoiceURL,
                    orderPrice,
                    orderStatus,
                    orderDate,
                    counter)
                println(typeof(items)) #(items, s) #val).insert!(s)
                #println(s)
            end
        end
    end
end


items = DataFrame()
items.columns = fieldnames(BookInfo)
f = open("orders.html")
lines = read(f, String) # lines = readlines(f) returns an array, not a string
try
    counter = 1
    doc = parsehtml(lines)
    body = doc.root.children[2]
    for elem in PostOrderDFS(body)
        if typeof(elem) == HTMLElement{:div}
           #println(dump(elem))
           elemId = get(elem.attributes, "id", "")
           limit = 0
           if elemId == "orders-list"
                for orderDiv in elem.children
                    if limit < 10
                        displayRec(orderDiv, counter, items)
                    end
                    limit += 1
                    counter += 1
                end
            end
        end
   end
finally
    if f != Nothing
        close(f)
    end
    #println(items)
end
