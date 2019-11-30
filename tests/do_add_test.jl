#=
do_add_test:
- Julia version: 
- Author: Анастасия
- Date: 2019-11-30
=#
include("../src/available_functions.jl")
using .available_functions
using Test
using SQLite
using DataFrames
@testset "do_add" begin
db1 = SQLite.DB("dosk")
fg1 = SQLite.DB("dosk")
SQLite.execute!(db1, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
SQLite.execute!(fg1, "CREATE TABLE IF NOT EXISTS Testing1(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pen"
amount1 = 4
price1 = 20
query = "INSERT INTO Testing(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(fg1, query)
curr_table1 = SQLite.Query(fg1, "SELECT * FROM Testing;")|> DataFrame
@test do_add(db1, name1, amount1, price1) == curr_table1


db2 = SQLite.DB("dag")
fg2 = SQLite.DB("dag")
SQLite.execute!(db2, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
SQLite.execute!(fg2, "CREATE TABLE IF NOT EXISTS Testing(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name2 = "pillow"
amount2 = 3
price2 = 38
query = "INSERT INTO Testing(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name2', $amount2, $price2, $price2*$amount2);"
SQLite.Query(fg2,query)
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name2', $amount2, $price2, $price2*$amount2);"
SQLite.Query(db2, query)
new_amount = 1
query = "UPDATE Testing SET Amount = Amount + $new_amount, Price_for_all = Price_for_all + ($price2*$new_amount) WHERE Name = '$name2';"
SQLite.Query(fg2, query)
curr_table2 = SQLite.Query(fg2, "SELECT * FROM Testing;")|> DataFrame
@test do_delete(db2, name2, amount2, price2) == curr_table2

end