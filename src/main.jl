#=
main:
- Julia version: 
- Author: Анастасия
- Date: 2019-11-27
=#
using SQLite
using DataFrames
using Logging
include("available_functions.jl")
using .available_functions
include("information.jl")
using .information

actions = Dict() #словарь допустимых команд
actions["add"] = add_product
actions["delete"] = delete_product
actions["total_price"] = sum_price
actions["view_goods"] = view_goods
actions["calc_sum"] = calc_sum

logger = SimpleLogger(open("working_process.txt", "w+"))

with_logger(logger) do
    user_instruction() #вызов user_instruction, создание таблицы для конкретного склада
    @info "Program running"
    @info "user_instruction already called"
    println("Введите название склада")
    inventory = readline()
    db = SQLite.DB(inventory)
    SQLite.execute!(db, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")

    while true #выполнение операций со складом
        println("Введите опцию")
        cmd = readline()
        cmd = lowercase(cmd)
        if cmd == "exit"
            break
        else
            @info "Command '$cmd' called"
            actions[cmd](db)
        end
    end
    @info "End of the program"
end