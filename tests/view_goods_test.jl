#=
view_goods_test:
- Julia version: 
- Author: Анастасия
- Date: 2019-11-28
=#
include("../src/available_functions.jl")
using .available_functions
using Test
using SQLite
using DataFrames
@testset "view_goods" begin
db1 = SQLite.DB("dosk")
SQLite.execute!(db1, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pen"
amount1 = 2
price1 = 15
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(db1, query)
name2 = "pencil"
amount2 = 1
price2 = 45
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name2', $amount2, $price2, $price2*$amount2);"
SQLite.Query(db1, query)
k1 = SQLite.Query(db1, "SELECT * FROM Goods;") |> DataFrame
@test view_goods(db1) == k1


db2 = SQLite.DB("dag")
SQLite.execute!(db, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pillow"
amount1 = 3
price1 = 38
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(db2, query)
name2 = "bed"
amount2 = 1
price2 = 500
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name2', $amount2, $price2, $price2*$amount2);"
SQLite.Query(db2, query)
k2 = SQLite.Query(db2, "SELECT * FROM Goods;") |> DataFrame
@test view_goods(db2) == k2

end