"""
# module available_functions

- Julia version: 
- Author: Анастасия
- Date: 2019-11-27

# Examples

```jldoctest
julia>
```
"""
module available_functions
    using DataFrames
using SQLite

export add_product, delete_product, sum_price,  view_goods, calc_sum, calc_price_products
    function add_product(db) #добавление товара на склад
        @info "add_product called"
        print("Индекс товара: ")
        id = parse(Int64, readline())
        @info "product id is" id
        print("Наименование: ")
        name=(readline())
        @info "product name is" name
        print("Количество единиц товара: ")
        amount = parse(Int64, readline())
        @info "product amount is" amount
        print("Цена за штуку: ")
        price = parse(Int64, readline())
        @info "price per product" price
        k = SQLite.Query(db, "SELECT * FROM Goods;") |> DataFrame
        search_in_table = findfirst(x -> x==name, k.Name)
        if search_in_table!= nothing #если товар на складе уже есть, обновляем данные таблицы
            query = "UPDATE Goods SET Amount = Amount + $amount, Price_for_all = Price_for_all + ($price*$amount) WHERE Name = '$name';"
            SQLite.Query(db, query)
            @info "table updated"
        else #если товара на складе еще нет, добавляем его в таблицу
            query = "INSERT INTO Goods(Name, Amount, Price_per_product, Price_for_All) VALUES ('$name', $amount, $price, $price*$amount);"
            SQLite.Query(db, query)
            @info name "inserted into table"
         end
        make_history("add:", [id, name, amount, price])#добавление действия в историю операций
        @info name "added"
    end

    function delete_product(db) #удаление товара со склада
        @info "delete_product called "
        print("Наименование: ")
        name = readline()
        print("Количество единиц товара: ")
        amount = parse(Int64, readline())
        print("Цена за штуку: ")
        price = parse(Int64, readline())
        query = "UPDATE Goods SET Amount = Amount - $amount, Price_for_All = Price_for_All - ($price*$amount) WHERE Name = '$name';"
        SQLite.Query(db,query)
        @info "table updated"
        make_history("delete:", [name, amount])#добавление операции в историю
        @info name amount price "was deleted"
    end

    function sum_price(db)
        @info "sum_price called"
        k = SQLite.Query(db, "SELECT Price_for_All FROM Goods;") |> DataFrame
        ans= 0
        for i in k.Price_for_All
            ans += i
        end
        println(ans)
        make_history("total_price", [])
        @info "total price was counted"
        return ans
    end


    function make_history(cmd, list)#отчет по операциям на складе
        @info "make_history called"
        file = open("history.txt", "a")
        @debug "history.txt opened"
        write(seekend(file), "$cmd ")
        for i in list
            write(seekend(file), "$i, ")
            @info i "was written to history"
        end
        write(seekend(file), "\n")
        close(file)
        @debug "history.txt closed"
    end

    function view_goods(db)#вывод общей таблицы товаров на складе
        @info "view_goods called"
        k = SQLite.Query(db, "SELECT * FROM Goods;") |> DataFrame
        println(k)
        make_history("view_goods", [])
        @info "goods table showed"
        return k
    end

    function calc_price_products(db, name, amount)#подсчет суммы одноименных единиц, требуемых к расходу
        @info "calc_price_products called"
        k = SQLite.Query(db, "SELECT Price_per_Product  FROM Goods WHERE Name = '$name';") |> DataFrame
        sum = 0;
        for i in k.Price_per_Product
            sum += i
        end
        sum = sum * amount
        return(sum)
    end

    function calc_sum(db) #подсчет общей суммы требуемых к расходу товаров
        @info "calc_sum called"
        ans = 0
        while true
            println("Наименование: ")
            name=(readline())
        if name == "end"
            break
        else
            println("Количество единиц товара: ")
            amount = parse(Int64, readline())
            @info name "," amount "required for consumption"
            ans = ans+calc_price_products(db, name, amount)

        end
        end
        println(ans)
        @info "Consumption sum is" ans
   end

end