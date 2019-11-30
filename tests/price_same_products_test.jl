#=
calc_price_products_test:
- Julia version: 
- Author: Анастасия
- Date: 2019-11-28
=#
include("../src/available_functions.jl")
using .available_functions
using Test
using SQLite
using DataFrames
@testset "price_same_products" begin
db = SQLite.DB("dosk")
SQLite.execute!(db, "CREATE TABLE IF NOT EXISTS Goods(Name TEXT, Amount INT64, Price_per_Product REAL, Price_for_All REAL);")
name1 = "pen"
amount1 = 2
price1 = 15
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name1', $amount1, $price1, $price1*$amount1);"
SQLite.Query(db, query)
@test price_same_products(db, name1, amount1) == 30

name2 = "pencil"
amount2 = 1
price2 = 45
query = "INSERT INTO Goods(Name, Amount, Price_per_Product, Price_for_All) VALUES ('$name2', $amount2, $price2, $price2*$amount2);"
SQLite.Query(db, query)
@test price_same_products(db, name2, amount2) == 45

end