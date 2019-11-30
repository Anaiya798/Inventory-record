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

export add_product, delete_product, sum_price,  view_goods, calc_consumption

    function correct_name(db, name)
        @info "correct_name called"
        k = SQLite.Query(db, "SELECT * FROM Goods;") |> DataFrame
        search_in_table = findfirst(x -> x==name, k.Name)
        if (search_in_table == nothing)
            println("Такого товара на склад еще не поступало")
            return -1
        else return 0
            end
    end

    function correct_amount(db, name, amount)
        @info "correct_amount called"
         k = SQLite.Query(db, "SELECT Amount  FROM Goods WHERE Name = '$name';") |> DataFrame
         if(k.Amount<Union{Missing, Int64}[amount])
             println("Товара в указанном количестве нет в наличии ")
             return -1
         else return 0
         end
    end

    function correct_price(db, name, price)
        @info "correct_price called"
         k = SQLite.Query(db, "SELECT Price_per_Product  FROM Goods WHERE Name = '$name';") |> DataFrame
         if(k.Price_per_Product!=Union{Missing, Float64}[price])
             println("Данный товар недоступен по указанной цене")
             return -1
         else return 0
         end
    end

    function add_product(db) #добавление товара на склад
        @info "add_product called"
        print("Наименование: ")
        name=(readline())
        @info "product name is" name
        print("Количество единиц товара: ")
        amount = parse(Int64, readline())
        @info "product amount is" amount
        print("Цена за штуку: ")
        price = parse(Int64, readline())
        @info "price per product is" price
        do_add(db, name, amount, price)
    end

    function do_add(db, name, amount, price)
        @info "do_add called"
        k = SQLite.Query(db, "SELECT * FROM Goods;") |> DataFrame
        search_in_table = findfirst(x -> x==name, k.Name)
        if search_in_table!= nothing #если товар на складе уже есть, обновляем данные таблицы
            check = correct_price(db, name, price)
            if(check==-1)
                return
            end
            query = "UPDATE Goods SET Amount = Amount + $amount, Price_for_all = Price_for_all + ($price*$amount) WHERE Name = '$name';"
            SQLite.Query(db, query)
            @info "table updated"
        else #если товара на складе еще нет, добавляем его в таблицу
            query = "INSERT INTO Goods(Name, Amount, Price_per_product, Price_for_All) VALUES ('$name', $amount, $price, $price*$amount);"
            SQLite.Query(db, query)
            @info name "inserted into table"
         end
        make_history("add:", [name, amount, price])#добавление действия в историю операций
        @info name "added"
        curr_table = SQLite.Query(db, "SELECT * FROM Goods;")|> DataFrame
        return curr_table
    end

    function delete_product(db) #удаление товара со склада
        @info "delete_product called "
        print("Наименование: ")
        name = readline()
        print("Количество единиц товара: ")
        amount = parse(Int64, readline())
        print("Цена за штуку: ")
        price = parse(Int64, readline())
        do_delete(db, name, amount,price)
    end

    function do_delete(db, name, amount, price)
        @info "do_delete called"
        check1 = correct_name(db, name)
        if(check1==-1)
            return
        end
        check2 = correct_amount(db, name, amount)
        check3 = correct_price(db, name, price)
        if(check2==0 && check3==0)
            query = "UPDATE Goods SET Amount = Amount - $amount, Price_for_All = Price_for_All - ($price*$amount) WHERE Name = '$name';"
            SQLite.Query(db,query)
            @info "table updated"
            make_history("delete:", [name, amount])#добавление операции в историю
            @info name amount price "was deleted"
        end
         curr_table = SQLite.Query(db, "SELECT * FROM Goods;")|> DataFrame
        return curr_table
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

    function view_goods(db, inventory)#вывод общей таблицы товаров на складе
        @info "view_goods called"
        k = SQLite.Query(db, "SELECT * FROM Goods;") |> DataFrame
        file = open("report.txt", "a")
        write(file, "\nТекущее состояние склада $inventory: $k")
        make_history("view_goods", [])
        close(file)
        @info "report.txt closed"
        return k
    end

    function price_same_products(db, name, amount)#подсчет суммы одноименных единиц, требуемых к расходу
        @info "price_same_products "
        k = SQLite.Query(db, "SELECT Price_per_Product  FROM Goods WHERE Name = '$name';") |> DataFrame
        sum = 0;
        for i in k.Price_per_Product
            sum += i
        end
        sum = sum * amount
        return(sum)
    end

    function calc_consumption(db) #подсчет общей суммы требуемых к расходу товаров
        @info "calc_consumption called"
        file = open("report.txt", "a")
        @debug "report.txt opened"
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
            ans = ans+price_same_products(db, name, amount)
        end
        end
         write(file, "\nОбщая суммы требуемых к расходу товаров: $ans")
        @info "Consumption sum is" ans
        close(file)
        @debug "report.txt closed"

   end

end