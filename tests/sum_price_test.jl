#=
sum_price_test:
- Julia version: 
- Author: Анастасия
- Date: 2019-11-28
=#
include("../src/available_functions.jl")
using .available_functions
using Test
using SQLite
using DataFrames
@testset "sum_price" begin
db = SQLite.DB("dosk")
SQLite.execute!(db, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pen"
amount1 = 2
price1 = 15
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(db, query)
name2 = "pencil"
amount2 = 2
price2 = 30
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name2', $amount2, $price2, $price2*$amount2);"
SQLite.Query(db, query)
@test sum_price(db) == 90


db = SQLite.DB("dag")
SQLite.execute!(db, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pillow"
amount1 = 3
price1 = 38
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(db, query)
name2 = "bed"
amount2 = 1
price2 = 500
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name2', $amount2, $price2, $price2*$amount2);"
SQLite.Query(db, query)
@test sum_price(db) == 614

end